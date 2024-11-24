# premiere_league_v2

Link to open the app: [Home link](https://dxr3in.github.io/premiere-league-teams-flutter/home)

Link to open the detail club of arsenal: [Detail link](https://dxr3in.github.io/premiere-league-teams-flutter/detail/Arsenal)

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

# Flutter App Demo

This is a demo Flutter app that demonstrates various features including a main screen, detail screen, favorite screen, and notification functionality. The app showcases state management using MobX, API integration, and local storage for favorite items.

## Screenshots

### Main Screen

The main screen displays a grid of football teams fetched from an API. Users can search for teams, view team details, and navigate to the favorite screen.

<div align="center" style="display: flex; align-items: center; justify-content: center;">
  <h2 style="margin: 0 20px;">First look ></h2>
  <img src="https://github.com/user-attachments/assets/6b07bf1b-e04b-4f3f-9bae-d7102b7c15fe" alt="Main Screen" width="300"/>
  <h2 style="margin: 0 20px;">New Look 1.0 ></h2>
  <img src="https://github.com/user-attachments/assets/97e0333b-74c1-47ba-a6c7-7ffbc5ac9cf1" alt="Main Screen" width="300"/>
  <h2 style="margin: 0 20px;">New Look 2.0 ></h2>
  <img src="https://github.com/user-attachments/assets/3aadcec3-a592-4855-9b4e-7f92afd747f6" alt="Main Screen" width="300"/>

</div>


### Detail Screen

On the detail screen, users can view more information about a selected football team, including its stats and other details. Users can also add the team to their favorites.

<div align="center" style="display: flex; align-items: center; justify-content: center;">
  <h2 style="margin: 0 20px;">First look ></h2>
   <img src="https://github.com/user-attachments/assets/47ae9db4-9ec0-4bfd-bee5-49796748c226" alt="Detail Screen" width="300"/>
  <br/>
   <h2 style="margin: 0 20px;">New Look 1.0 ></h2>
   <img src="https://github.com/user-attachments/assets/5563b929-d510-4caa-9bb3-8b6dbbde51e2" alt="Detail Screen" width="300"/>
  <br/>
  <h2 style="margin: 0 20px;">New Look 2.0 ></h2>
  <img src="https://github.com/user-attachments/assets/210829a8-dda6-4b7a-b187-c26ef1065be4" alt="Detail Screen" width="300"/>
  <img src="https://github.com/user-attachments/assets/1a199ae8-2044-46d4-b182-8c46f6ba74b6" alt="Detail Screen" width="300"/>
</div>
### Favorite Screen

The favorite screen displays a list of all teams that the user has marked as favorites. Users can remove teams from their favorites, and the list will update in real-time.

<img src="https://github.com/user-attachments/assets/92671f3c-57a3-4499-8772-4e4e3204fb7e" alt="Favorite Screen" width="300"/>

### Notification

The app includes notification functionality using Firebase Cloud Messaging. Users receive push notifications for updates or important announcements. Local notifications are also used to alert users of actions within the app.

<img src="https://github.com/user-attachments/assets/88be45f7-d91d-4d34-a007-106ba82a189a" alt="Foreground Notification" width="300"/>

<img src="https://github.com/user-attachments/assets/e0796f2f-8bad-4d1c-9a9e-df625421260d" alt="Background and Terminate Notification" width="300"/>

<img src="https://github.com/user-attachments/assets/4e780351-1a77-4da5-9b77-46859bf1464e" alt="Background and Terminate Notification" width="300"/>

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
