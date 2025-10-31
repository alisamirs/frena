# Frena Project Structure

## 📁 Directory Tree

```
frena/
├── 📱 android/                      # Android platform files
├── 🍎 ios/                          # iOS platform files
├── 🐧 linux/                        # Linux platform files
├── 🍏 macos/                        # macOS platform files
├── 🪟 windows/                      # Windows platform files
├── 🌐 web/                          # Web platform files
│
├── 📚 lib/                          # Main source code
│   ├── main.dart                   # App entry point & currency list
│   ├── api_service.dart            # API communication service
│   ├── converter_screen.dart       # Currency converter UI
│   ├── currency_data.dart          # Currency info utilities ✨ NEW
│   ├── database_helper.dart        # SQLite caching service
│   ├── preferences_service.dart    # User preferences ✨ NEW
│   └── settings_screen.dart        # Settings UI ✨ NEW
│
├── 🧪 test/                         # Test files
│   └── widget_test.dart            # Widget tests (updated)
│
├── 🏗️ build/                        # Build output (generated)
│
├── 📄 Configuration Files
│   ├── pubspec.yaml                # Dependencies & metadata
│   ├── pubspec.lock                # Locked dependency versions
│   ├── analysis_options.yaml       # Linter configuration
│   └── frena.iml                   # IntelliJ project file
│
└── 📖 Documentation
    ├── README.md                   # Project overview (updated)
    ├── LICENSE                     # Project license
    ├── Brainstorm.md              # Initial brainstorming
    ├── gemini.md                  # Project requirements
    ├── CHANGELOG.md               # Version history ✨ NEW
    ├── ENHANCEMENTS.md            # Technical documentation ✨ NEW
    ├── ENHANCEMENT_SUMMARY.md     # Quick summary ✨ NEW
    ├── FEATURE_GUIDE.md           # User guide ✨ NEW
    └── PROJECT_STRUCTURE.md       # This file ✨ NEW
```

## 🎯 Core Application Files

### 📱 lib/main.dart
**Purpose**: Application entry point and main currency list screen

**Responsibilities**:
- App initialization
- Main MaterialApp widget
- Currency list screen (CurrencyListPage)
- Search functionality
- Favorites management
- Base currency display
- Offline mode handling

**Key Components**:
- `MyApp` - Root widget
- `CurrencyListPage` - Main screen widget
- `_CurrencyListPageState` - State management

**Dependencies**:
- api_service.dart
- database_helper.dart
- preferences_service.dart
- currency_data.dart
- settings_screen.dart
- converter_screen.dart

**Size**: ~350 lines

---

### 💱 lib/converter_screen.dart
**Purpose**: Currency conversion interface

**Responsibilities**:
- Currency pair selection
- Amount input handling
- Live conversion calculation
- Exchange rate display
- Copy to clipboard
- Swap currencies
- Offline support

**Key Components**:
- `ConverterScreen` - Widget
- `_ConverterScreenState` - State management

**Dependencies**:
- api_service.dart
- database_helper.dart
- currency_data.dart

**Size**: ~400 lines

---

### ⚙️ lib/settings_screen.dart ✨ NEW
**Purpose**: Base currency selection interface

**Responsibilities**:
- Display all available currencies
- Search functionality
- Visual currency selection
- Save preferences
- Navigation back to main screen

**Key Components**:
- `SettingsScreen` - Widget
- `_SettingsScreenState` - State management

**Dependencies**:
- preferences_service.dart
- currency_data.dart

**Size**: ~160 lines

---

### 🌐 lib/currency_data.dart ✨ NEW
**Purpose**: Central repository for currency information

**Responsibilities**:
- Currency code to name mapping
- Popular currencies list
- Flag emoji generation
- Display formatting utilities

**Key Data**:
- 50+ currency names
- Top 10 popular currencies
- Country code to flag mapping
- Helper methods

**Type**: Utility class (static methods)

**Size**: ~150 lines

---

### 💾 lib/preferences_service.dart ✨ NEW
**Purpose**: User preferences management

**Responsibilities**:
- Save/load base currency
- Manage favorites list
- Onboarding state tracking
- SharedPreferences wrapper

**Methods**:
- `getBaseCurrency()`
- `setBaseCurrency()`
- `getFavoriteCurrencies()`
- `setFavoriteCurrencies()`
- `addFavoriteCurrency()`
- `removeFavoriteCurrency()`
- `isFavorite()`

**Type**: Service class (static methods)

**Size**: ~80 lines

---

### 🔌 lib/api_service.dart
**Purpose**: External API communication

**Responsibilities**:
- Fetch exchange rates from ExchangeRate-API
- HTTP request handling
- JSON parsing
- Error handling

**API Endpoint**: `https://open.er-api.com/v6/latest/{currency}`

**Methods**:
- `getLatestRates(String baseCurrency)`

**Size**: ~20 lines

---

### 💿 lib/database_helper.dart
**Purpose**: Local SQLite database management

**Responsibilities**:
- Database initialization
- Cache exchange rates
- Retrieve cached rates
- Handle batch operations

**Schema**:
```sql
CREATE TABLE rates (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  base_currency TEXT NOT NULL,
  currency_code TEXT NOT NULL,
  rate REAL NOT NULL,
  timestamp INTEGER NOT NULL,
  UNIQUE(base_currency, currency_code)
)
```

**Methods**:
- `cacheRates()`
- `getCachedRates()`

**Size**: ~85 lines

---

## 🔄 Data Flow

### App Launch
```
main.dart (startup)
    ↓
preferences_service.dart (load base currency)
    ↓
preferences_service.dart (load favorites)
    ↓
api_service.dart (fetch all currencies)
    ↓
database_helper.dart (cache for offline)
    ↓
main.dart (display list)
```

### Currency Conversion
```
converter_screen.dart (user input)
    ↓
api_service.dart (fetch rates)
    ↓ (on error)
database_helper.dart (get cached rates)
    ↓
converter_screen.dart (calculate & display)
```

### Base Currency Change
```
settings_screen.dart (user selection)
    ↓
preferences_service.dart (save preference)
    ↓
main.dart (refresh with new base)
    ↓
api_service.dart (fetch new rates)
```

### Favorites Management
```
main.dart (star tap)
    ↓
preferences_service.dart (add/remove)
    ↓
main.dart (re-sort list)
```

---

## 📦 Dependencies

### Production Dependencies
```yaml
flutter:              # UI framework
  sdk: flutter
  
cupertino_icons: ^1.0.8        # iOS-style icons
http: ^1.2.1                   # HTTP client for API
sqflite: ^2.3.3               # SQLite database
path_provider: ^2.1.3          # File system paths
intl: ^0.19.0                  # Internationalization
shared_preferences: ^2.2.2     # Key-value storage ✨ NEW
flutter_svg: ^2.0.10          # SVG support ✨ NEW
```

### Development Dependencies
```yaml
flutter_test:         # Testing framework
  sdk: flutter
  
flutter_lints: ^5.0.0 # Dart linting rules
```

---

## 🔀 State Management Flow

### Main Screen State
```dart
_CurrencyListPageState {
  // API & Database
  ApiService _apiService
  DatabaseHelper _dbHelper
  
  // Data
  Map<String, dynamic> _rates
  List<String> _allCurrencies
  List<String> _favoriteCurrencies
  
  // UI State
  bool _isLoading
  String _errorMessage
  String _baseCurrency
  String _searchQuery
  bool _showFavoritesOnly
  int? _lastUpdated
  
  // Controllers
  TextEditingController _searchController
}
```

### Converter Screen State
```dart
_ConverterScreenState {
  // Services
  ApiService _apiService
  DatabaseHelper _dbHelper
  
  // Data
  List<String> _availableCurrencies
  Map<String, dynamic> _currentRates
  
  // Conversion State
  String _fromCurrency
  String _toCurrency
  double _convertedAmount
  double _currentRate
  
  // UI State
  bool _isLoading
  String _errorMessage
  
  // Controllers
  TextEditingController _amountController
}
```

### Settings Screen State
```dart
_SettingsScreenState {
  // Data
  String _selectedBaseCurrency
  List<String> _allCurrencies
  List<String> _filteredCurrencies
  
  // Controllers
  TextEditingController _searchController
}
```

---

## 🎨 Widget Tree

### Main App
```
MaterialApp
└── CurrencyListPage (Home)
    ├── AppBar
    │   ├── Title (with flag)
    │   ├── Settings Button → SettingsScreen
    │   └── Refresh Button
    │
    ├── Body
    │   ├── Offline Banner (conditional)
    │   ├── Search Bar + Favorites Filter
    │   ├── Currency List (ListView)
    │   │   └── Currency Cards (with star button)
    │   └── Attribution Footer
    │
    └── FloatingActionButton → ConverterScreen
```

### Converter Screen
```
ConverterScreen
├── AppBar
│   └── Title
│
└── Body (SingleChildScrollView)
    ├── From Currency Card
    │   ├── Flag + Dropdown
    │   └── Amount TextField
    │
    ├── Swap Button
    │
    ├── To Currency Card
    │   ├── Flag + Dropdown
    │   └── Result Display + Copy Button
    │
    ├── Exchange Rate Card
    │
    └── Error Message (conditional)
```

### Settings Screen
```
SettingsScreen
├── AppBar
│   └── Title
│
└── Body (Column)
    ├── Header Section
    │   ├── Title + Description
    │   └── Search TextField
    │
    ├── Currency List (ListView)
    │   └── Currency Items (with checkmark)
    │
    └── Save Button (conditional)
```

---

## 🔒 Data Persistence

### SharedPreferences Keys
```
'base_currency'         → String  (e.g., "USD")
'favorite_currencies'   → List<String> (e.g., ["EUR", "GBP", "JPY"])
'has_seen_onboarding'   → bool (e.g., true)
```

### SQLite Schema
```
Table: rates
- id                 INTEGER PRIMARY KEY
- base_currency      TEXT NOT NULL
- currency_code      TEXT NOT NULL
- rate              REAL NOT NULL
- timestamp         INTEGER NOT NULL
- UNIQUE(base_currency, currency_code)
```

---

## 🚦 Error Handling Strategy

### API Errors
```
Try API Call
  ↓ Success
  Display fresh data
  ↓ Failure
  Try Database Cache
    ↓ Has Cache
    Display cached data + warning
    ↓ No Cache
    Display error + retry button
```

### User Input Errors
```
Converter Input
  ↓ Valid Number
  Perform conversion
  ↓ Invalid
  Show "Invalid amount" message
  ↓ Empty
  Show 0.00 result
```

---

## 📊 Code Statistics

| File | Lines | Purpose | Status |
|------|-------|---------|--------|
| main.dart | ~350 | Main screen | Enhanced |
| converter_screen.dart | ~400 | Converter | Enhanced |
| settings_screen.dart | ~160 | Settings | New ✨ |
| currency_data.dart | ~150 | Data utilities | New ✨ |
| preferences_service.dart | ~80 | Preferences | New ✨ |
| api_service.dart | ~20 | API calls | Original |
| database_helper.dart | ~85 | Caching | Original |

**Total**: ~1,245 lines of application code

---

## 🎯 File Relationships

```
main.dart
├── imports: api_service, database_helper, preferences_service
├── imports: currency_data, converter_screen, settings_screen
├── navigates to: ConverterScreen, SettingsScreen
└── uses: ApiService, DatabaseHelper, PreferencesService

converter_screen.dart
├── imports: api_service, database_helper, currency_data
├── receives: initialFromCurrency, allCurrencies
└── uses: ApiService, DatabaseHelper, CurrencyData

settings_screen.dart
├── imports: preferences_service, currency_data
├── receives: currentBaseCurrency, onBaseCurrencyChanged
└── uses: PreferencesService, CurrencyData

currency_data.dart
└── standalone utility (no imports)

preferences_service.dart
├── imports: shared_preferences
└── wraps: SharedPreferences

api_service.dart
├── imports: http
└── calls: ExchangeRate-API

database_helper.dart
├── imports: sqflite, path
└── manages: SQLite database
```

---

## 🏗️ Build Configuration

### Platform Support
- ✅ Android (minimum SDK 21)
- ✅ iOS (minimum iOS 12)
- ⏳ Web (supported but not optimized)
- ⏳ Desktop (Linux, macOS, Windows - supported but not optimized)

### Build Outputs
```
build/
├── app/
│   └── outputs/
│       └── flutter-apk/
│           └── app-release.apk
└── ios/
    └── iphoneos/
        └── Runner.app
```

---

## 📱 App Lifecycle

### Cold Start
1. `main()` executes
2. `MyApp` widget builds
3. `CurrencyListPage` initializes
4. Load preferences (base currency, favorites)
5. Fetch all available currencies
6. Fetch rates for base currency
7. Display list

### Hot Reload (Development)
1. Code changes saved
2. Widget tree rebuilds
3. State preserved
4. UI updates instantly

### Background → Foreground
1. App resumes
2. Check if rates are stale (>1 hour)
3. Optionally refresh rates
4. Update UI if needed

---

## 🔐 Security Considerations

### API Keys
- ✅ No API key required (Open ExchangeRate-API)
- ✅ No authentication needed
- ✅ No user data sent to server

### Local Storage
- ✅ SharedPreferences for simple key-value data
- ✅ SQLite for structured cache data
- ✅ No sensitive data stored
- ✅ All data local to device

### Network
- ✅ HTTPS only (API uses https://)
- ✅ No custom certificates needed
- ✅ Standard Flutter HTTP client

---

## 🚀 Performance Optimization

### List Rendering
- Uses `ListView.builder` (lazy loading)
- Only visible items rendered
- Efficient for 160+ currencies

### Database
- Batch operations for caching
- Indexed unique constraint
- Single query for retrieval

### State Management
- Minimal rebuilds (only affected widgets)
- Efficient sorting algorithm
- Debounced search (no lag)

### Network
- Single API call for all rates
- Smart caching (reduces calls)
- Offline fallback (instant)

---

## 📚 Documentation Index

| File | Purpose | Audience |
|------|---------|----------|
| README.md | Project overview | All users |
| CHANGELOG.md | Version history | Developers |
| ENHANCEMENTS.md | Technical details | Developers |
| ENHANCEMENT_SUMMARY.md | Quick overview | All users |
| FEATURE_GUIDE.md | User manual | End users |
| PROJECT_STRUCTURE.md | This file | Developers |
| gemini.md | Requirements | Project team |
| Brainstorm.md | Initial ideas | Project team |

---

## 🎓 For New Developers

**Start Here**:
1. Read `README.md` for overview
2. Read `gemini.md` for requirements
3. Read `ENHANCEMENT_SUMMARY.md` for what's new
4. Explore `lib/main.dart` to understand structure
5. Review `PROJECT_STRUCTURE.md` (this file)
6. Read `ENHANCEMENTS.md` for technical deep-dive

**Common Tasks**:
- **Add new currency**: Update `currency_data.dart`
- **Change UI colors**: Modify `main.dart` theme
- **Add new feature**: Create new file in `lib/`
- **Fix bug**: Check relevant file from structure above
- **Add test**: Create test in `test/` directory

**Key Concepts**:
1. State is managed with `setState()`
2. Preferences persist with SharedPreferences
3. Rates cache with SQLite
4. API calls through ApiService
5. Navigation with Navigator.push()

---

This structure represents a clean, maintainable, and scalable Flutter application following best practices and the guidelines specified in gemini.md.
