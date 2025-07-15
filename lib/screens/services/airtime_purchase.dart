import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superbank/lib/models/user_model.dart';
import 'package:superbank/lib/services/transaction_service.dart';
import 'package:superbank/lib/widgets/custom_button.dart';
import '../../dashboard/dashboard_screen.dart';

class AirtimePurchaseScreen extends StatefulWidget {
  const AirtimePurchaseScreen({super.key});

  @override
  State<AirtimePurchaseScreen> createState() => _AirtimePurchaseScreenState();
}

class _AirtimePurchaseScreenState extends State<AirtimePurchaseScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String _selectedNetwork = 'MTN';
  bool _isLoading = false;

  final List<String> _networks = ['MTN', 'Airtel', 'Glo', '9mobile', "Vodacom", "Telkom", "Cell C", "Rain", "Afrihost", "FNB Connect", "Lycamobile", "Virgin Mobile", "Telkom Mobile", "MTN South Africa", "Airtel Nigeria", "Glo Nigeria", "9mobile Nigeria"];

  Future<void> _purchaseAirtime() async {
    if (_phoneController.text.isEmpty || _amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() => _isLoading = true);
    
    final user = Provider.of<UserModel?>(context, listen: false);
    final transactionService = TransactionService();

    try {
      await transactionService.purchaseAirtime(
        userId: user!.uid,
        phoneNumber: _phoneController.text,
        amount: double.parse(_amountController.text),
        network: _selectedNetwork,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Airtime purchase successful!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buy Airtime')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedNetwork,
              items: _networks.map((network) {
                return DropdownMenuItem(
                  value: network,
                  child: Text(network),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedNetwork = value!),
              decoration: const InputDecoration(labelText: 'Network'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixIcon: Icon(Icons.attach_money),
              ),
            ),
            const SizedBox(height: 30),
            CustomButton(
              text: 'Purchase Airtime',
              onPressed: _purchaseAirtime,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}