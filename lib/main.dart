import 'package:flutter/material.dart';
import 'package:frena/api_service.dart';
import 'package:frena/converter_screen.dart';
import 'package:frena/database_helper.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Frena',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CurrencyListPage(title: 'Frena - Currency Rates'),
    );
  }
}

class CurrencyListPage extends StatefulWidget {
  const CurrencyListPage({super.key, required this.title});

  final String title;

  @override
  State<CurrencyListPage> createState() => _CurrencyListPageState();
}

class _CurrencyListPageState extends State<CurrencyListPage> {
  final ApiService _apiService = ApiService();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  Map<String, dynamic> _rates = {};
  bool _isLoading = true;
  String _errorMessage = '';
  String _baseCurrency = 'USD'; // Default base currency
  List<String> _allCurrencies = []; // To store all available currencies for the dropdown
  int? _lastUpdated; // Timestamp of the last successful fetch

  @override
  void initState() {
    super.initState();
    _fetchAllCurrencies(); // Fetch all currencies once
    _fetchRates();
  }

  Future<void> _fetchAllCurrencies() async {
    try {
      final data = await _apiService.getLatestRates('USD'); // Fetch all currencies using USD as base
      setState(() {
        _allCurrencies = data.keys.toList()..sort();
      });
    } catch (e) {
      // Handle error, maybe show a snackbar or log it
      print('Error fetching all currencies: $e');
    }
  }

  Future<void> _fetchRates() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Try fetching fresh rates from the API
      final data = await _apiService.getLatestRates(_baseCurrency);
      await _dbHelper.cacheRates(_baseCurrency, data);
      setState(() {
        _rates = data;
        _lastUpdated = DateTime.now().millisecondsSinceEpoch;
        _isLoading = false;
      });
    } catch (e) {
      // If API fails, try to load from cache
      final cachedData = await _dbHelper.getCachedRates(_baseCurrency);
      if (cachedData != null) {
        setState(() {
          _rates = cachedData['rates'];
          _lastUpdated = cachedData['timestamp'];
          _isLoading = false;
          _errorMessage = 'Showing offline data. Last updated: ${_formatTimestamp(_lastUpdated)}';
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load rates and no offline data available.';
          _isLoading = false;
        });
      }
    }
  }

  String _formatTimestamp(int? timestamp) {
    if (timestamp == null) return 'N/A';
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat.yMd().add_jm().format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title),
            if (_lastUpdated != null)
              Text(
                'Last updated: ${_formatTimestamp(_lastUpdated)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
              ),
          ],
        ),
        actions: [
          // Dropdown for base currency selection
          if (_allCurrencies.isNotEmpty)
            DropdownButton<String>(
              value: _baseCurrency,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white), // White icon for visibility
              dropdownColor: Theme.of(context).colorScheme.inversePrimary, // Match app bar color
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _baseCurrency = newValue;
                    _fetchRates(); // Fetch new rates with the selected base currency
                  });
                }
              },
              items: _allCurrencies.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: const TextStyle(color: Colors.white)), // White text for visibility
                );
              }).toList(),
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchRates,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty && _rates.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _errorMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),
                )
              : Column(
                  children: [
                    if (_errorMessage.isNotEmpty && _rates.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _errorMessage,
                          style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _rates.length,
                        itemBuilder: (context, index) {
                          final currencyCode = _rates.keys.elementAt(index);
                          final rate = _rates[currencyCode];
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: ListTile(
                              title: Text(currencyCode),
                              trailing: Text(rate.toStringAsFixed(4)),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Exchange rates provided by ExchangeRate-API.com',
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ConverterScreen()),
          );
        },
        tooltip: 'Open Converter',
        child: const Icon(Icons.currency_exchange),
      ),
    );
  }
}