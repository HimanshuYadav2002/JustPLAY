import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:music_app/Providers/auth_provider.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Subscribe')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Subscription page placeholder. Integrate paymenthere.'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // For testing: simulate a successful 30-day subscription
                  final now = DateTime.now();
                  final end = now.add(const Duration(days: 30));
                  await auth.updateSubscription(
                    isPremium: true,
                    start: now,
                    end: end,
                    plan: 'monthly_test',
                  );
                  // auth provider will automatically switch to authorized
                  // state
                },
                child: const Text('Simulate success (30 days)'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () async {
                  // sign out
                  await auth.signOutAndClearLocal();
                },
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
