// lib/data/writers_data.dart

class WriterDataRow {
  final int writerId;
  final String writerEnglish;

  const WriterDataRow({
    required this.writerId,
    required this.writerEnglish,
  });
}

class WriterData {
  static const List<WriterDataRow> rows = [
    WriterDataRow(writerId: 1, writerEnglish: 'Guru Nanak Dev Ji'),
    WriterDataRow(writerId: 2, writerEnglish: 'Guru Angad Dev Ji'),
    WriterDataRow(writerId: 3, writerEnglish: 'Guru Amar Daas Ji'),
    WriterDataRow(writerId: 4, writerEnglish: 'Guru Raam Daas Ji'),
    WriterDataRow(writerId: 5, writerEnglish: 'Guru Arjan Dev Ji'),
    WriterDataRow(writerId: 6, writerEnglish: 'Guru Tegh Bahaadur Ji'),
    WriterDataRow(writerId: 47, writerEnglish: 'Guru Gobind Singh Ji'),
    WriterDataRow(writerId: 12, writerEnglish: 'Bhagat Kabeer Ji'),
    WriterDataRow(writerId: 13, writerEnglish: 'Bhagat Naam Dev Ji'),
    WriterDataRow(writerId: 16, writerEnglish: 'Bhagat Ravi Daas Ji'),
    WriterDataRow(writerId: 21, writerEnglish: 'Bhagat Sheikh Fareed Ji'),
    WriterDataRow(writerId: 10, writerEnglish: 'Bhagat Trilochan Ji'),
    WriterDataRow(writerId: 9, writerEnglish: 'Bhagat Dhannaa Ji'),
    WriterDataRow(writerId: 7, writerEnglish: 'Bhagat Bheekhan Ji'),
    WriterDataRow(writerId: 8, writerEnglish: 'Bhagat Beni Ji'),
    WriterDataRow(writerId: 11, writerEnglish: 'Bhagat Jaidev Ji'),
    WriterDataRow(writerId: 14, writerEnglish: 'Bhagat Peepaa Ji'),
    WriterDataRow(writerId: 15, writerEnglish: 'Bhagat Parmaanand Ji'),
    WriterDataRow(writerId: 17, writerEnglish: 'Bhagat Raamaanand Ji'),
    WriterDataRow(writerId: 18, writerEnglish: 'Bhagat Surdaas Ji'),
    WriterDataRow(writerId: 19, writerEnglish: 'Bhagat Saadhnaa Ji'),
    WriterDataRow(writerId: 20, writerEnglish: 'Bhagat Sain Ji'),
    WriterDataRow(writerId: 22, writerEnglish: 'Bhai Gurdaas Ji'),
    WriterDataRow(writerId: 48, writerEnglish: 'Bhai Nand Lal Ji'),
    WriterDataRow(writerId: 43, writerEnglish: 'Bhai Mardana'),
    WriterDataRow(writerId: 30, writerEnglish: 'Bhatt Bal'),
    WriterDataRow(writerId: 31, writerEnglish: 'Bhatt Sathaa & Balvand'),
    WriterDataRow(writerId: 33, writerEnglish: 'Bhatt Gayandh'),
    WriterDataRow(writerId: 42, writerEnglish: 'Bhatt Mathuraa'),
    WriterDataRow(writerId: 39, writerEnglish: 'Bhatt Kal'),
    WriterDataRow(writerId: 38, writerEnglish: 'Bhatt Keerath'),
    WriterDataRow(writerId: 35, writerEnglish: 'Bhatt Bhikhaa'),
    WriterDataRow(writerId: 34, writerEnglish: 'Bhatt Harbans'),
  ];
}