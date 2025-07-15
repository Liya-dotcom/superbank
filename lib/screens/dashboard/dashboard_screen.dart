import 'package:flutter/material.dart';
import '../transactions/withdraw_screen.dart';
import '../transactions/deposit_screen.dart';
import '../transactions/transfer_screen.dart';
import '../transactions/balance_screen.dart';
//import 'package:superbank/lib/screens/login_screen.dart';
import '../auth/login_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SuperBank Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: [
            _buildFeatureCard(
              context,
              Icons.money_off,
              'Withdraw',
              Colors.redAccent,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WithdrawScreen(),
                  ),
                );
              },
            ),
            _buildFeatureCard(
              context,
              Icons.money,
              'Deposit',
              Colors.greenAccent,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DepositScreen(),
                  ),
                );
              },
            ),
            _buildFeatureCard(
              context,
              Icons.swap_horiz,
              'Transfer',
              Colors.blueAccent,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TransferScreen(),
                  ),
                );
              },
            ),
            _buildFeatureCard(
              context,
              Icons.account_balance_wallet,
              'Balance',
              Colors.orangeAccent,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BalanceScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    IconData icon,
    String title,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
              color: color,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}