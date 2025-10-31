import 'package:flutter/material.dart';
import 'package:frena/api_service.dart';
import 'package:frena/converter_screen.dart';
import 'package:frena/database_helper.dart';
import 'package:frena/preferences_service.dart';
import 'package:frena/currency_data.dart';
import 'package:frena/settings_screen.dart';
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7E57C2),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7E57C2),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: const CurrencyListPage(title: 'Frena'),
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
  List<String> _favoriteCurrencies = []; // User's favorite currencies
  int? _lastUpdated; // Timestamp of the last successful fetch
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _showFavoritesOnly = false;
  bool _reverseRates = false; // Toggle for displaying foreign → base instead of base → foreign

  @override
  void initState() {
    super.initState();
    _loadUserPreferences();
  }

  Future<void> _loadUserPreferences() async {
    final baseCurrency = await PreferencesService.getBaseCurrency();
    final favorites = await PreferencesService.getFavoriteCurrencies();
    final reverseRates = await PreferencesService.getReverseRates();
    setState(() {
      _baseCurrency = baseCurrency;
      _favoriteCurrencies = favorites;
      _reverseRates = reverseRates;
    });
    await _fetchAllCurrencies(); // Fetch all currencies once
    await _fetchRates();
  }

  Future<void> _fetchAllCurrencies() async {
    try {
      final data = await _apiService.getLatestRates('USD'); // Fetch all currencies using USD as base
      setState(() {
        _allCurrencies = data.keys.toList()..sort();
      });
    } catch (e) {
      // Handle error silently, will be caught in _fetchRates
      debugPrint('Error fetching all currencies: $e');
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
          _errorMessage = 'Showing offline data';
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
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return DateFormat.yMd().add_jm().format(dateTime);
    }
  }

  Future<void> _toggleFavorite(String currency) async {
    final isFav = _favoriteCurrencies.contains(currency);
    if (isFav) {
      await PreferencesService.removeFavoriteCurrency(currency);
      setState(() {
        _favoriteCurrencies.remove(currency);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$currency removed from favorites'),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } else {
      await PreferencesService.addFavoriteCurrency(currency);
      setState(() {
        _favoriteCurrencies.add(currency);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$currency added to favorites'),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    }
  }

  Future<void> _toggleReverseRates() async {
    setState(() {
      _reverseRates = !_reverseRates;
    });
    await PreferencesService.setReverseRates(_reverseRates);
  }

  List<MapEntry<String, dynamic>> _getFilteredRates() {
    var entries = _rates.entries.toList();

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      entries = entries.where((entry) {
        final code = entry.key.toLowerCase();
        final name = CurrencyData.getCurrencyName(entry.key).toLowerCase();
        final query = _searchQuery.toLowerCase();
        return code.contains(query) || name.contains(query);
      }).toList();
    }

    // Filter by favorites
    if (_showFavoritesOnly) {
      entries = entries.where((entry) => _favoriteCurrencies.contains(entry.key)).toList();
    }

    // Sort: favorites first, then popular currencies, then alphabetically
    entries.sort((a, b) {
      final aIsFav = _favoriteCurrencies.contains(a.key);
      final bIsFav = _favoriteCurrencies.contains(b.key);
      
      if (aIsFav && !bIsFav) return -1;
      if (!aIsFav && bIsFav) return 1;
      
      final aIsPopular = CurrencyData.isPopular(a.key);
      final bIsPopular = CurrencyData.isPopular(b.key);
      
      if (aIsPopular && !bIsPopular) return -1;
      if (!aIsPopular && bIsPopular) return 1;
      
      return a.key.compareTo(b.key);
    });

    return entries;
  }

  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsScreen(
          currentBaseCurrency: _baseCurrency,
          onBaseCurrencyChanged: (newCurrency) {
            setState(() {
              _baseCurrency = newCurrency;
            });
            _fetchRates();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredRates = _getFilteredRates();
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(CurrencyData.getFlag(_baseCurrency)),
                const SizedBox(width: 8),
                Text('Frena - $_baseCurrency'),
              ],
            ),
            if (_lastUpdated != null)
              Text(
                'Updated ${_formatTimestamp(_lastUpdated)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.black54,
                    ),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _navigateToSettings,
            tooltip: 'Settings',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchRates,
            tooltip: 'Refresh rates',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty && _rates.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _fetchRates,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Try Again'),
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    if (_errorMessage.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8.0),
                        color: Colors.orange[100],
                        child: Row(
                          children: [
                            Icon(Icons.wifi_off, color: Colors.orange[900]),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _errorMessage,
                                style: TextStyle(
                                  color: Colors.orange[900],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: 'Search currencies...',
                                prefixIcon: const Icon(Icons.search),
                                suffixIcon: _searchController.text.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.clear),
                                        onPressed: () {
                                          setState(() {
                                            _searchController.clear();
                                            _searchQuery = '';
                                          });
                                        },
                                      )
                                    : null,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _searchQuery = value;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          FilterChip(
                            label: Text(
                              _favoriteCurrencies.isEmpty
                                  ? 'Favorites'
                                  : 'Favorites (${_favoriteCurrencies.length})',
                            ),
                            selected: _showFavoritesOnly,
                            onSelected: (bool selected) {
                              setState(() {
                                _showFavoritesOnly = selected;
                              });
                            },
                            avatar: Icon(
                              _showFavoritesOnly
                                  ? Icons.star
                                  : Icons.star_border,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Reverse rates toggle
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Card(
                              color: Theme.of(context).colorScheme.surfaceVariant,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.swap_horiz,
                                      size: 20,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _reverseRates
                                            ? 'Showing: Curr → ${CurrencyData.getFlag(_baseCurrency)} $_baseCurrency'
                                            : 'Showing: ${CurrencyData.getFlag(_baseCurrency)} $_baseCurrency → Foreign',
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                    ),
                                    Switch(
                                      value: _reverseRates,
                                      onChanged: (value) {
                                        _toggleReverseRates();
                                      },
                                      activeColor: Theme.of(context).colorScheme.primary,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (filteredRates.isEmpty)
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _showFavoritesOnly
                                    ? Icons.star_border
                                    : Icons.search_off,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _showFavoritesOnly
                                    ? 'No favorite currencies yet.\nTap the star icon to add favorites!'
                                    : 'No currencies found',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: ListView.builder(
                          itemCount: filteredRates.length,
                          itemBuilder: (context, index) {
                            final entry = filteredRates[index];
                            final currencyCode = entry.key;
                            final rate = entry.value;
                            final isFavorite =
                                _favoriteCurrencies.contains(currencyCode);
                            final isPopular =
                                CurrencyData.isPopular(currencyCode);

                            // Calculate display rate based on reverse setting
                            final displayRate = _reverseRates ? (1 / rate) : rate;
                            final displayBaseText = _reverseRates 
                                ? '1 $currencyCode' 
                                : '1 $_baseCurrency';

                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: ListTile(
                                leading: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      CurrencyData.getFlag(currencyCode),
                                      style: const TextStyle(fontSize: 32),
                                    ),
                                  ],
                                ),
                                title: Row(
                                  children: [
                                    Text(
                                      currencyCode,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    if (isPopular && !isFavorite)
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primaryContainer,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            'POPULAR',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimaryContainer,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                subtitle: Text(
                                  CurrencyData.getCurrencyName(currencyCode),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          displayRate.toStringAsFixed(4),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          displayBaseText,
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: Icon(
                                        isFavorite
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: isFavorite
                                            ? Colors.amber
                                            : Colors.grey,
                                      ),
                                      onPressed: () =>
                                          _toggleFavorite(currencyCode),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Text(
                    //     'Exchange rates provided by ExchangeRate-API.com',
                    //     style: Theme.of(context).textTheme.bodySmall,
                    //     textAlign: TextAlign.center,
                    //   ),
                    // ),
                  ],
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConverterScreen(
                initialFromCurrency: _baseCurrency,
                allCurrencies: _allCurrencies,
              ),
            ),
          );
        },
        tooltip: 'Open Converter',
        icon: const Icon(Icons.currency_exchange),
        label: const Text('Convert'),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}