import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frena/api_service.dart';
import 'package:frena/currency_data.dart';
import 'package:frena/database_helper.dart';

class ConverterScreen extends StatefulWidget {
  final String? initialFromCurrency;
  final List<String>? allCurrencies;

  const ConverterScreen({
    super.key,
    this.initialFromCurrency,
    this.allCurrencies,
  });

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final ApiService _apiService = ApiService();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final TextEditingController _amountController = TextEditingController(text: '1');
  String _fromCurrency = 'USD';
  String _toCurrency = 'EUR';
  double _convertedAmount = 0.0;
  bool _isLoading = false;
  String _errorMessage = '';
  List<String> _availableCurrencies = [];
  Map<String, dynamic> _currentRates = {};
  double _currentRate = 0.0;

  @override
  void initState() {
    super.initState();
    if (widget.initialFromCurrency != null) {
      _fromCurrency = widget.initialFromCurrency!;
    }
    if (widget.allCurrencies != null && widget.allCurrencies!.isNotEmpty) {
      _availableCurrencies = widget.allCurrencies!;
      _setDefaultToCurrency();
      _convertCurrency();
    } else {
      _fetchAvailableCurrencies();
    }
  }

  void _setDefaultToCurrency() {
    // Set a different default "to" currency
    if (_availableCurrencies.contains('EUR') && _fromCurrency != 'EUR') {
      _toCurrency = 'EUR';
    } else if (_availableCurrencies.contains('USD') && _fromCurrency != 'USD') {
      _toCurrency = 'USD';
    } else {
      _toCurrency = _availableCurrencies.firstWhere(
        (currency) => currency != _fromCurrency,
        orElse: () => _availableCurrencies.first,
      );
    }
  }

  Future<void> _fetchAvailableCurrencies() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      final data = await _apiService.getLatestRates('USD');
      setState(() {
        _availableCurrencies = data.keys.toList()..sort();
        if (!_availableCurrencies.contains(_fromCurrency)) {
          _fromCurrency = _availableCurrencies.first;
        }
        _setDefaultToCurrency();
        _isLoading = false;
      });
      await _convertCurrency();
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
        _currentRate = 0.0;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final double amount = double.parse(_amountController.text);
      
      // Try to get rates from API first
      Map<String, dynamic>? rates;
      try {
        rates = await _apiService.getLatestRates(_fromCurrency);
        await _dbHelper.cacheRates(_fromCurrency, rates);
      } catch (e) {
        // If API fails, try cache
        final cachedData = await _dbHelper.getCachedRates(_fromCurrency);
        if (cachedData != null) {
          rates = cachedData['rates'];
        }
      }

      if (rates != null && rates.containsKey(_toCurrency)) {
        final double rate = rates[_toCurrency];
        setState(() {
          _currentRates = rates!;
          _currentRate = rate;
          _convertedAmount = amount * rate;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Conversion error: Rate for $_toCurrency not found';
          _convertedAmount = 0.0;
          _currentRate = 0.0;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Invalid amount';
        _convertedAmount = 0.0;
        _currentRate = 0.0;
        _isLoading = false;
      });
    }
  }

  void _swapCurrencies() {
    setState(() {
      final String temp = _fromCurrency;
      _fromCurrency = _toCurrency;
      _toCurrency = temp;
    });
    _convertCurrency();
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Converter'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _availableCurrencies.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // From Currency Card
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'From',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                CurrencyData.getFlag(_fromCurrency),
                                style: const TextStyle(fontSize: 32),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: _fromCurrency,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                  ),
                                  items: _availableCurrencies
                                      .map((String currency) {
                                    return DropdownMenuItem<String>(
                                      value: currency,
                                      child: Text(
                                        CurrencyData.getCurrencyDisplay(
                                            currency),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      setState(() {
                                        _fromCurrency = newValue;
                                      });
                                      _convertCurrency();
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _amountController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Amount',
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.attach_money),
                              suffixIcon: _amountController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        _amountController.clear();
                                        _convertCurrency();
                                      },
                                    )
                                  : null,
                            ),
                            onChanged: (value) => _convertCurrency(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Swap Button
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.swap_vert, size: 32),
                        onPressed: _swapCurrencies,
                        tooltip: 'Swap currencies',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // To Currency Card
                  Card(
                    elevation: 4,
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'To',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  color: Colors.grey[700],
                                ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                CurrencyData.getFlag(_toCurrency),
                                style: const TextStyle(fontSize: 32),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: _toCurrency,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                  ),
                                  items: _availableCurrencies
                                      .map((String currency) {
                                    return DropdownMenuItem<String>(
                                      value: currency,
                                      child: Text(
                                        CurrencyData.getCurrencyDisplay(
                                            currency),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      setState(() {
                                        _toCurrency = newValue;
                                      });
                                      _convertCurrency();
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Converted Amount',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _convertedAmount.toStringAsFixed(2),
                                        style: TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.copy),
                                  onPressed: () => _copyToClipboard(
                                      _convertedAmount.toStringAsFixed(2)),
                                  tooltip: 'Copy',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_currentRate > 0) ...[
                    const SizedBox(height: 24),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              'Exchange Rate',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '1 $_fromCurrency = ',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  '${_currentRate.toStringAsFixed(4)} $_toCurrency',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '1 $_toCurrency = ',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  '${(1 / _currentRate).toStringAsFixed(4)} $_fromCurrency',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  if (_errorMessage.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red[300]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red[700]),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _errorMessage,
                              style: TextStyle(
                                color: Colors.red[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}