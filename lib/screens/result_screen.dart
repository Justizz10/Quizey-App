import 'package:flutter/material.dart';
import 'quiz_screen.dart';

class ResultScreen extends StatelessWidget {
  final int skor;
  final int total;

  const ResultScreen({super.key, required this.skor, required this.total});

  @override
  Widget build(BuildContext context) {
    // Menghitung presentase skor (opsional untuk pemanis)
    double presentase = (skor / total) * 100;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Hasil Kuis",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),
              Text(
                "$skor / $total",
                style: const TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              Text(
                "Skor Akhir: ${presentase.toInt()}%",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 40),

              // Tombol Reset sesuai Spesifikasi Poin 4
              FilledButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const QuizScreen()),
                  );
                },
                icon: const Icon(Icons.refresh),
                label: const Text("Reset Kuis"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}