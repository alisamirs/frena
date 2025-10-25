# Frena (Forex Arena)

![Frena Banner](https://placehold.co/1200x400/7e57c2/ffffff?text=Frena)

> Frena demystifies foreign exchange for everyday life. Our mission is to break down financial barriers by providing instant, clear, and accurate currency conversion, empowering you to make confident decisions in a connected world.

---

## About The Project

In a globalized world, understanding the value of foreign money is essential for travelers, online shoppers, freelancers, and more. Frena was built to solve this problem by providing a simple, fast, and reliable currency conversion tool that works both online and offline.

This project is an open-source mobile application built with Flutter.

## Features

*   **Real-Time Exchange Rates:** Get the latest rates for over 160 currencies.
*   **Currency Converter:** A simple, intuitive interface to convert between currencies.
*   **User-Defined Base Currency:** Set your home currency for a personalized experience.
*   **Offline Mode:** The app caches the last fetched rates, so it's always available, even without an internet connection.
*   **Comprehensive Currency List:** View a full list of exchange rates against your chosen base currency.

## Screenshots

| Currency List | Converter |
| :---: | :---: |
| ![Screenshot of Currency List](https://placehold.co/300x600/ffffff/000000?text=Currency+List+Screen) | ![Screenshot of Converter](https://placehold.co/300x600/ffffff/000000?text=Converter+Screen) |

## Architecture Overview

Frena is built using the Flutter framework and the Dart language. The architecture is designed to be simple and maintainable, consisting of three main parts:

1.  **UI Layer:** The user interface is built with Flutter's Material Design widgets. It consists of two main screens: `CurrencyListPage` and `ConverterScreen`.
2.  **Services Layer:**
    *   `ApiService`: Handles all communication with the external currency exchange rate API (ExchangeRate-API).
    *   `DatabaseHelper`: Manages the local SQLite database for caching currency rates, enabling offline functionality.
3.  **Data Layer:**
    *   **Remote:** Fetches live data from the [ExchangeRate-API "Open API"](https://www.exchangerate-api.com).
    *   **Local:** A SQLite database stores the most recent rates for offline access.

## Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

*   **Flutter SDK:** Make sure you have the Flutter SDK installed. For installation instructions, see the [official Flutter documentation](https://flutter.dev/docs/get-started/install).

### Installation & Running

1.  **Clone the repo:**
    ```sh
    git clone https://github.com/alisamirs/frena.git
    ```
2.  **Navigate to the project directory:**
    ```sh
    cd frena
    ```
3.  **Install dependencies:**
    ```sh
    flutter pub get
    ```
4.  **Run the app:**
    ```sh
    flutter run
    ```

## Demo

![App Demo GIF](https://placehold.co/600x400/7e57c2/ffffff?text=App+Demo+GIF)

---
