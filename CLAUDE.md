# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter application using Riverpod for state management and flutter_inappwebview for web content display. The project follows a feature-based architecture with clear separation of concerns.

## Commands

### Development
```bash
flutter run                    # Run the app on connected device/emulator
flutter run -d chrome         # Run on Chrome (web)
flutter run -d ios            # Run on iOS simulator
flutter run -d android        # Run on Android emulator
```

### Building
```bash
flutter build apk             # Build Android APK
flutter build ios             # Build iOS app (requires Mac)
flutter build web             # Build for web
flutter build appbundle       # Build Android App Bundle
```

### Testing
```bash
flutter test                  # Run all tests
flutter test test/widget_test.dart  # Run specific test file
```

### Code Quality
```bash
flutter analyze               # Run static analysis
flutter format .              # Format all Dart files
```

### Dependencies
```bash
flutter pub get               # Install dependencies
flutter pub upgrade           # Upgrade dependencies
flutter pub outdated          # Check for outdated packages
```

### Code Generation (Riverpod)
```bash
flutter pub run build_runner build          # Run code generation once
flutter pub run build_runner watch          # Watch for changes and regenerate
flutter pub run build_runner build --delete-conflicting-outputs  # Force regeneration
```

## Architecture

### Project Structure
```
lib/
├── main.dart              # App entry point with ProviderScope
├── core/                  # Core functionality
│   ├── provider/         # Global providers (app state, loading, errors)
│   └── router.dart       # GoRouter configuration
└── feature/              # Feature modules
    ├── splash/           # Splash screen feature
    │   ├── splash_view.dart
    │   └── splash_view_model.dart
    └── webview/          # WebView feature
        ├── webview_page.dart
        └── webview_controller.dart
```

### State Management Pattern
- **Riverpod** with StateNotifier pattern
- ViewModels use StateNotifier for complex state
- Simple state uses StateProvider
- Family providers for parameterized state (e.g., WebView per URL)

### Navigation
- **GoRouter** for declarative routing
- Routes defined in `core/router.dart`
- Named routes for type-safe navigation
- Query parameters support for WebView URLs

### Key Dependencies
- `flutter_riverpod` - State management
- `riverpod_annotation` - Code generation support
- `flutter_inappwebview` - WebView implementation
- `go_router` - Navigation
- `riverpod_generator` - Code generation for Riverpod
- `build_runner` - Build system for code generation

### WebView Implementation
- Uses `flutter_inappwebview` for advanced WebView features
- Supports navigation controls (back, forward, reload)
- Progress indicator during page loads
- Error handling with retry functionality
- URL updates in app bar

### Development Notes
- App starts with SplashView that auto-navigates to WebView after 2 seconds
- WebView defaults to Google if no URL provided
- Each WebView instance has its own controller via family provider
- Linear progress indicator shows page load progress
- Bottom navigation bar provides back/forward controls