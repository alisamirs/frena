import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String _baseUrl = 'https://open.er-api.com/v6/latest';

  Future<Map<String, dynamic>> getLatestRates(String baseCurrency) async {
    final response = await http.get(Uri.parse('$_baseUrl/$baseCurrency'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // The Open ExchangeRate API returns rates under a key named 'rates'.
      return data['rates'] as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load exchange rates');
    }
  }
}
