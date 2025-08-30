# Feed App

A feed application built with Flutter, implementing modern architectural patterns and user interaction features.

## Core Functionality

**Authentication**
- Google Sign-In
- Email & Password Authentication
- Phone Number Authentication (see known issues)
- Apple Sign-In (requires Apple Developer account for testing)

**Feed Management**
- Create, edit, and delete posts with images and captions
- Cloud storage integration for images
- Scrollable feed
- Real-time like and comment counts

**Social Features**
- Like with real-time updates
- Comment with user attribution

**Additional Features**
- Dark theme and multi-color theming support
- Offline caching

## Technology Stack

**Architecture**
- Clean Architecture with distinct layers
- BLoC Pattern for state management
- Repository Pattern for data abstraction

**Database & Storage**
- Firebase Firestore for posts, comments, and user data
- Firebase Cloud Storage for media files
- Hive Database for local caching

**Authentication**
- Firebase Authentication with multiple sign-in methods

**State Management**
- Flutter BLoC for predictable state management
- Equatable for value equality
- Stream-based reactive programming

## CI/CD Pipeline

A minimal CI/CD pipeline has been integrated for automated build generation. The pipeline is configured to:
- Trigger builds on code changes
- Generate APK/IPA files for testing
- Basic build validation

## Testing

The project includes a widget test implemented for testing purposes, demonstrating the testing framework setup and serving as a foundation for expanding test coverage.

## Project Setup

**Prerequisites**
- Flutter SDK (Channel stable, 3.32.8 or higher)
- Dart SDK
- Firebase project setup
- Android Studio / VS Code
- iOS development setup (for iOS builds)

**Installation**

1. Clone the repository
```bash
git clone [repository-url]
cd social-media-app
```

2. Install dependencies
```bash
flutter pub get
```

3. Firebase Configuration
   - Create a new Firebase project
   - Enable Authentication, Firestore, and Storage services
   - Download configuration files:
      - `google-services.json` for Android (place in `android/app/`)
      - `GoogleService-Info.plist` for iOS (place in `ios/Runner/`)

4. Run the application
```bash
flutter run
```

## Architecture Decisions

**State Management Choice: BLoC Pattern**

The application uses the BLoC for state management, for:
- Separation : clear differentiation between UI and business logic
- Testability - Easy testing of business logic
- Unidirectional data flow

**Data Storage Strategy**
- Remote Database: Firebase Firestore for real-time synchronization
- Local Database: Hive database for offline support and improved performance
- Image Storage: Firebase Cloud Storage for scalable media handling

**Clean Architecture Implementation**

The project follows Clean Architecture principles:
- Domain Layer: Contains business entities and use cases and implementation of repositories
- Data Layer: Handles data sources and repositories
- Presentation Layer: Manages UI and state presentation

## Known Issues

**Phone Authentication**
Phone number authentication implementation is complete but currently untested due to Firebase App Check integrity verification issues. This is a common issue in development environments.

**Apple Sign-In**
Apple Sign-In functionality is implemented but requires an active Apple Developer account for testing and production deployment.

## Status

**Completed**
- User authentication (Google, Email/Password)
- Post creation, editing, and deletion
- Feed listing with infinite scroll
- Like and comment system
- Dark theme and multi-color theming
- Local caching with Hive
- Clean architecture implementation
- Basic CI/CD pipeline for build generation
- Widget test implementation

**In Progress**
- Phone authentication testing (pending Firebase configuration)
- Apple Sign-In testing (pending Apple Developer account)
- Source of Issue: https://docs.google.com/document/d/1nbUkaCzv2aw7aqzQjF10JRaXIiTr1aFKxtJnRt9gztg/edit?usp=sharing
- UI/UX enhancements
- Performance optimizations

## Download & Demo

**Download App**
- https://drive.google.com/file/d/14ZOqqj5GZOoI-UzovpgDFpyGy3YyBQ7-/view?usp=sharing - Download for Android devices

**Demo Video**
- https://drive.google.com/file/d/1YDYIjOIswInvowCJvl40F6kTFhxKnrge/view?usp=sharing

**Screenshots**
https://raw.github.com/Dhrumil02/social_feed_app/main/Screenshot_20250830_061520.jpg
https://github.com/Dhrumil02/social_feed_app/blob/main/screenshots/Screenshot_20250830_061520.jpg
