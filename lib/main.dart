import 'package:flutter/material.dart';
import 'screens/quiz_screen.dart';

void main() {
  runApp(const QuizeyApp());
}

class QuizeyApp extends StatelessWidget {
  const QuizeyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quizey',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        useMaterial3: true,
      ),
      home: const QuizScreen(),
    );
  }
}