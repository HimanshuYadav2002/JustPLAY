import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:music_app/Database/database.dart';
import 'package:music_app/Providers/auth_provider.dart';
import 'package:music_app/Providers/data_provider.dart';
import 'package:music_app/Providers/navigation_index_provider.dart';
import 'package:music_app/firebase_options.dart';
import 'package:music_app/just_play.dart';
import 'package:music_app/pages/login_page.dart';
import 'package:music_app/pages/subscription_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Database.instance;
  await Permission.manageExternalStorage.request();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DataProvider()),
        ChangeNotifierProvider(create: (_) => CurrentIndexProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: RootApp(),
    ),
  );
}

// here all the logic of login page and subscriptionpage redirection will go
class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    if (auth.authStatus == AuthStatus.unauthenticated) {
      return const LoginPage();
    }
    if (auth.authStatus == AuthStatus.needsSubscription) {
      return const SubscriptionPage();
    }

    return JustPlay();
  }
}
