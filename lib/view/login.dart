import 'package:flutter/material.dart';
import '../controller/api_service.dart';
import 'home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  ApiService _apiService = ApiService.create();

  void _saveToken(String token, int userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('token', token);
    await prefs.setInt('userId', userId);
  }

  void _login() async {
    final response = await _apiService.login({
      'username': _usernameController.text.trim(),
      'password': _passwordController.text.trim(),
    });

    if (response.isSuccessful) {
      final loginResponse = response.body;
      // Proses respons login yang berhasil
      print('Message: ${loginResponse['message']}');
      print('User ID: ${loginResponse['userId']}');
      print('Token: ${loginResponse['token']}');

      _saveToken(loginResponse['token'], loginResponse['userId']);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            token: loginResponse['token'],
            userid: loginResponse['userId'],
          ),
        ),
      );
    } else {
      final error = response.error;
      // Proses penanganan kesalahan saat login gagal
      print('Error: ${error.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
