import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'home/UI/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: kDebugMode,
      title: 'Flutter Demo',
      theme: ThemeData(
        //brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
    );
  }
}
