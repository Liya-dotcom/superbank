import 'package:flutter/material.dart';

class WithdrawPage extends StatefulWidget {
  const WithdrawPage({super.key});

  @override
  _WithdrawPageState createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String _selectedMethod = 'Bank Transfer'; // Default withdrawal method

  @override
  void dispose() {
    _accountNumberController.dispose();
    _amountController.dispose();
    super.dispose();
  }

 void _withdraw() {
  if (_formKey.currentState!.validate()) {
    double amount = double.tryParse(_amountController.text) ?? 0;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }
    
    // Here you would typically check available balance
    // before proceeding with withdrawal
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Withdrawing Rs${amount.toStringAsFixed(2)} via $_selectedMethod'),
        backgroundColor: const Color.fromARGB(237, 6, 223, 176),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001F3F), // Dark blue background
      appBar: AppBar(
        title: const Text('Withdraw', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(237, 6, 223, 176),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDropdownField(),
              const SizedBox(height: 20),
              _buildTextField(_accountNumberController, 'Account Number'),
              const SizedBox(height: 20),
              _buildTextField(_amountController, 'Amount'),
              const SizedBox(height: 30),
              _buildWithdrawButton(),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the dropdown for withdrawal method selection
  Widget _buildDropdownField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.blue[700], // Matches input fields
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedMethod,
          dropdownColor: Colors.blue[700],
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          style: const TextStyle(color: Colors.white, fontSize: 16),
          items: ['Bank Transfer', 'Mobile Money', 'Crypto Wallet'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: const TextStyle(color: Colors.white)),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              _selectedMethod = newValue!;
            });
          },
        ),
      ),
    );
  }

  /// Builds a rounded input field
  Widget _buildTextField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.blue[700], // Dark blue input background
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color:  Color.fromARGB(237, 6, 223, 176), width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  /// Builds the "Withdraw" button
  Widget _buildWithdrawButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _withdraw,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(237, 6, 223, 176), // Custom button color
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text('Withdraw', style: TextStyle(color: Colors.white, fontSize: 18)),
      ),
    );
  }
}
