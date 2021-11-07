import 'package:flutter/material.dart';
import '../widgets/read_file.dart';
import '../widgets/head.dart';

class Info extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Info')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: const <Widget>[
                Head(),
                Icon(Icons.info_outline, size: 60, color: Color(0xFF1565C0)),
                Divider(),
                SizedBox(height: 10.0),
                ReadFile(archivo: 'assets/files/info.txt'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
