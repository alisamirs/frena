import 'package:flutter/material.dart';
import 'package:frena/preferences_service.dart';
import 'package:frena/currency_data.dart';

class SettingsScreen extends StatefulWidget {
  final String currentBaseCurrency;
  final Function(String) onBaseCurrencyChanged;

  const SettingsScreen({
    super.key,
    required this.currentBaseCurrency,
    required this.onBaseCurrencyChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late String _selectedBaseCurrency;
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredCurrencies = [];
  List<String> _allCurrencies = [];

  @override
  void initState() {
    super.initState();
    _selectedBaseCurrency = widget.currentBaseCurrency;
    _loadCurrencies();
  }

  void _loadCurrencies() {
    // Get all available currency codes
    _allCurrencies = CurrencyData.currencyNames.keys.toList()..sort();
    _filteredCurrencies = List.from(_allCurrencies);
  }

  void _filterCurrencies(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCurrencies = List.from(_allCurrencies);
      } else {
        _filteredCurrencies = _allCurrencies.where((code) {
          final name = CurrencyData.getCurrencyName(code);
          return code.toLowerCase().contains(query.toLowerCase()) ||
              name.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  Future<void> _saveBaseCurrency() async {
    await PreferencesService.setBaseCurrency(_selectedBaseCurrency);
    widget.onBaseCurrencyChanged(_selectedBaseCurrency);
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Base currency changed to $_selectedBaseCurrency'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Base Currency',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Select your home currency. All rates will be shown relative to this currency.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search Currency',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _filterCurrencies('');
                            },
                          )
                        : null,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: _filterCurrencies,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredCurrencies.length,
              itemBuilder: (context, index) {
                final code = _filteredCurrencies[index];
                final isSelected = code == _selectedBaseCurrency;
                return ListTile(
                  leading: Text(
                    CurrencyData.getFlag(code),
                    style: const TextStyle(fontSize: 32),
                  ),
                  title: Text(
                    code,
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(CurrencyData.getCurrencyName(code)),
                  trailing: isSelected
                      ? Icon(
                          Icons.check_circle,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : null,
                  selected: isSelected,
                  onTap: () {
                    setState(() {
                      _selectedBaseCurrency = code;
                    });
                  },
                );
              },
            ),
          ),
          if (_selectedBaseCurrency != widget.currentBaseCurrency)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _saveBaseCurrency,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
