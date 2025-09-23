/// Supported country codes in the app (ISO 3166-1 alpha-2)
const supportedCountries = <String>['TR', 'US', 'CA', 'UK', 'AU', 'DE', 'FR', 'IT', 'JP', 'CN', 'NL', 'PT', 'IN', 'ES'];

/// Native (or commonly used self-language) display names for each supported country.
/// These are intentionally short and user-facing; fall back to the code if missing.
const countryDisplayNames = <String, String>{
  'TR': 'Türkiye',
  'US': 'United States',
  'CA': 'Canada',
  'UK': 'United Kingdom',
  'AU': 'Australia',
  'DE': 'Deutschland',
  'FR': 'France',
  'IT': 'Italia',
  'JP': '日本', // Nihon / Nippon
  'CN': '中国', // Zhōngguó
  'NL': 'Nederland',
  'PT': 'Portugal',
  'ES': 'España',
  'IN': 'भारत', // Bhārat
};
