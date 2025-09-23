import 'package:wedlist/feature/register/domain/entities/register_entity.dart';

abstract class RegisterRepository {
  Future<void> register(RegisterEntity entity);
}
