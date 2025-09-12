import 'package:isar/isar.dart';

part 'user_model.g.dart';

@collection
class User {
  Id isarId = Isar.autoIncrement;

  // Firebase UID (primary unique identifier)
  late String uid;

  String? email;
  String? name;
  String? photoUrl;

  // Session ID used for single-session enforcement
  String? sessionId;

  // Subscription
  bool isPremium;
  DateTime? subscriptionStart;
  DateTime? subscriptionEnd;
  String? subscriptionPlan;

  User({
    required this.uid,
    this.email,
    this.name,
    this.photoUrl,
    this.sessionId,
    this.isPremium = false,
    this.subscriptionStart,
    this.subscriptionEnd,
    this.subscriptionPlan,
  });
}
