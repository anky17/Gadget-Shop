# 🛍️ Gadgetshop

A modern cross-platform e-commerce application built with Flutter for desktop environments, featuring a clean UI, seamless authentication, and responsive design.

## 📱 Features

### Authentication

- 🔐 Firebase Authentication integration
- 🌐 Google Sign-In support
- ✉️ Email/Password authentication
- 🔄 Persistent login state
- 🔑 Password recovery functionality

### User Interface

- 🎬 Animated splash screen with Lottie animations
- 🏠 Feature-rich home screen with:
  - 🖼️ Banner carousel slider for promotions
  - 🔎 Category navigation slider
  - ⚡ Flash sales section
  - 📜 Custom navigation drawer
- 🛒 Product browsing and detailed product views
- 🔍 Search functionality
- 👤 User profile management

## 🛠️ Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (version ^3.6.0)
- [Dart SDK](https://dart.dev/get-dart) (compatible with Flutter ^3.6.0)
- [Firebase Project](https://console.firebase.google.com/) (for authentication and cloud services)
- Desktop environment setup:
  - macOS: Xcode command line tools
  - Windows: Visual Studio with Desktop development with C++ workload
  - Linux: Required dependencies as per Flutter documentation

## 📦 Dependencies

### Core

```yaml
flutter_sdk: ^3.6.0
cupertino_icons: ^1.0.2
```

### Firebase

```yaml
firebase_core: ^2.9.0
firebase_auth: ^4.4.0
cloud_firestore: ^4.5.0
google_sign_in: ^6.1.0
```

### State Management

```yaml
get: ^4.6.5
```

### UI Components

```yaml
lottie: ^2.3.2
flutter_easyloading: ^3.0.5
cached_network_image: ^3.2.3
carousel_slider: ^4.2.1
```

For a complete list of dependencies, refer to the `pubspec.yaml` file.

## 🚀 Installation and Setup

### 1. Clone the repository

```bash
git clone https://your-repository-url/gadgetshop.git
cd gadgetshop
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Firebase Configuration

#### a. Create a Firebase project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project named "Gadgetshop"
3. Enable Authentication (Email/Password and Google Sign-in)
4. Set up Firestore database

#### b. Configure Firebase for Flutter

1. Install Firebase CLI and FlutterFire CLI:

```bash
npm install -g firebase-tools
dart pub global activate flutterfire_cli
```

2. Log in to Firebase:

```bash
firebase login
```

3. Configure your app:

```bash
flutterfire configure --project=your-firebase-project-id
```

4. Ensure the following files are properly configured:
   - `android/app/google-services.json`
   - `ios/Runner/GoogleService-Info.plist`
   - `macos/Runner/GoogleService-Info.plist`
   - `lib/firebase_options.dart`
