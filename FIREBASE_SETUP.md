# Firebase Setup Instructions

## 🔥 Firebase Configuration Setup

This project requires Firebase configuration files that are **not included in the repository** for security reasons.

### Step 1: Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create a new project or use existing: `bookswap-application`
3. Enable Authentication → Email/Password
4. Enable Firestore Database
5. Enable Storage (optional)

### Step 2: Generate Configuration Files

#### For Flutter (All Platforms):
```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase for your project
flutterfire configure --project=bookswap-application
```

This will generate:
- `lib/firebase_options.dart`
- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`

#### Manual Setup (Alternative):
1. Copy `lib/firebase_options.template.dart` to `lib/firebase_options.dart`
2. Replace placeholder values with your Firebase project values:
   - Get values from Firebase Console → Project Settings → General
   - Replace `YOUR_PROJECT_ID`, `YOUR_API_KEY`, etc.

### Step 3: Android Setup
1. Download `google-services.json` from Firebase Console
2. Place it in `android/app/google-services.json`

### Step 4: iOS Setup (if building for iOS)
1. Download `GoogleService-Info.plist` from Firebase Console  
2. Add it to `ios/Runner/GoogleService-Info.plist`

### Step 5: Verify Setup
```bash
flutter run
```

## 🔒 Security Notes
- **Never commit** `firebase_options.dart` or `google-services.json`
- These files contain API keys and should remain private
- Use environment variables or CI/CD secrets for production builds

## 📱 Firebase Services Used
- **Authentication**: Email/Password login
- **Firestore**: Book listings, swaps, chats, ratings
- **Storage**: Base64 image storage (no Firebase Storage needed)