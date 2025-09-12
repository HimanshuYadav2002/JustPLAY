import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:music_app/Database/database.dart';
import 'package:music_app/models/user_model.dart' as local;

enum AuthStatus { unauthenticated, needsSubscription, authorized }

class AuthProvider with ChangeNotifier {
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _userDocSub;

  String? _sessionId;
  local.User? _localUser;
  AuthStatus _status = AuthStatus.unauthenticated;

  AuthProvider() {
    _init();
  }

  AuthStatus get authStatus => _status;
  local.User? get localUser => _localUser;

  Future<void> _init() async {
    final fb.User? fbUser = _auth.currentUser;

    if (fbUser != null) {
      await _loadUserStateFromCloud(fbUser);
    } else {
      final lu = await Database.getAnyUser();
      if (lu != null) {
        _localUser = lu;
      }
      _status = AuthStatus.unauthenticated;
      notifyListeners();
    }

    _auth.authStateChanges().listen((fb.User? fbUser) async {
      if (fbUser == null) {
        await _cancelUserListener();
        _localUser = null;
        _status = AuthStatus.unauthenticated;
        notifyListeners();
      } else {
        await _loadUserStateFromCloud(fbUser);
      }
    });
  }

  Future<void> _loadUserStateFromCloud(fb.User fbUser) async {
    final uid = fbUser.uid;
    final docRef = _firestore.collection('users').doc(uid);
    final snap = await docRef.get();
    final data = snap.data() ?? {};

    _sessionId = data['sessionId'] as String?;
    await _subscribeToUserDoc(uid);

    var localUser = await Database.getUserByUid(uid);
    localUser ??= local.User(uid: uid);

    localUser
      ..email = fbUser.email
      ..name = fbUser.displayName
      ..photoUrl = fbUser.photoURL
      ..sessionId = _sessionId
      ..isPremium = data['isPremium'] ?? false
      ..subscriptionPlan = data['subscriptionPlan'];

    if (data['subscriptionStart'] != null) {
      localUser.subscriptionStart = DateTime.tryParse(
        data['subscriptionStart'],
      );
    }
    if (data['subscriptionEnd'] != null) {
      localUser.subscriptionEnd = DateTime.tryParse(data['subscriptionEnd']);
    }

    await Database.upsertUser(localUser);
    _localUser = localUser;

    _evaluateSubscriptionAndSession();
  }

  Future<void> _subscribeToUserDoc(String uid) async {
    await _cancelUserListener();
    final docRef = _firestore.collection('users').doc(uid);

    _userDocSub = docRef.snapshots().listen((snap) async {
      if (!snap.exists) return;
      final data = snap.data()!;

      final cloudSessionId = data['sessionId'] as String?;
      if (_sessionId != null &&
          cloudSessionId != null &&
          cloudSessionId != _sessionId) {
        await signOutAndClearLocal(remoteInitiated: true);
        return;
      }

      if (_localUser != null) {
        _localUser!
          ..isPremium = data['isPremium'] ?? false
          ..subscriptionPlan = data['subscriptionPlan']
          ..subscriptionStart = data['subscriptionStart'] != null
              ? DateTime.tryParse(data['subscriptionStart'])
              : null
          ..subscriptionEnd = data['subscriptionEnd'] != null
              ? DateTime.tryParse(data['subscriptionEnd'])
              : null;

        await Database.upsertUser(_localUser!);
      }
      _evaluateSubscriptionAndSession();
    });
  }

  Future<void> _cancelUserListener() async {
    await _userDocSub?.cancel();
    _userDocSub = null;
  }

  void _evaluateSubscriptionAndSession() {
    final now = DateTime.now();
    if (_localUser == null) {
      _status = AuthStatus.unauthenticated;
    } else {
      final end = _localUser!.subscriptionEnd;
      final isPremium =
          _localUser!.isPremium && end != null && end.isAfter(now);

      _status = isPremium
          ? AuthStatus.authorized
          : AuthStatus.needsSubscription;
    }
    notifyListeners();
  }

  String _generateSessionId(fb.User fbUser) {
    final rand = Random().nextInt(999999);
    return '${fbUser.uid}_${DateTime.now().millisecondsSinceEpoch}_$rand';
  }

  Future<void> signInWithGoogle() async {
    final google = GoogleSignIn();
    final account = await google.signIn();
    if (account == null) return;

    final auth = await account.authentication;
    final credential = fb.GoogleAuthProvider.credential(
      accessToken: auth.accessToken,
      idToken: auth.idToken,
    );
    final userCred = await _auth.signInWithCredential(credential);
    final fb.User fbUser = userCred.user!;

    _sessionId = _generateSessionId(fbUser);

    // Update Firestore
    final docRef = _firestore.collection('users').doc(fbUser.uid);
    final newData = {
      'uid': fbUser.uid,
      'email': fbUser.email,
      'name': fbUser.displayName,
      'photoUrl': fbUser.photoURL,
      'sessionId': _sessionId,
    };
    await docRef.set(newData, SetOptions(merge: true));

    // Update or create local user
    var localUser = await Database.getUserByUid(fbUser.uid);
    localUser ??= local.User(uid: fbUser.uid);

    localUser
      ..email = fbUser.email
      ..name = fbUser.displayName
      ..photoUrl = fbUser.photoURL
      ..sessionId = _sessionId;

    await Database.upsertUser(localUser);
    _localUser = localUser;

    await _subscribeToUserDoc(fbUser.uid);
    _evaluateSubscriptionAndSession();
  }

  Future<void> signOutAndClearLocal({bool remoteInitiated = false}) async {
    try {
      await _cancelUserListener();
      await Database.clearAllLocalData();
      await _auth.signOut();
      try {
        await GoogleSignIn().signOut();
      } catch (_) {}
    } catch (_) {}

    _localUser = null;
    _sessionId = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<void> updateSubscription({
    required bool isPremium,
    DateTime? start,
    DateTime? end,
    String? plan,
  }) async {
    if (_auth.currentUser == null) return;
    final uid = _auth.currentUser!.uid;

    final docRef = _firestore.collection('users').doc(uid);
    final data = {
      'isPremium': isPremium,
      'subscriptionStart': start?.toIso8601String(),
      'subscriptionEnd': end?.toIso8601String(),
      'subscriptionPlan': plan,
    };
    await docRef.set(data, SetOptions(merge: true));

    if (_localUser != null) {
      _localUser!
        ..isPremium = isPremium
        ..subscriptionStart = start
        ..subscriptionEnd = end
        ..subscriptionPlan = plan;

      await Database.upsertUser(_localUser!);
    }
    _evaluateSubscriptionAndSession();
  }
}
