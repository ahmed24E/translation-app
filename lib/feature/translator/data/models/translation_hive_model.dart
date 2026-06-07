import 'package:hive/hive.dart';

import 'package:transelation_p/core/constants/app_constants.dart';


@HiveType(typeId: AppConstants.translationHiveTypeId)
class TranslationHiveModel extends HiveObject {
  @HiveField(0)
  final String sourceText;

  @HiveField(1)
  final String translatedText;

  @HiveField(2)
  final String sourceLang;

  @HiveField(3)
  final String targetLang;

  @HiveField(4)
  final int timestampMs;

  TranslationHiveModel({
    required this.sourceText,
    required this.translatedText,
    required this.sourceLang,
    required this.targetLang,
    required this.timestampMs,
  });

  
  DateTime get timestamp => DateTime.fromMillisecondsSinceEpoch(timestampMs);

 
  static String cacheKey(String src, String from, String to) =>
      '$from|$to|${src.toLowerCase().trim()}';

  String get ownKey => cacheKey(sourceText, sourceLang, targetLang);
}


class TranslationHiveModelAdapter extends TypeAdapter<TranslationHiveModel> {
  @override
  final int typeId = AppConstants.translationHiveTypeId;

  @override
  TranslationHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TranslationHiveModel(
      sourceText: fields[0] as String,
      translatedText: fields[1] as String,
      sourceLang: fields[2] as String,
      targetLang: fields[3] as String,
      timestampMs: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TranslationHiveModel obj) {
    writer
      ..writeByte(5) 
      ..writeByte(0)
      ..write(obj.sourceText)
      ..writeByte(1)
      ..write(obj.translatedText)
      ..writeByte(2)
      ..write(obj.sourceLang)
      ..writeByte(3)
      ..write(obj.targetLang)
      ..writeByte(4)
      ..write(obj.timestampMs);
  }
}
