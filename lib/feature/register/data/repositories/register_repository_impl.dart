import 'package:wedlist/feature/register/data/datasources/register_remote_data_source.dart';
import 'package:wedlist/feature/register/data/models/register_model.dart';
import 'package:wedlist/feature/register/domain/entities/register_entity.dart';
import 'package:wedlist/feature/register/domain/repositories/register_repository.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  RegisterRepositoryImpl(this.remoteDataSource);
  final RegisterRemoteDataSource remoteDataSource;

  @override
  Future<void> register(RegisterEntity entity) async {
    final model = RegisterModel(
      name: entity.name,
      email: entity.email,
      password: entity.password,
      weddingDate: entity.weddingDate,
      avatarBytes: entity.avatarBytes,
    );
    await remoteDataSource.register(model);
  }
}
