class Question {
  final String soal;
  final List<String> pilihan;
  final int indexJawaban;

  const Question({
    required this.soal,
    required this.pilihan,
    required this.indexJawaban,
  });

  // Cek apakah jawaban yang dipilih benar
  bool isBenar(int indexDipilih) {
    return indexDipilih == indexJawaban;
  }
}