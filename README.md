# BookSwap Flutter App 📚

A Flutter application for students to swap books with each other.

## Features
- 📱 Cross-platform (Web, Android, iOS)
- 🔐 Email/Password Authentication
- 📚 Book listing with image upload
- 🔄 Book swap requests and management
- 💬 Real-time chat between users
- 🔔 Notification system
- ⭐ User rating system

## 🚀 Quick Start

### Prerequisites
- Flutter SDK (3.9.2+)
- Firebase project setup

### Setup
1. Clone the repository
2. **Important**: Set up Firebase configuration (see [FIREBASE_SETUP.md](FIREBASE_SETUP.md))
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

## 🔥 Firebase Setup Required

**This app requires Firebase configuration files that are not included in the repository.**

See [FIREBASE_SETUP.md](FIREBASE_SETUP.md) for detailed setup instructions.

## 🏗️ Architecture
- **State Management**: Provider pattern
- **Database**: Cloud Firestore
- **Authentication**: Firebase Auth
- **Images**: Base64 encoding (no Firebase Storage needed)
- **Real-time**: Firestore streams
