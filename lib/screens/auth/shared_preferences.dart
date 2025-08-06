import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../dashboard/dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _showError = false;
  String _errorMessage = '';
  bool _rememberMe = false;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _initPreferences();
  }

  Future<void> _initPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberMe = _prefs.getBool('rememberMe') ?? false;
      if (_rememberMe) {
        _emailController.text = _prefs.getString('savedEmail') ?? '';
        _passwordController.text = _prefs.getString('savedPassword') ?? '';
      }
    });
  }

  Future<void> _saveCredentials() async {
    if (_rememberMe) {
      await _prefs.setString('savedEmail', _emailController.text.trim());
      await _prefs.setString('savedPassword', _passwordController.text.trim());
      await _prefs.setBool('rememberMe', true);
    } else {
      await _prefs.remove('savedEmail');
      await _prefs.remove('savedPassword');
      await _prefs.setBool('rememberMe', false);
    }
  }

  Future<void> _clearCredentials() async {
    await _prefs.remove('savedEmail');
    await _prefs.remove('savedPassword');
    await _prefs.setBool('rememberMe', false);
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _showError = true;
        _errorMessage = 'Please enter both email and password';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _showError = false;
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      
      if (!userCredential.user!.emailVerified) {
        await userCredential.user!.sendEmailVerification();
        setState(() {
          _isLoading = false;
          _showError = true;
          _errorMessage = 'Please verify your email first. We sent a new verification link.';
        });
        return;
      }

      await _saveCredentials();
      
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    } on FirebaseAuthException catch (e) {
      await _clearCredentials();
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found with this email';
          break;
        case 'wrong-password':
          message = 'Incorrect password';
          break;
        case 'invalid-email':
          message = 'Invalid email format';
          break;
        case 'user-disabled':
          message = 'This account has been disabled';
          break;
        case 'too-many-requests':
          message = 'Too many attempts. Try again later';
          break;
        default:
          message = 'Login failed. Please try again';
      }
      setState(() {
        _showError = true;
        _errorMessage = message;
      });
    } catch (e) {
      await _clearCredentials();
      setState(() {
        _showError = true;
        _errorMessage = 'An error occurred. Please try again';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Login Screen")
      )
    );
  }

}

