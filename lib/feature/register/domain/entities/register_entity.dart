import 'dart:typed_data';

class RegisterEntity {
  RegisterEntity({
    required this.name,
    required this.email,
    required this.password,
    this.weddingDate,
    this.avatarBytes,
  });
  final String name;
  final String email;
  final String password;
  final DateTime? weddingDate;
  final Uint8List? avatarBytes;
}
