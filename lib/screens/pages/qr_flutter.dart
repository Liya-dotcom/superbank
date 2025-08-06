import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';

class QRCodePage extends StatelessWidget {
  final String checkoutUrl;

  const QRCodePage({super.key, required this.checkoutUrl});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Scan to Pay")),
      body: Center(
        child: QrImageView(
          data: checkoutUrl,
          version: QrVersions.auto,
          size: 250.0,
        ),
      ),
    );
  }
}
