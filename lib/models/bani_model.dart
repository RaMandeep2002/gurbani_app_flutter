
class BaniVerse {
  final int? verseId;
  final int? shabadId;
  final VerseData verse;
  final Larivaar? larivaar;
  final Translation? translation;
  final Transliteration? transliteration;
  final int? pageNo;
  final int? lineNo;
  final String? updated;
  final Visraam? visraam;
  final Writer? writer;
  final Source? source;
  final Raag? raag;

  BaniVerse({
    this.verseId,
    this.shabadId,
    required this.verse,
    this.larivaar,
    this.translation,
    this.transliteration,
    this.pageNo,
    this.lineNo,
    this.updated,
    this.visraam,
    this.writer,
    this.source,
    this.raag,
  });

  factory BaniVerse.fromJson(Map<String, dynamic> json) {
    return BaniVerse(
      verseId: json['verseId'],
      shabadId: json['shabadId'],
      verse: VerseData.fromJson(json['verse'] ?? {}),
      larivaar: json['larivaar'] != null
          ? Larivaar.fromJson(json['larivaar'])
          : null,
      translation: json['translation'] != null
          ? Translation.fromJson(json['translation'])
          : null,
      transliteration: json['transliteration'] != null
          ? Transliteration.fromJson(json['transliteration'])
          : null,
      pageNo: json['pageNo'],
      lineNo: json['lineNo'],
      updated: json['updated'],
      visraam: json['visraam'] != null
          ? Visraam.fromJson(json['visraam'])
          : null,
      writer: json['writer'] != null ? Writer.fromJson(json['writer']) : null,
      source: json['source'] != null ? Source.fromJson(json['source']) : null,
      raag: json['raag'] != null ? Raag.fromJson(json['raag']) : null,
    );
  }
}

class VerseData {
  final String? gurmukhi;
  final String? unicode;

  VerseData({this.gurmukhi, this.unicode});

  factory VerseData.fromJson(Map<String, dynamic> json) {
    return VerseData(gurmukhi: json['gurmukhi'], unicode: json['unicode']);
  }
}

class Larivaar {
  final String? gurmukhi;
  final String? unicode;

  Larivaar({this.gurmukhi, this.unicode});

  factory Larivaar.fromJson(Map<String, dynamic> json) {
    return Larivaar(gurmukhi: json['gurmukhi'], unicode: json['unicode']);
  }
}

class Translation {
  final En? en;
  final Pu? pu;
  final Es? es;
  final Hi? hi;

  Translation({this.en, this.pu, this.es, this.hi});

  factory Translation.fromJson(Map<String, dynamic> json) {
    return Translation(
      en: json['en'] != null ? En.fromJson(json['en']) : null,
      pu: json['pu'] != null ? Pu.fromJson(json['pu']) : null,
      es: json['es'] != null ? Es.fromJson(json['es']) : null,
      hi: json['hi'] != null ? Hi.fromJson(json['hi']) : null,
    );
  }
}

class En {
  final String? bdb;
  final String? ms;
  final String? ssk;

  En({this.bdb, this.ms, this.ssk});

  factory En.fromJson(Map<String, dynamic> json) {
    return En(bdb: json['bdb'], ms: json['ms'], ssk: json['ssk']);
  }
}

class Pu {
  final Ss? ss;
  final Ft? ft;
  final Bdb? bdb;
  final Ms? ms;

  Pu({this.ss, this.ft, this.bdb, this.ms});

  factory Pu.fromJson(Map<String, dynamic> json) {
    return Pu(
      ss: json['ss'] != null ? Ss.fromJson(json['ss']) : null,
      ft: json['ft'] != null ? Ft.fromJson(json['ft']) : null,
      bdb: json['bdb'] != null ? Bdb.fromJson(json['bdb']) : null,
      ms: json['ms'] != null ? Ms.fromJson(json['ms']) : null,
    );
  }
}

class Ss {
  final String? gurmukhi;
  final String? unicode;

  Ss({this.gurmukhi, this.unicode});

  factory Ss.fromJson(Map<String, dynamic> json) {
    return Ss(gurmukhi: json['gurmukhi'], unicode: json['unicode']);
  }
}

class Ft {
  final String? gurmukhi;
  final String? unicode;

  Ft({this.gurmukhi, this.unicode});

  factory Ft.fromJson(Map<String, dynamic> json) {
    return Ft(gurmukhi: json['gurmukhi'], unicode: json['unicode']);
  }
}

class Bdb {
  final String? gurmukhi;
  final String? unicode;

  Bdb({this.gurmukhi, this.unicode});

  factory Bdb.fromJson(Map<String, dynamic> json) {
    return Bdb(gurmukhi: json['gurmukhi'], unicode: json['unicode']);
  }
}

class Ms {
  final String? gurmukhi;
  final String? unicode;

  Ms({this.gurmukhi, this.unicode});

  factory Ms.fromJson(Map<String, dynamic> json) {
    return Ms(gurmukhi: json['gurmukhi'], unicode: json['unicode']);
  }
}

class Es {
  final String? sn;

  Es({this.sn});

  factory Es.fromJson(Map<String, dynamic> json) {
    return Es(sn: json['sn']);
  }
}

class Hi {
  final String? ss;
  final String? sts;

  Hi({this.ss, this.sts});

  factory Hi.fromJson(Map<String, dynamic> json) {
    return Hi(ss: json['ss'], sts: json['sts']);
  }
}

class Transliteration {
  final String? english;
  final String? hindi;
  final String? en;
  final String? hi;
  final String? ipa;
  final String? ur;

  Transliteration({
    this.english,
    this.hindi,
    this.en,
    this.hi,
    this.ipa,
    this.ur,
  });

  factory Transliteration.fromJson(Map<String, dynamic> json) {
    return Transliteration(
      english: json['english'],
      hindi: json['hindi'],
      en: json['en'],
      hi: json['hi'],
      ipa: json['ipa'],
      ur: json['ur'],
    );
  }
}

class Visraam {
  final List<dynamic>? sttm2;
  final List<dynamic>? sttm;
  final List<dynamic>? igurbani;

  Visraam({this.sttm2, this.sttm, this.igurbani});

  factory Visraam.fromJson(Map<String, dynamic> json) {
    return Visraam(
      sttm2: json['sttm2'] ?? [],
      sttm: json['sttm'] ?? [],
      igurbani: json['igurbani'] ?? [],
    );
  }
}

class Writer {
  final int? writerId;
  final String? gurmukhi;
  final String? unicode;
  final String? english;

  Writer({this.writerId, this.gurmukhi, this.unicode, this.english});

  factory Writer.fromJson(Map<String, dynamic> json) {
    return Writer(
      writerId: json['writerId'],
      gurmukhi: json['gurmukhi'],
      unicode: json['unicode'],
      english: json['english'],
    );
  }
}

class Source {
  final String? sourceId;
  final String? gurmukhi;
  final String? unicode;
  final String? english;
  final int? pageNo;

  Source({
    this.sourceId,
    this.gurmukhi,
    this.unicode,
    this.english,
    this.pageNo,
  });

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      sourceId: json['sourceId'],
      gurmukhi: json['gurmukhi'],
      unicode: json['unicode'],
      english: json['english'],
      pageNo: json['pageNo'],
    );
  }
}

class Raag {
  final int? raagId;
  final String? gurmukhi;
  final String? unicode;
  final String? english;
  final String? raagWithPage;

  Raag({
    this.raagId,
    this.gurmukhi,
    this.unicode,
    this.english,
    this.raagWithPage,
  });

  factory Raag.fromJson(Map<String, dynamic> json) {
    return Raag(
      raagId: json['raagId'],
      gurmukhi: json['gurmukhi'],
      unicode: json['unicode'],
      english: json['english'],
      raagWithPage: json['raagWithPage'],
    );
  }
}