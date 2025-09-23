import 'package:wedlist/feature/register/domain/entities/register_entity.dart';

class RegisterModel extends RegisterEntity {
  RegisterModel({
    required super.name,
    required super.email,
    required super.password,
    super.weddingDate,
    super.avatarBytes,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
    name: json['name'] as String,
    email: json['email'] as String,
    password: json['password'] as String,
    weddingDate: json['weddingDate'] != null
        ? DateTime.parse(json['weddingDate'] as String)
        : null,
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'password': password,
    if (weddingDate != null) 'weddingDate': weddingDate!.toIso8601String(),
  };
}
