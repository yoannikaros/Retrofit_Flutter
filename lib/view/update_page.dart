import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/api_service.dart';

class UpdatePage extends StatefulWidget {
  const UpdatePage({Key? key}) : super(key: key);

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  ApiService _apiService = ApiService.create();
  dynamic data;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _update() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('token') ?? '';
    int userId = prefs.getInt('userId') ?? 0;

    final response = await _apiService.updateData(userId, 'Bearer ${token}', {
      'username': _usernameController.text.trim(),
      'password': _passwordController.text.trim(),
    });

    if (response.isSuccessful) {
      final responseData = response.body;
      // Proses respons setelah berhasil menambahkan pengguna baru
      print('Message: ${responseData['message']}');
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('User added successfully.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      final error = response.error;
      // Proses penanganan kesalahan saat permintaan POST gagal
      print('Error: ${error.toString()}');
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to add user.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    int userId = prefs.getInt('userId') ?? 0;
    final response = await _apiService.getDataById(userId, 'Bearer ${token}');

    if (response.isSuccessful) {
      setState(() {
        data = response.body['data'];
        _usernameController.text = data['username'];
        _passwordController.text = data['password'];
      });
    } else {
      final error = response.error;
      // Proses penanganan kesalahan saat permintaan GET gagal
      print('Error: ${error.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
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
              onPressed: _update,
              child: Text('Update User'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('back'),
            ),
          ],
        ),
      ),
    );
  }
}
