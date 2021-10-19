import 'package:bdaej/app/modules/home/screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const BDAEJ());
}

class BDAEJ extends StatelessWidget {
  const BDAEJ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Banco de Dados 1',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}
