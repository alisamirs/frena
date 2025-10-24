import 'package:flutter/material.dart';
import 'package:frena/api_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _amountController = TextEditingController();
  String _fromCurrency = 'USD';
  String _toCurrency = 'EUR';
  double _convertedAmount = 0.0;
  bool _isLoading = false;
  String _errorMessage = '';
  List<String> _availableCurrencies = [];

  @override
  void initState() {
    super.initState();
    _fetchAvailableCurrencies();
  }

  Future<void> _fetchAvailableCurrencies() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      // ExchangeRate-API's Open API provides all currency codes within the /latest response.
      // We fetch rates for a common base (e.g., USD) to get the full list of available currencies.
      final data = await _apiService.getLatestRates('USD');
      setState(() {
        _availableCurrencies = data.keys.toList()..sort();
        // Set default currencies if they are not in the fetched list
        if (!_availableCurrencies.contains(_fromCurrency)) {
          _fromCurrency = _availableCurrencies.first;
        }
        if (!_availableCurrencies.contains(_toCurrency)) {
          _toCurrency = _availableCurrencies.firstWhere((currency) => currency != _fromCurrency, orElse: () => _availableCurrencies.first);
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load currencies: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _convertCurrency() async {
    if (_amountController.text.isEmpty) {
      setState(() {
        _convertedAmount = 0.0;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final double amount = double.parse(_amountController.text);
      final rates = await _apiService.getLatestRates(_fromCurrency);

      if (rates.containsKey(_toCurrency)) {
        final double rate = rates[_toCurrency];
        setState(() {
          _convertedAmount = amount * rate;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Conversion error: Rate for $_toCurrency not found';
          _convertedAmount = 0.0;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Conversion error: ${e.toString()}';
        _convertedAmount = 0.0;
        _isLoading = false;
      });
    }
  }

  void _swapCurrencies() {
    setState(() {
      final String temp = _fromCurrency;
      _fromCurrency = _toCurrency;
      _toCurrency = temp;
      _convertCurrency(); // Recalculate after swap
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Converter'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
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
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number, // Allow only numbers
                        decoration: const InputDecoration(
                          labelText: 'Amount',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) => _convertCurrency(),
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _fromCurrency,
                              decoration: const InputDecoration(
                                labelText: 'From',
                                border: OutlineInputBorder(),
                              ),
                              items: _availableCurrencies.map((String currency) {
                                return DropdownMenuItem<String>(
                                  value: currency,
                                  child: Text(currency),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _fromCurrency = newValue!;
                                  _convertCurrency();
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          IconButton(
                            icon: const Icon(Icons.swap_horiz, size: 30),
                            onPressed: _swapCurrencies,
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _toCurrency,
                              decoration: const InputDecoration(
                                labelText: 'To',
                                border: OutlineInputBorder(),
                              ),
                              items: _availableCurrencies.map((String currency) {
                                return DropdownMenuItem<String>(
                                  value: currency,
                                  child: Text(currency),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _toCurrency = newValue!;
                                  _convertCurrency();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24.0),
                      Text(
                        'Converted Amount: ${_convertedAmount.toStringAsFixed(4)}',
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
    );
  }
}
