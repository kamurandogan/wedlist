import 'package:wedlist/feature/register/domain/entities/register_entity.dart';
import 'package:wedlist/feature/register/domain/repositories/register_repository.dart';

class RegisterUseCase {
  RegisterUseCase(this.repository);
  final RegisterRepository repository;
  Future<void> call(RegisterEntity entity) => repository.register(entity);
}
