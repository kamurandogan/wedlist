import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class TimestampConverter implements JsonConverter<DateTime, Object?> {
  const TimestampConverter();

  @override
  DateTime fromJson(Object? json) {
    if (json == null) return DateTime.fromMillisecondsSinceEpoch(0);
    if (json is Timestamp) return json.toDate();
    if (json is String) return DateTime.tryParse(json) ?? DateTime.fromMillisecondsSinceEpoch(0);
    if (json is int) return DateTime.fromMillisecondsSinceEpoch(json);
    throw ArgumentError('Unsupported timestamp json: $json');
  }

  @override
  Object toJson(DateTime object) {
    return Timestamp.fromDate(object);
  }
}
