import 'package:flutter/material.dart';
import '../controller/api_service.dart';
import 'login.dart';
import 'new_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ApiService _apiService = ApiService.create();
  dynamic data;

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // Menghapus token dari SharedPreferences
    await prefs.remove('userId'); // Menghapus token dari SharedPreferences
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    int userId = prefs.getInt('userId') ?? 0;

    if (token.isEmpty || userId == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }

    final response = await _apiService.getDataById(userId, 'Bearer ${token}');

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
                      Navigator.pushNamed(context, '/create');
                    },
                    child: Text('Add User'),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _logout,
                    child: Text('Keluar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/update', (route) => false);
                    },
                    child: Text('Update'),
                  ),
                ],
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
