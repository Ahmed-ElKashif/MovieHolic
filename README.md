Markdown
<div align="center">

# 🎬 MovieHolic

**A Premium Cinematic Discovery App built with Flutter.**

[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
[![TMDB API](https://img.shields.io/badge/TMDB-API-01B4E4?style=for-the-badge&logo=themoviedatabase&logoColor=white)](https://www.themoviedb.org/)
[![DummyJSON](https://img.shields.io/badge/DummyJSON-Auth-blue?style=for-the-badge)](https://dummyjson.com/)

[Features](#-key-features) • [Tech Stack](#-tech-stack) • [Architecture](#-architecture) • [Getting Started](#-getting-started) • [Contact](#-contact)

</div>

---

**MovieHolic** is a highly polished, production-ready movie discovery application. Designed from the ground up with a custom **"Obsidian Premiere"** glassmorphic UI, it delivers a cinematic user experience. It leverages **The Movie Database (TMDB)** for real-time live data, **DummyJSON** for seamless authentication, and **Provider** for bulletproof state management.

<div align="center">
  
  *Replace this block with your screen recording GIF*
  
  ![MovieHolic Demo](https://via.placeholder.com/800x400.png?text=Insert+Screen+Recording+GIF+Here)
  
</div>

---

## ✨ Key Features

### 🎨 The "Obsidian Premiere" UI
* **Custom CustomPainter Logo:** A mathematically drawn, cinematic film-strip 'M' logo with ambient studio glows.
* **Frosted Glassmorphism:** Immersive `BackdropFilter` blurring on the sticky search bars, navigation menus, and meta-data chips.
* **Tactile Animations:** Micro-interactions on buttons and chips using `AnimatedContainer` and `GestureDetector`.
* **Cinematic Typography:** Fully integrated `Montserrat` font family for a bold, premium aesthetic.

### 🚀 Core Functionality
* **Real-Time Discovery:** Custom `SliverAppBar` with a parallax Hero poster, horizontally scrolling interactive `GenreSelector`, and a dynamic grid of trending movies.
* **Explore Engine:** A dedicated, decoupled search tab that queries TMDB instantly as you type.
* **Personal Vault:** Add and remove movies from your favorites; data is serialized and persisted locally via `SharedPreferences`.
* **Secure Auth Flow:** Demo-friendly authentication validating against DummyJSON, with a secure routing system.

---

## 🛠 Tech Stack

| Technology | Implementation |
| :--- | :--- |
| **Framework** | Flutter (Material), Dart SDK |
| **State Management** | `provider` (`ChangeNotifier` + `MultiProvider`) |
| **Networking** | `dio` (HTTP Client) |
| **Local Storage** | `shared_preferences` (Session state, Favorites JSON) |
| **Image Handling** | `cached_network_image` |
| **Architecture** | Modular UI Widgets, Service Layers, Global Providers |

---

## 🏗 Architecture & Structure

The app adheres to strict DRY principles, separating concerns into reusable widgets, dedicated API service layers, and centralized state management.

```text
lib/
├── main.dart                 # App entry, MultiProvider, Theme
├── constants/
│   └── api_constants.dart    # API_KEY and Base URLs (gitignored for security)
├── models/
│   └── movie.dart            # Movie data model serialization
├── providers/
│   ├── auth_provider.dart    # DummyJSON login state
│   └── movie_provider.dart   # TMDB fetching, search, genres, favorites
├── screens/
│   ├── explore_screen.dart   # Search functionality and results
│   ├── favorites_screen.dart # Personal vault with glowing empty state
│   ├── home_screen.dart      # Main tab shell + Trending/Genres
│   ├── movie_details_screen.dart # Parallax details view
│   ├── profile_screen.dart   # User profile and secure logout
│   └── welcome_screen.dart   # Auth screen with glass inputs
└── widgets/
    ├── genre_selector.dart   # Horizontally scrolling genre chips
    ├── glass_bottom_nav.dart # Custom frosted glass nav bar
    ├── main_background.dart  # Reusable Obsidian radial glow
    ├── movie_card.dart       # Poster cards with gradient overlays
    └── movie_holic_logo.dart # Custom Canvas-painted cinematic logo
🚀 Getting Started
Prerequisites
Flutter SDK (stable channel recommended)

Android Studio / Xcode for emulators

Installation
1. Clone the repository

Bash
git clone [https://github.com/YOUR_USERNAME/MovieHolic.git](https://github.com/YOUR_USERNAME/MovieHolic.git)
cd MovieHolic
2. Configure API Keys (Critical)
This project uses .gitignore to hide API keys. You must create the constants file manually for the app to compile.

Create the file: lib/constants/api_constants.dart and add the following:

Dart
class ApiConstants {
  static const String tmdbApiKey = 'YOUR_TMDB_API_KEY';
  static const String tmdbBaseUrl = '[https://api.themoviedb.org/3](https://api.themoviedb.org/3)';
  static const String tmdbImageBaseUrl = '[https://image.tmdb.org/t/p/w500](https://image.tmdb.org/t/p/w500)';
}
(You can obtain a free API key from your TMDB Account Settings).

3. Fetch dependencies and run

Bash
flutter pub get
flutter run
🔑 Demo Login Credentials
To test the authentication flow, use the default DummyJSON test user:

Username: emilys

Password: emilyspass

📝 Known Issues & Future Scope
Profile Settings: The settings rows in the Profile tab are currently UI placeholders.

Pagination: The movie grids currently display the first page of API results. Future updates will include infinite scroll controllers.

👨‍💻 Contact & Author
Ahmed El-Kashif Software Developer | Frontend & Cross-Platform Mobile Specialist

GitHub: [@YourGitHubHandle](https://github.com/Ahmed-ElKashif)

LinkedIn: [Ahmed El-Kashif](https://www.linkedin.com/in/ahmed-elkashif/)



Disclaimer: Movie data and images courtesy of The Movie Database (TMDB). This app is an educational portfolio piece and is not endorsed or certified by TMDB.
