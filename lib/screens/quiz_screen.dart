import 'package:flutter/material.dart';
import '../data/quiz_data.dart';
import '../models/question_model.dart';
import 'result_screen.dart';
import 'dart:async';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _indexSoal = 0;
  int _skor = 0;
  int? _indexDipilih;
  bool _sudahJawab = false;
  Timer? _timer;
  int _waktuTersisa = 15;

  // Memudahkan mengambil soal saat ini
  Question get _soalSaatIni => daftarSoal[_indexSoal];

  // --- FITUR WAJIB SESUAI SPESIFIKASI ---

  // Mengecek apakah sudah mencapai soal terakhir
  bool isFinished() {
    return _indexSoal >= daftarSoal.length - 1;
  }

  void _mulaiTimer() {
    _timer?.cancel(); // Batalkan timer sebelumnya jika ada
    _waktuTersisa = 15; // Reset waktu ke 15 detik

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_waktuTersisa > 0) {
          _waktuTersisa--;
        } else {
          _timer?.cancel();
          _handleWaktuHabis();
        }
      });
    });
  }

  void _handleWaktuHabis() {
    if (!_sudahJawab) {
      _pilihJawaban(-1); // Kirim index -1 sebagai tanda tidak menjawab
    }
  }

  // Mengulang kuis dari awal
  void reset() {
    setState(() {
      _indexSoal = 0;
      _skor = 0;
      _indexDipilih = null;
      _sudahJawab = false;
    });
  }

  // Logika saat user memilih jawaban
  void _pilihJawaban(int index) {
    if (_sudahJawab) return;
    _timer?.cancel(); // Menghentikan waktu segera setelah tombol diklik
    setState(() {
      _indexDipilih = index;
      _sudahJawab = true;
      if (_soalSaatIni.isBenar(index)) {
        _skor++;
      }
    });
  }

  // Logika navigasi dan alert kuis selesai
  void _lanjutSoal() {
    if (!isFinished()) {
      setState(() {
        _indexSoal++;
        _indexDipilih = null;
        _sudahJawab = false;
      });
      _mulaiTimer(); // Menyalakan ulang timer untuk soal baru
      
    } else {
      // Implementasi Kondisi Akhir Kuis (Alert Dialog Wajib)
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Kuis Selesai!'),
          content: Text('Anda telah menjawab semua soal. Skor akhir Anda: $_skor'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Tutup Dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ResultScreen(
                      skor: _skor,
                      total: daftarSoal.length,
                    ),
                  ),
                );
              },
              child: const Text('LIHAT HASIL'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    daftarSoal.shuffle();
    _mulaiTimer();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Penting agar tidak terjadi kebocoran memori
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_indexSoal + 1) / daftarSoal.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quizey App'),
        centerTitle: true,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Indikator Progress
            LinearProgressIndicator(value: progress),
            const SizedBox(height: 8),
            Text(
              'Soal ${_indexSoal + 1} dari ${daftarSoal.length}',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.end,
            ),
            const SizedBox(height: 28),

            // Hitungan Waktu
            Text(
              'Sisa Waktu: $_waktuTersisa detik',
              style: TextStyle(
                color: _waktuTersisa <= 5 ? Colors.red : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Teks Pertanyaan
            Text(
              _soalSaatIni.soal,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 28),

            // Pilihan Jawaban (List mapping)
            ...List.generate(_soalSaatIni.pilihan.length, (i) {
              return _buildPilihan(i);
            }),

            const Spacer(),

            // Tombol Navigasi (Hanya muncul jika sudah dijawab)
            if (_sudahJawab)
              FilledButton(
                onPressed: _lanjutSoal,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  isFinished() ? 'Selesaikan Kuis' : 'Soal Berikutnya',
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Widget untuk tombol pilihan jawaban
  Widget _buildPilihan(int i) {
    Color? warnaBorder = Colors.grey.shade300;
    Color? warnaBg = Colors.transparent;
    Widget? iconIndikator;

    // Logika Indikator ✅ dan ❌
    if (_sudahJawab) {
      if (i == _soalSaatIni.indexJawaban) {
        warnaBg = Colors.green.shade50;
        warnaBorder = Colors.green;
        iconIndikator = const Icon(Icons.check_circle, color: Colors.green);
      } else if (i == _indexDipilih) {
        warnaBg = Colors.red.shade50;
        warnaBorder = Colors.red;
        iconIndikator = const Icon(Icons.cancel, color: Colors.red);
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _pilihJawaban(i),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: warnaBg,
            border: Border.all(color: warnaBorder, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  _soalSaatIni.pilihan[i],
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              if (iconIndikator != null) iconIndikator,
            ],
          ),
        ),
      ),
    );
  }
}