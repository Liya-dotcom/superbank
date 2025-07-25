import 'package:flutter/material.dart';
import 'package:superbank/screens/pages/account.dart';
import 'package:superbank/screens/pages/credit_card.dart';
import 'package:superbank/screens/pages/mobile_recharge.dart';
import 'package:superbank/screens/pay_bill.dart';
import 'package:superbank/screens/pages/transaction_report.dart';
import 'package:superbank/screens/pages/transfer.dart';
import 'package:superbank/screens/withdraw.dart';




class Homecontent extends StatelessWidget {
  const Homecontent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade900, // Matched Login Page
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900, // Deep Blue
        elevation: 0, // No shadow
        automaticallyImplyLeading: false, // Removes the back arrow
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _upperText(),
            _materCardSection(),
            const SizedBox(height: 30),
            _middleScreenButtons(context),
          ],
        ),
      ),
    );
  }

  // Grid Menu Section
  Widget _middleScreenButtons(BuildContext context) {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        children: [
          _buildMenuItem(
            Icons.account_balance_wallet,
            'Account\nand Card',
            () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AccountAndCardPage())),
          ),
          _buildMenuItem(
            Icons.swap_horiz,
            'Transfer',
            () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TransferPage())),
          ),
          _buildMenuItem(
            Icons.attach_money,
            'Withdraw',
            () => Navigator.push(context, MaterialPageRoute(builder: (context) => const WithdrawPage())),
          ),
          _buildMenuItem(
            Icons.phone_android,
            'Mobile\nrecharge',
            () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MobileRechargePage())),
          ),
          _buildMenuItem(
            Icons.receipt,
            'Pay the bill',
            () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PayBillsPage())),
          ),
          _buildMenuItem(
            Icons.credit_card,
            'Credit card',
            () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CreditCardPage())),
          ),
          _buildMenuItem(
            Icons.insert_chart,
            'Transaction\nreport',
            () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TransactionReportPage())),
          ),
        ],
      ),
    );
  }

  // Menu Item Widget (Styled like Login Page)
  Widget _buildMenuItem(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.blue.shade800, // Matched Login Page Fields
            child: Icon(icon, color: const Color.fromARGB(237, 6, 223, 176), size: 30), // Orange Accent
          ),
          const SizedBox(height: 10),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

// Greeting Section
Widget _upperText() {
  return const Padding(
    padding: EdgeInsets.only(top: 20.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Good Morning,',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Text(
          'Vuyolwethu',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color.fromARGB(237, 6, 223, 176)),
        ),
        SizedBox(height: 20),
      ],
    ),
  );
}

// Card Section (Styled like Login Page)
Widget _materCardSection() {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: Colors.blue.shade800, // Deep Blue (like input fields)
      border: Border.all(color: Color.fromARGB(237, 6, 223, 176), width: 2), // Orange Border
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Vuyolwethu Thebe',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Lady Frere, Eastern Cape',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 15),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '3258 •••• •••• 7032',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              Text(
                '\R4,500.52',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Align(
            alignment: Alignment.bottomRight,
            child: Text(
              'VISA',
              style: TextStyle(
                color: Color.fromARGB(237, 6, 223, 176),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
