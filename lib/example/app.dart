import 'package:flutter/material.dart';

import 'form.dart';

class ExampleApp extends StatelessWidget {
  const ExampleApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Testing app',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        body: ExampleForm(),
      ),
    );
  }
}
