import 'package:flutter/material.dart';
import '../maindashboard.dart';

class TransactionSuccessScreen extends StatelessWidget {
  final String amount;
  final String transactionType;
  final String? recipient;

  const TransactionSuccessScreen({
    super.key,
    required this.amount,
    required this.transactionType,
    this.recipient,
  });

  @override
  Widget build(BuildContext context) {
  assert(amount.isNotEmpty, 'Transaction amount should not be empty');

  return Scaffold(
    appBar: AppBar(
      title: const Text('Transaction Successful'),
      automaticallyImplyLeading: false,
    ),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 100, color: Colors.green),
            const SizedBox(height: 30),
            Text(
              '$transactionType Successful!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            if (recipient != null)
              Text(
                'To: $recipient',
                style: const TextStyle(fontSize: 18),
              ),
            Text(
              'Amount: R$amount',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const DashboardPage()),
                ).catchError((e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('An error occurred: ${e.toString()}')),
                  );
                });
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text('Back to Dashboard'),
            ),
          ],
        ),
      ),
    ),
  );
}
}