abstract class CountryRepository {
  Stream<String?> watchCountry();
  Future<void> changeCountry(String code);
}
