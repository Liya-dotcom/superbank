import 'package:flutter/material.dart';


class ElectricityPurchaseScreen extends StatefulWidget {
  const ElectricityPurchaseScreen({super.key});

  @override
  _ElectricityPurchaseScreenState createState() => _ElectricityPurchaseScreenState();
}

class _ElectricityPurchaseScreenState extends State<ElectricityPurchaseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Electricity Purchase'),
      ),
      body: Center(
        child: const Text('Electricity Purchase Screen'),
      ),
    );
  }
}
