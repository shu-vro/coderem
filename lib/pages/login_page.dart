import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final TextEditingController _handleController = TextEditingController();
  final SharedPreferencesAsync prefs = SharedPreferencesAsync();
  bool _isCheckingUser = false;

  Future<void> _submitHandle() async {
    final handle = _handleController.text;
    if (handle.isNotEmpty) {
      await prefs.setString('handle', handle);
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      final snackBar = SnackBar(
        content: const Text('Handle cannot be empty'),
        action: SnackBarAction(
          label: 'Ok',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      );

      // Find the ScaffoldMessenger in the widget tree
      // and use it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void initState() {
    super.initState();
    if (!_isCheckingUser) {
      _isCheckingUser = true;
      _checkIfUserExists();
    }
  }

  Future<void> _checkIfUserExists() async {
    final handle = await prefs.getString('handle');
    if (handle != null) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/login.png'),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _handleController,
                decoration: InputDecoration(
                  labelText: 'Enter your Codeforces handle',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            FilledButton.tonal(
              onPressed: _submitHandle,
              child: Text('Login with Codeforces'),
            ),
          ],
        ),
      ),
    );
  }
}
