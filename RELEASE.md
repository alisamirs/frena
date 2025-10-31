# Frena v1.0.0 Release Notes

## 🎉 First Stable Release

Frena (Forex Arena) is ready for release! This is the first stable version of our currency conversion app.

## 📱 What's Included

### Core Features
- ✅ **Real-time Currency Conversion** - Convert between 160+ currencies
- ✅ **Offline Mode** - Works without internet using cached rates
- ✅ **Favorites System** - Mark frequently used currencies
- ✅ **Smart Search** - Quickly find any currency
- ✅ **User Base Currency** - Personalize your experience
- ✅ **Modern UI** - Material Design 3 with dark mode support
- ✅ **Custom App Icon** - Professional purple icon with F₹ logo

### Technical Details
- **Framework:** Flutter 3.35.7
- **Platform:** Android (API 34+)
- **Database:** SQLite for local caching
- **API:** ExchangeRate-API (open API, no key required)

## 📦 Installation

### For Users
1. Download `app-release.apk` from the releases page
2. Enable "Install from Unknown Sources" in Android settings
3. Install the APK
4. Grant necessary permissions when prompted
5. Set your base currency on first launch

### For Developers
```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/frena.git
cd frena

# Install dependencies
flutter pub get

# Run the app
flutter run
```

## 🔧 Build from Source

```bash
# Debug build
flutter build apk --debug

# Release build (optimized)
flutter build apk --release

# The APK will be at: build/app/outputs/flutter-apk/
```

## 🐛 Known Issues
- None reported in v1.0.0

## 📋 Requirements
- Android 8.0 (API 26) or higher
- ~47MB storage space
- Internet connection for initial rate fetching (offline mode available after first fetch)

## 🙏 Attribution
This app uses the [ExchangeRate-API](https://www.exchangerate-api.com/) for real-time exchange rates.

## 📄 License
This project is licensed under the MIT License - see the LICENSE file for details.

## 🤝 Contributing
Contributions are welcome! Please feel free to submit a Pull Request.

## 📧 Support
For issues, questions, or suggestions, please open an issue on GitHub.

---

**Download:** [app-release.apk](build/app/outputs/flutter-apk/app-release.apk)

**File Size:** 46.5 MB  
**Version:** 1.0.0+1  
**Build Date:** 2025-10-31
