import 'package:flutter/material.dart';
import 'screens/home_screen.dart'; // Import home screen baru

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quizey',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue, // Tema warna dasar biru
      ),
      home: const HomeScreen(), // Ubah ini dari QuizScreen ke HomeScreen
    );
  }
}