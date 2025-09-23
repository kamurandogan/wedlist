import 'package:wedlist/feature/settings/domain/repositories/country_repository.dart';

class WatchCountry {
  WatchCountry(this._repo);
  final CountryRepository _repo;
  Stream<String?> call() => _repo.watchCountry();
}
