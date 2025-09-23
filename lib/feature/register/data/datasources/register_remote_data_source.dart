import 'package:wedlist/feature/register/data/models/register_model.dart';

abstract class RegisterRemoteDataSource {
  Future<void> register(RegisterModel model);
}
