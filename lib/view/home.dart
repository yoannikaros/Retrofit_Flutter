import 'package:flutter/material.dart';
import '../controller/api_service.dart';
import 'login.dart';
import 'new_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final String token;
  final int userid;

  HomePage({required this.token, required this.userid});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ApiService _apiService = ApiService.create();
  dynamic data;

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // Menghapus token dari SharedPreferences
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    final response =
        await _apiService.getDataById(widget.userid, 'Bearer ${widget.token}');

    if (response.isSuccessful) {
      setState(() {
        data = response.body['data'];
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
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: data != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('ID: ${data['id']}'),
                  Text('Username: ${data['username']}'),
                  Text('Password: ${data['password']}'),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              NewUserPage(token: widget.token),
                        ),
                      );
                    },
                    child: Text('Add User'),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _logout,
                    child: Text('Keluar'),
                  ),
                ],
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
