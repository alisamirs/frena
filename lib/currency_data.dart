/// Currency information including full names and popular currencies
class CurrencyData {
  static const Map<String, String> currencyNames = {
    'USD': 'US Dollar',
    'EUR': 'Euro',
    'GBP': 'British Pound Sterling',
    'JPY': 'Japanese Yen',
    'AUD': 'Australian Dollar',
    'CAD': 'Canadian Dollar',
    'CHF': 'Swiss Franc',
    'CNY': 'Chinese Yuan',
    'INR': 'Indian Rupee',
    'MXN': 'Mexican Peso',
    'BRL': 'Brazilian Real',
    'ZAR': 'South African Rand',
    'RUB': 'Russian Ruble',
    'KRW': 'South Korean Won',
    'TRY': 'Turkish Lira',
    'SGD': 'Singapore Dollar',
    'HKD': 'Hong Kong Dollar',
    'NOK': 'Norwegian Krone',
    'SEK': 'Swedish Krona',
    'DKK': 'Danish Krone',
    'PLN': 'Polish Zloty',
    'THB': 'Thai Baht',
    'IDR': 'Indonesian Rupiah',
    'HUF': 'Hungarian Forint',
    'CZK': 'Czech Koruna',
    'ILS': 'Israeli New Shekel',
    'CLP': 'Chilean Peso',
    'PHP': 'Philippine Peso',
    'AED': 'UAE Dirham',
    'COP': 'Colombian Peso',
    'SAR': 'Saudi Riyal',
    'MYR': 'Malaysian Ringgit',
    'RON': 'Romanian Leu',
    'NZD': 'New Zealand Dollar',
    'EGP': 'Egyptian Pound',
    'NGN': 'Nigerian Naira',
    'ARS': 'Argentine Peso',
    'PKR': 'Pakistani Rupee',
    'BGN': 'Bulgarian Lev',
    'VND': 'Vietnamese Dong',
    'UAH': 'Ukrainian Hryvnia',
    'KWD': 'Kuwaiti Dinar',
    'QAR': 'Qatari Riyal',
    'OMR': 'Omani Rial',
    'BHD': 'Bahraini Dinar',
    'JOD': 'Jordanian Dinar',
    'LKR': 'Sri Lankan Rupee',
    'BDT': 'Bangladeshi Taka',
    'MAD': 'Moroccan Dirham',
    'KES': 'Kenyan Shilling',
    'GHS': 'Ghanaian Cedi',
  };

  /// Popular currencies that should be shown first
  static const List<String> popularCurrencies = [
    'USD',
    'EUR',
    'GBP',
    'JPY',
    'AUD',
    'CAD',
    'CHF',
    'CNY',
    'INR',
    'MXN',
  ];

  /// Get the full name of a currency
  static String getCurrencyName(String code) {
    return currencyNames[code] ?? code;
  }

  /// Get currency display text with code and name
  static String getCurrencyDisplay(String code) {
    final name = getCurrencyName(code);
    return name == code ? code : '$code - $name';
  }

  /// Check if a currency is popular
  static bool isPopular(String code) {
    return popularCurrencies.contains(code);
  }

  /// Get flag emoji for currency (based on country code)
  static String getFlag(String currencyCode) {
    // Map currency codes to country codes for flag emoji
    const Map<String, String> currencyToCountry = {
      'USD': 'US',
      'EUR': 'EU',
      'GBP': 'GB',
      'JPY': 'JP',
      'AUD': 'AU',
      'CAD': 'CA',
      'CHF': 'CH',
      'CNY': 'CN',
      'INR': 'IN',
      'MXN': 'MX',
      'BRL': 'BR',
      'ZAR': 'ZA',
      'RUB': 'RU',
      'KRW': 'KR',
      'TRY': 'TR',
      'SGD': 'SG',
      'HKD': 'HK',
      'NOK': 'NO',
      'SEK': 'SE',
      'DKK': 'DK',
      'PLN': 'PL',
      'THB': 'TH',
      'IDR': 'ID',
      'HUF': 'HU',
      'CZK': 'CZ',
      'ILS': 'IL',
      'CLP': 'CL',
      'PHP': 'PH',
      'AED': 'AE',
      'COP': 'CO',
      'SAR': 'SA',
      'MYR': 'MY',
      'RON': 'RO',
      'NZD': 'NZ',
      'EGP': 'EG',
      'NGN': 'NG',
      'ARS': 'AR',
      'PKR': 'PK',
      'BGN': 'BG',
      'VND': 'VN',
      'UAH': 'UA',
      'KWD': 'KW',
      'QAR': 'QA',
      'OMR': 'OM',
      'BHD': 'BH',
      'JOD': 'JO',
      'LKR': 'LK',
      'BDT': 'BD',
      'MAD': 'MA',
      'KES': 'KE',
      'GHS': 'GH',
    };

    final countryCode = currencyToCountry[currencyCode];
    if (countryCode == null) return '🌐';

    // Convert country code to flag emoji
    if (countryCode == 'EU') return '🇪🇺';
    
    final base = 0x1F1E6;
    final flag = String.fromCharCode(base + countryCode.codeUnitAt(0) - 'A'.codeUnitAt(0)) +
        String.fromCharCode(base + countryCode.codeUnitAt(1) - 'A'.codeUnitAt(0));
    return flag;
  }
}
