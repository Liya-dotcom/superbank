import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRPaymentScreen extends StatelessWidget {
  const QRPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR Payment')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImageView(
              data: 'https://yourpaymentgateway.com/pay/user123',
              version: QrVersions.auto,
              size: 200.0,
            ),
            const SizedBox(height: 20),
            const Text('Scan this QR code to make payment'),
          ],
        ),
      ),
    );
  }
}