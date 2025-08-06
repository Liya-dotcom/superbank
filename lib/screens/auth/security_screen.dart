import 'package:flutter/material.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool _biometricEnabled = false;
  bool _twoFactorEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Security Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Enable Biometric Login'),
              value: _biometricEnabled,
              onChanged: (value) {
                setState(() {
                  _biometricEnabled = value;
                });
                // TODO: Implement biometric logic
              },
              secondary: const Icon(Icons.fingerprint),
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('Enable Two-Factor Authentication'),
              value: _twoFactorEnabled,
              onChanged: (value) {
                setState(() {
                  _twoFactorEnabled = value;
                });
                // TODO: Implement 2FA logic
              },
              secondary: const Icon(Icons.verified_user),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.lock_reset),
              title: const Text('Change Password'),
              onTap: () {
                // TODO: Implement change password logic
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Change password tapped')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}