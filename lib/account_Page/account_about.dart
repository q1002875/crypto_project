import 'package:flutter/material.dart';

class AccoundAbout extends StatelessWidget {
  const AccoundAbout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // 這裡的 Icon 可以自行更換
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.blueGrey,
      ),
      body: ListView(
        children: const <Widget>[
          ListTile(
            title: Text('Version'),
            trailing: Text('1.0.0'), // 將這裡的 '1.0.0' 替換為您的實際版本號
          ),
        ],
      ),
    ));
  }
}
