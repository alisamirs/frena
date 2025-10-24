# Gemini Project Configuration

## 1. Project Overview

*   **Project Name:** Frena (Forex Arena)
*   **Description:** Frena demystifies foreign exchange for everyday life. Our mission is to break down financial barriers by providing instant, clear, and accurate currency conversion, empowering you to make confident decisions in a connected world.
*   **Goals:**
    *  Build & launch a stable, reliable MVP with core features.
    *  Core features (converter, list) have 0 critical bugs.
*   **Current Status:** In development

## 2. Technical Stack

*   **Primary Language(s):** Dart
*   **Framework(s) / Libraries:** Flutter
*   **Database:** SQLite (for local caching of currency rates, using the `sqflite` package)
*   **Package Manager:** Dart Pub
*   **UI/CSS Framework:** Flutter's built-in Material Design widgets

## 3. Development Workflow

*   **Installation:** `flutter pub get`
*   **Running the application:** `flutter run`
*   **Running tests:** `flutter test`
*   **Linting and formatting:** `dart format .`
*   **Building for production:** `flutter build apk` or `flutter build ios`

## 4. Coding Style and Conventions

*   **Formatting:** "Follow the official Dart style guide and use the built-in `dart format` tool."
*   **Naming Conventions:** "Follow standard Dart conventions (e.g., `camelCase` for variables, `PascalCase` for classes)."
*   **Typing:** "Utilize Dart's sound null safety features."
*   **Architectural Patterns:** "We will start with a simple state management approach (like `setState`) and can later adopt a more advanced pattern like Provider or BLoC if needed."
*   **Comments:** "Add comments to explain complex logic. Use `///` for documentation comments on public APIs."

## 5. Key Files & Directories

*   `src/`: [Main application source code]
*   `tests/`: [Unit and integration tests]
*   `docs/`: [Project documentation]
*   `.env.example`: [Example environment variables]
*   `README.md`: [Project overview and setup instructions]

## 6. Gemini's Behavior (Dos and Don'ts)

**Please DO:**

*   ✅ **Always run tests** after making changes to ensure nothing is broken.
*   ✅ **Adhere strictly to the coding style** defined in this document and in existing files.
*   ✅ **Add new tests** for new features or bug fixes.
*   ✅ **Keep changes small and focused** on a single task.
*   ✅ **Ask for clarification** if a request is ambiguous.

**Please DON'T:**

*   ❌ **Do not install new dependencies** without asking first.
*   ❌ **Do not make major architectural changes** without discussing them.
*   ❌ **Do not commit secrets or API keys** to the codebase.
*   ❌ **Do not remove existing tests** unless they are no longer relevant.

## 7. The Core Problem You Are Solving

The fundamental problem is **financial information asymmetry in a globalized world**. People need to quickly and accurately understand the value of foreign money in terms of their own local currency.

This problem manifests in several user scenarios:

*   **For Travelers:** "How much will this $50 hotel room cost me in my local currency (e.g., Indian Rupees)?"
*   **For Online Shoppers:** "Is this deal from a US website actually good when I convert the price from USD to my currency?"
*   **For Freelancers & Remote Workers:** "My client is paying me in Euros. How much will I receive in my local bank account this month?"
*   **For Investors & Traders:** "I need to monitor the general trend of major currency pairs (like EUR/USD, GBP/JPY)."
*   **For Immigrants sending Remittances:** "I want to send money back home. When is the best time to get the most local currency for my dollars?"


## 8. Key Features & Functionality for Your App

Based on the problem, here is a list of features your app should have:
#### 1. Core Features (Must-Haves)

*   **User-Defined Base Currency:** Allow the user to set their "home" or "functional" currency (e.g., INR, EUR, GBP) upon first launch.
*   **Real-Time & Accurate Exchange Rates:** The heart of the app. You need a reliable data source (API) that provides updated rates.
*   **Currency Converter:** A simple, clean interface with:
    *   A field for the amount.
    *   A "From" currency selector.
    *   A "To" currency selector.
    *   A prominently displayed result.
*   **Currency List / Watchlist:** A main screen showing the current value of major currencies relative to the user's base currency.
    *   *Example:* If base is **EGP**, it would show: **1 USD = 47.59 EGP**, **1 EUR = 55.37 EGP**, etc.
*   **Offline Mode (Cached Rates):** Store the last fetched rates so the app is still usable without an internet connection (with a clear "last updated" timestamp).

#### 2. Enhanced Features (Nice-to-Haves)

*   **Favorites/Preferred Currencies:** Let users pin their most frequently used currencies (e.g., USD, EUR, GBP) to the top of the list.
*   **Historical Charts:** Show line charts for currency pairs over different time periods (1 day, 1 week, 1 month, 1 year). This is crucial for seeing trends.
*   **Currency Alerts:** Allow users to set price alerts (e.g., "Notify me when 1 USD > 85 INR").
*   **Search Functionality:** Quickly find a currency from the long list of global currencies.
*   **"Swap" Button:** In the converter, a button to instantly swap the "From" and "To" currencies.

#### 3. Advanced Features (For Future Versions)

*   **Multi-Currency Converter:** Convert one amount into multiple currencies at once (useful for trip planning).
*   **Currency News & Analysis:** Integrate financial news feeds related to forex markets.
*   **Calculators:** Specific calculators for pip values, margin, etc., targeted at forex traders.
*   **Beautiful, Intuitive UI/UX:** A clean, fast, and professional design that makes checking rates a pleasure.

## 9. The Technical Problem: How to Get the Data

You **cannot** manually maintain exchange rates. You need a **Forex Data API**.

**Chosen API:**

1.  **ExchangeRate-API (Open API):** Free, no API key required, excellent for personal projects and open-source applications. Requires attribution in the UI.

**How it works technically:**
Your app will send a request to the API's server (e.g., `https://open.er-api.com/v6/latest/USD`). The server responds with a JSON file containing all the latest rates. Your app then parses this JSON and displays the data beautifully.

## 10. Step-by-Step Plan to Create the App

1.  **Define Your MVP (Minimum Viable Product):**
    *   Screen 1: A list showing rates for top 10 currencies vs. the user's base.
    *   Screen 2: A simple converter.
    *   Settings: Ability to change the base currency.

2.  **Choose Your Technology:**
    *   **Mobile App:**
        *   **Native:** Kotlin/Java (for Android). 
        *   **Cross-Platform:** Flutter (Dart) or React Native (JavaScript). Build for both iOS & Android with one codebase. **This is a great choice for this type of app.**
    *   **Web App:** React.js, Vue.js, or Angular. Accessible to everyone via a browser.

3.  **Design the User Interface (UI):**
    *   Sketch the screens on paper or use a tool like Figma.
    *   Focus on clarity and large, easy-to-read numbers.

4.  **Develop the Core Features:**
    *   Set up your development environment.
    *   Integrate your chosen Forex API.
    *   Build the currency list screen.
    *   Build the converter screen.

5.  **Test Thoroughly:**
    *   Test with different base currencies.
    *   Test the conversion calculations.
    *   Test the app without an internet connection.

6.  **Deploy and Launch:**
    *   For mobile apps, publish on the Google Play Store.
    *   For a web app, deploy it to a hosting service like Netlify or Vercel.

### Potential Challenges to Keep in Mind

*   **Data Accuracy & Latency:** The app is useless with wrong or stale data. Choose a reliable API.
*   **Internet Dependency:** You must handle cases where the user is offline gracefully.
*   **Battery Usage:** Frequent API calls can drain the battery. Implement smart caching and update intervals.
*   **Monetization:** How will you make money? designing a service or product that is fully free but allows for donations, the core problem you're solving isn't a traditional business one (like "lack of trust" or "inefficiency"). Instead, it shifts to a problem of sustainability and value exchange in the non-profit or public good space..






