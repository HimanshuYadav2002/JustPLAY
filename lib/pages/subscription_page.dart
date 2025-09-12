import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:music_app/Providers/auth_provider.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.blue.shade800,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Subscribe",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.blue.shade500,
                          blurRadius: 50,
                          // offset: Offset(0, 10),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade400,
                    ),
                    onPressed: () async {
                      // sign out
                      await auth.signOutAndClearLocal();
                    },
                    child: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Container(
                    height: 250,
                    width: 300,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.shade900,
                          blurRadius: 30,
                          // offset: const Offset(0, 10),
                        ),
                      ],
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_month,
                              color: Colors.white,
                              size: 50,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "1 MONTH",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "₹ 20",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                  
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade900,
                          ),
                          onPressed: () async {
                            // For testing: simulate a successful 30-day subscription
                            final now = DateTime.now();
                            final end = now.add(const Duration(days: 28));
                            await auth.updateSubscription(
                              isPremium: true,
                              start: now,
                              end: end,
                              plan: 'monthly_test',
                            );
                            // auth provider will automatically switch to authorized
                            // state
                          },
                          child: const Text(
                            'Pay',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                flex: 2,
                child: Container(
                  height: 250,
                  width: 300,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(color: Colors.blue.shade900, blurRadius: 10),
                    ],
                    color: Colors.blue.shade900,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.volunteer_activism,
                            color: Colors.white,
                            size: 50,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "6 MONTHS",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "₹ 100",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: () async {
                          final now = DateTime.now();
                          final end = now.add(const Duration(days: 168));
                          await auth.updateSubscription(
                            isPremium: true,
                            start: now,
                            end: end,
                            plan: '6 month_test',
                          );
                          // auth provider will automatically switch to authorized
                          // state
                        },
                        child: const Text(
                          'Pay',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
