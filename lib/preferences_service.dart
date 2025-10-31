import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing user preferences
class PreferencesService {
  static const String _baseCurrencyKey = 'base_currency';
  static const String _favoriteCurrenciesKey = 'favorite_currencies';
  static const String _hasSeenOnboardingKey = 'has_seen_onboarding';

  /// Get the user's base currency (default: USD)
  static Future<String> getBaseCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_baseCurrencyKey) ?? 'USD';
  }

  /// Set the user's base currency
  static Future<void> setBaseCurrency(String currency) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_baseCurrencyKey, currency);
  }

  /// Get the user's favorite currencies
  static Future<List<String>> getFavoriteCurrencies() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoriteCurrenciesKey) ?? [];
  }

  /// Set the user's favorite currencies
  static Future<void> setFavoriteCurrencies(List<String> currencies) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoriteCurrenciesKey, currencies);
  }

  /// Add a currency to favorites
  static Future<void> addFavoriteCurrency(String currency) async {
    final favorites = await getFavoriteCurrencies();
    if (!favorites.contains(currency)) {
      favorites.add(currency);
      await setFavoriteCurrencies(favorites);
    }
  }

  /// Remove a currency from favorites
  static Future<void> removeFavoriteCurrency(String currency) async {
    final favorites = await getFavoriteCurrencies();
    favorites.remove(currency);
    await setFavoriteCurrencies(favorites);
  }

  /// Check if a currency is in favorites
  static Future<bool> isFavorite(String currency) async {
    final favorites = await getFavoriteCurrencies();
    return favorites.contains(currency);
  }

  /// Check if user has seen onboarding
  static Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasSeenOnboardingKey) ?? false;
  }

  /// Mark onboarding as seen
  static Future<void> setOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasSeenOnboardingKey, true);
  }
}
