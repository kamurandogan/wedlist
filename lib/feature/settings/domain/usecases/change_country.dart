import 'package:wedlist/feature/settings/domain/repositories/country_repository.dart';

class ChangeCountry {
  ChangeCountry(this._repo);
  final CountryRepository _repo;
  Future<void> call(String code) => _repo.changeCountry(code);
}
