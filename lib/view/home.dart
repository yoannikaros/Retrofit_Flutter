import 'package:flutter/material.dart';
import '../controller/api_service.dart';

class HomePage extends StatefulWidget {
  final String token;

  HomePage({required this.token});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ApiService _apiService = ApiService.create();
  dynamic data;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    final response = await _apiService.getDataById(1, 'Bearer ${widget.token}');

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
                ],
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
