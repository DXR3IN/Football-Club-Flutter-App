# premiere_league_v2

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


# Flutter Project

This is a Flutter project that utilizes various libraries and packages for state management, networking, notifications, and other essential features.

## Features

- **State Management**: Uses MobX and Flutter MobX for reactive state management.
- **Networking**: Uses Dio for making API requests and handling responses.
- **Image Handling**: Cached Network Image is used for efficient image loading and caching.
- **Storage**: Flutter Secure Storage and Shared Preferences are utilized for securely storing data and simple key-value storage.
- **Notifications**: Firebase Cloud Messaging and Flutter Local Notifications are used for push notifications.
- **UI**: Includes SVG support, internationalization, and custom icons using Ionicons.
- **Permissions**: Permission Handler is used to manage runtime permissions.
- **Device Info**: Package Info Plus is used to retrieve app information.
- **Other**: UUID, Logger, Image Picker, and URL Launcher are used for various utility tasks.

## Requirements

- Flutter SDK
- Dart SDK
- Firebase project setup (for messaging and core services)
- Android/iOS development environment
- JDK 17 (for Android builds)
- Gradle 7.6.3 (for Android builds)

## Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/your-repo/flutter-project.git
   cd flutter-project
   flutter pub get
