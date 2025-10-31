# Frena - Feature Guide

## 📱 Main Currency List Screen

The heart of Frena - see all exchange rates at a glance.

### Features:
- **App Bar Display**
  - Shows current base currency with flag emoji (e.g., 🇺🇸 Frena - USD)
  - Relative timestamp ("Updated 2h ago")
  - Settings button (gear icon)
  - Refresh button

- **Search Bar**
  - Real-time filtering
  - Search by code (e.g., "GBP") or name (e.g., "Pound")
  - Clear button appears when typing

- **Favorites Filter**
  - Chip button showing "Favorites" or "Favorites (3)"
  - Toggle to show only starred currencies
  - Number indicates how many favorites you have

- **Currency Cards**
  - Flag emoji for visual identification
  - Currency code (bold, large font)
  - Full currency name (smaller, gray)
  - Exchange rate (bold, right-aligned)
  - "1 [BASE]" label under rate
  - Star icon (filled = favorite, outline = not favorite)
  - "POPULAR" badge on common currencies

- **Smart Sorting**
  1. Your favorite currencies (starred)
  2. Popular currencies (USD, EUR, GBP, etc.)
  3. All others (alphabetically)

- **Floating Action Button**
  - Extended FAB with "Convert" label
  - Opens currency converter

- **Attribution Footer**
  - "Exchange rates provided by ExchangeRate-API.com"

### Status Indicators:
- **Offline Mode**: Orange banner with WiFi-off icon
- **Loading**: Circular progress indicator
- **Error**: Red error screen with retry button
- **Empty State**: Helpful message when no results

---

## 💱 Currency Converter Screen

Beautiful, intuitive converter with live calculations.

### Layout:

**From Currency Card** (White)
- "From" label
- Flag emoji
- Currency dropdown (shows code + name)
- Amount input field
  - Prefix icon (dollar sign)
  - Clear button when text entered
  - Large font (24px)

**Swap Button** (Center)
- Purple circular button
- Vertical swap icon
- Swaps from/to currencies instantly

**To Currency Card** (Purple tinted)
- "To" label
- Flag emoji
- Currency dropdown (shows code + name)
- Converted amount display
  - Shows "Converted Amount" label
  - Large purple number (32px, bold)
  - Copy button (clipboard icon)

**Exchange Rate Card** (Bottom)
- Shows both conversion directions:
  - "1 USD = 0.9234 EUR"
  - "1 EUR = 1.0829 USD"
- Helps understand the rate

### Features:
- **Live Conversion**: Updates as you type
- **Default Amount**: Starts with "1" for quick checks
- **Copy Function**: One-tap copy of result
- **Offline Support**: Falls back to cached rates
- **Error Display**: Clear error messages in red box
- **Smart Defaults**: Selects sensible default currencies

---

## ⚙️ Settings Screen

Clean, searchable interface for base currency selection.

### Structure:
- **Header Section**
  - "Base Currency" title (large, bold)
  - Description text explaining purpose
  - Search field with clear button

- **Currency List**
  - Scrollable list of all currencies
  - Each item shows:
    - Flag emoji (large, 32px)
    - Currency code (bold if selected)
    - Full currency name
    - Checkmark icon (if selected)
  - Selected item highlighted

- **Save Button** (Bottom)
  - Only appears when selection changed
  - Full-width purple button
  - "Save Changes" label
  - Returns to main screen on tap

### User Flow:
1. Tap settings icon in main screen
2. See current base currency highlighted
3. Search or scroll to find desired currency
4. Tap to select
5. Tap "Save Changes"
6. See success message
7. Main screen refreshes with new rates

---

## 🌟 Favorites System

Mark frequently used currencies for quick access.

### How to Use:
1. Find any currency in the main list
2. Tap the star icon on the right
3. Star fills in (becomes gold)
4. Currency moves to top of list
5. Notification: "[CODE] added to favorites"

### To Remove:
1. Tap filled star icon
2. Star becomes outline again
3. Currency moves to sorted position
4. Notification: "[CODE] removed from favorites"

### Favorites Filter:
- Tap "Favorites" chip above list
- Chip highlights when active
- List shows only starred currencies
- Tap again to show all currencies
- Shows count: "Favorites (5)"

### Persistence:
- Favorites saved automatically
- Persist across app restarts
- Synced with SharedPreferences
- No limit on number of favorites

---

## 🔍 Search Functionality

Find any currency instantly.

### Where Available:
- Main currency list
- Settings screen

### How to Search:
1. Tap search field
2. Start typing
3. Results filter in real-time
4. Tap X button to clear

### Search Matches:
- Currency code (e.g., "USD", "eur", "GbP")
- Currency name (e.g., "dollar", "Pound", "yen")
- Case-insensitive
- Partial matches work

### Examples:
- Search "ind" → Shows INR (Indian Rupee), IDR (Indonesian Rupiah)
- Search "dollar" → Shows USD, AUD, CAD, NZD, etc.
- Search "eu" → Shows EUR (Euro)

### Empty Results:
- Shows "No currencies found" with search-off icon
- Clear search to see all currencies again

---

## 📶 Offline Mode

Work without internet - cached rates always available.

### How It Works:
1. App fetches fresh rates when online
2. Rates saved to local database
3. When offline, app uses cached rates
4. Orange banner shows "Showing offline data"
5. Timestamp shows when last updated

### Offline Features:
- ✅ View currency list
- ✅ Search currencies
- ✅ Filter favorites
- ✅ Convert currencies
- ✅ Change base currency (uses cached rates)

### Visual Indicators:
- **Orange Banner**: "Showing offline data"
- **WiFi-Off Icon**: In banner
- **Timestamp**: "Last updated 2h ago"

### Reconnecting:
1. When online again, tap refresh button
2. Fresh rates download
3. Cache updates
4. Banner disappears
5. Timestamp updates

---

## 🎨 Visual Design

### Color Scheme:
- **Primary**: Purple (#7E57C2)
- **Cards**: White with subtle shadow
- **Accent**: Purple tint for highlights
- **Error**: Red (#D32F2F)
- **Warning**: Orange (#FF9800)
- **Success**: Green (#388E3C)

### Typography:
- **Headers**: Bold, 20-24px
- **Currency Codes**: Bold, 16px
- **Rates**: Bold, 16px
- **Names**: Regular, 12px
- **Labels**: Regular, 14px

### Spacing:
- **Cards**: 8px horizontal, 4px vertical margins
- **Padding**: 16px default
- **Icons**: 24-32px
- **Touch Targets**: Minimum 48x48dp

### Dark Mode:
- Automatically follows system setting
- Dark background
- Light text
- Adjusted card colors
- Same purple accent

---

## 🚀 Quick Tips

### For Travelers:
1. Set your home currency as base
2. Star the currency of your destination
3. Enable favorites filter
4. Quick glance before purchases

### For Online Shoppers:
1. Open converter
2. Enter price from website
3. Select website's currency
4. See cost in your currency
5. Copy amount for records

### For Freelancers:
1. Star currencies you work with
2. Quick rate checks from main list
3. Use converter for invoicing
4. Copy converted amounts

### For Forex Traders:
1. Star major pairs (USD, EUR, GBP, JPY)
2. Enable favorites filter
3. Quick refresh for latest rates
4. Use converter for position sizing

---

## 🔔 Notifications & Feedback

The app keeps you informed with clear notifications:

### SnackBars (Bottom of screen):
- "EUR added to favorites" (1 second)
- "GBP removed from favorites" (1 second)
- "Base currency changed to JPY" (green)
- "Copied to clipboard" (1 second)

### Banners (Top of content):
- Offline mode indicator (orange, persistent)
- Error messages (red, persistent until resolved)

### Loading States:
- Circular progress spinner (center screen)
- Appears during API calls
- Shows when switching base currency
- Displays on converter calculations

### Error States:
- Large error icon
- Clear error message
- "Try Again" button
- Helpful instructions

---

## 🎯 Pro Tips

1. **Quick Conversion**: 
   - Default amount is "1" in converter
   - Instantly see "1 USD = X" rates

2. **Smart Search**:
   - Type partial names: "pou" finds "Pound"
   - Use codes for speed: "jpy" faster than "Japanese Yen"

3. **Favorites Management**:
   - Star 5-10 currencies max for best experience
   - Use favorites filter when traveling

4. **Offline Prep**:
   - Open app before airplane mode
   - Ensure recent refresh
   - All features work offline

5. **Quick Base Change**:
   - Settings → Search → Tap → Save
   - Entire flow takes ~5 seconds

6. **Copy & Share**:
   - Use copy button in converter
   - Paste into messages, notes, etc.
   - Format: "123.45" (just the number)

---

## 📊 Feature Availability Matrix

| Feature | Main List | Converter | Settings | Offline |
|---------|-----------|-----------|----------|---------|
| View Rates | ✅ | ✅ | ❌ | ✅ |
| Search | ✅ | ❌ | ✅ | ✅ |
| Favorites | ✅ | ❌ | ❌ | ✅ |
| Convert | ❌ | ✅ | ❌ | ✅ |
| Change Base | ❌ | ❌ | ✅ | ✅ |
| Refresh | ✅ | ❌ | ❌ | ❌ |
| Copy | ❌ | ✅ | ❌ | ✅ |

---

## 🎓 Learning the App

**First Time Users (2 minutes)**:
1. Open app → See USD rates
2. Tap settings → Select your currency → Save
3. Star 2-3 important currencies
4. Try the search
5. Tap "Convert" button → Test converter

**Daily Use (<10 seconds)**:
1. Open app
2. Check rates (or enable favorites filter)
3. Done!

**Converting (<5 seconds)**:
1. Tap Convert button
2. Enter amount
3. See result
4. (Optional) Copy

**You're now a Frena expert! 🎉**
