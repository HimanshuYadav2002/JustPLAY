import 'package:flutter/material.dart';
import 'package:music_app/Providers/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _scale = 0.95; // shrink a little when pressed
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _scale = 1.0; // back to normal
    });
  }

  void _onTapCancel() {
    setState(() {
      _scale = 1.0; // reset if user cancels tap
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            /// Background gradient image
            SizedBox.expand(
              child: Image.asset(
                "assets/images/gradient_baground.png",
                fit: BoxFit.cover,
              ),
            ),

            /// Foreground UI
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 120),

                  /// App Logo
                  Image.asset(
                    "assets/images/logo.png",
                    width: MediaQuery.of(context).size.width,
                  ),
                  const SizedBox(height: 10),

                  /// Waveform
                  Image.asset(
                    "assets/images/waveform.png",
                    width: MediaQuery.of(context).size.width,
                  ),
                  const SizedBox(height: 10),

                  /// Google Login Button with Animation
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: GestureDetector(
                      onTapDown: _onTapDown,
                      onTapUp: _onTapUp,
                      onTapCancel: _onTapCancel,
                      onTap: () async {
                        await auth.signInWithGoogle();
                      },
                      child: AnimatedScale(
                        scale: _scale,
                        duration: const Duration(milliseconds: 120),
                        curve: Curves.easeInOut,
                        child: Container(
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black54,
                                blurRadius: 30,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/google_logo.png",
                                height: 28,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                "Login with Google",
                                style: TextStyle(
                                  fontFamily: "GoogleSans",
                                  color: Colors.black.withAlpha(170),
                                  fontSize: 21,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 150),

                  /// Footer text
                  const Text(
                    "Made in India with ❤️",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
