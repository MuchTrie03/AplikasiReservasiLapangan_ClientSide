import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'APLIKASI CLIENT',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Menonaktifkan debug banner
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
