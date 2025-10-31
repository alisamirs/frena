# Changelog

All notable changes to the Frena project will be documented in this file.

## [1.0.0] - 2025-10-31

### 🎉 First Stable Release

This is the first production-ready release of Frena!

### Added
- **Custom App Icon**: Professional purple launcher icon with F₹ logo
- **Adaptive Icons**: Support for Android adaptive icons with themed backgrounds
- **Favorites System**: Users can now mark currencies as favorites for quick access
  - Star/unstar currencies with a single tap
  - Favorites appear at the top of the currency list
  - Filter to show only favorite currencies
  - Persistent favorites using SharedPreferences

- **Search Functionality**: Quickly find currencies by code or name
  - Real-time search filtering
  - Search by currency code (e.g., "USD") or full name (e.g., "Dollar")
  - Clear search button for quick reset

- **Settings Screen**: Dedicated settings interface
  - Better base currency selection with search
  - Visual currency selection with flags
  - Confirmation before changing base currency

- **Currency Information Enhancements**:
  - Currency flags (emoji) for visual identification
  - Full currency names displayed alongside codes
  - Popular currencies highlighted with badges
  - Smart sorting: Favorites → Popular → Alphabetical

- **Enhanced Converter**:
  - Live conversion as you type
  - Improved visual design with card-based layout
  - Copy converted amount to clipboard
  - Exchange rate display (bidirectional)
  - Better error handling and offline support
  - Default amount of "1" for quick conversions
  - Currency swap with visual feedback

- **User Experience Improvements**:
  - Better error messages with icons
  - Relative timestamps ("2h ago" instead of full date)
  - Offline indicator banner
  - Extended floating action button with "Convert" label
  - Loading states and skeleton screens
  - Improved color scheme (purple theme)
  - Dark mode support

- **Persistence**:
  - User preferences saved locally (base currency, favorites)
  - Preferences persist across app restarts
  - Onboarding state tracking

### Changed
- Updated Material Design to version 3
- Improved app theme with custom color scheme
- Enhanced card layouts with better spacing
- Better visual hierarchy in currency list
- Converter screen now accepts initial currency parameter
- Improved timestamp formatting for better readability

### Technical Improvements
- Added `shared_preferences` package for user preferences
- Added `flutter_svg` package for future SVG support
- Created modular service files:
  - `currency_data.dart` - Currency information utilities
  - `preferences_service.dart` - User preferences management
  - `settings_screen.dart` - Settings UI component
- Better state management structure
- Improved offline caching fallback mechanism
- More robust error handling throughout the app

### Fixed
- Better handling of API failures
- Improved offline mode detection and messaging
- Fixed potential null reference issues
- Better keyboard input handling in converter

## [1.0.0] - Initial Release

### Added
- Basic currency rate listing
- Simple currency converter
- Offline caching with SQLite
- Base currency selection dropdown
- Integration with ExchangeRate-API
