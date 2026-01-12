# Firebase Setup Guide for Animigo

Follow these steps to set up Firebase for your Animigo app.

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Enter project name: **Animigo**
4. Disable Google Analytics (optional for now)
5. Click "Create project"

## Step 2: Register Your App

### For iOS:

1. Click the iOS icon in Firebase console
2. Enter iOS bundle ID: `com.animigo.animigo`
3. Download `GoogleService-Info.plist`
4. Place it in `ios/Runner/` directory
5. Open `ios/Runner.xcworkspace` in Xcode
6. Add the file to the project (drag and drop into Xcode)

### For Android:

1. Click the Android icon in Firebase console
2. Enter package name: `com.animigo.animigo`
3. Download `google-services.json`
4. Place it in `android/app/` directory

## Step 3: Configure Firebase Authentication

1. In Firebase Console, go to **Authentication**
2. Click "Get Started"
3. Enable **Anonymous** authentication
   - This is what we use for username-based signup
   - Click "Anonymous" → Enable → Save

## Step 4: Configure Firestore Database

1. In Firebase Console, go to **Firestore Database**
2. Click "Create database"
3. Choose **Start in test mode** (for development)
4. Select your preferred location
5. Click "Enable"

### Set up Firestore Rules (Important!):

Go to **Rules** tab and paste this:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.uid == userId;
    }

    // Messages collection
    match /messages/{messageId} {
      allow read: if true;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null && request.auth.uid == resource.data.senderId;
    }

    // Lobby players collection
    match /lobby_players/{playerId} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.uid == playerId;
    }

    // Friends collection
    match /friends/{friendId} {
      allow read: if true;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null &&
        (request.auth.uid == resource.data.userId ||
         request.auth.uid == resource.data.friendId);
    }
  }
}
```

Click **Publish**

## Step 5: FlutterFire CLI Setup (Recommended)

This automates the Firebase configuration for Flutter:

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Run configuration
flutterfire configure
```

This will:
- Create `firebase_options.dart` automatically
- Configure all platforms
- Set up Firebase in your app

## Step 6: Update main.dart

The `main.dart` is already configured, but if using FlutterFire CLI, update the import:

```dart
import 'firebase_options.dart';

// In main():
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

## Step 7: Test the Setup

Run the app:

```bash
flutter run
```

Expected behavior:
- Splash screen should appear
- Login screen should load
- You should be able to create an account
- No Firebase errors in console

## Firestore Collections Structure

The app uses these collections:

### **users**
```
{
  "uid": "string",
  "username": "string",
  "avatar": "warrior|mage|ninja|samurai|archer|healer",
  "status": "online|offline|in_lobby",
  "createdAt": "timestamp",
  "lastSeen": "timestamp"
}
```

### **messages**
```
{
  "id": "string",
  "senderId": "string",
  "senderName": "string",
  "receiverId": "string",
  "content": "string",
  "type": "dm|lobby",
  "timestamp": "timestamp",
  "isRead": "boolean"
}
```

### **lobby_players**
```
{
  "uid": "string",
  "username": "string",
  "avatar": "string",
  "x": "number",
  "y": "number",
  "direction": "left|right|up|down",
  "isMoving": "boolean",
  "lastUpdate": "timestamp"
}
```

### **friends**
```
{
  "id": "string",
  "userId": "string",
  "friendId": "string",
  "friendUsername": "string",
  "friendAvatar": "string",
  "status": "pending|accepted",
  "createdAt": "timestamp"
}
```

## Troubleshooting

### "Firebase not initialized" error:
- Make sure you ran `flutterfire configure`
- Check that `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) are in correct locations

### "Anonymous sign-in is disabled":
- Go to Firebase Console → Authentication → Sign-in method
- Enable Anonymous authentication

### "Missing permissions" error:
- Check Firestore Rules in Firebase Console
- Make sure rules allow read/write for authenticated users

### iOS build errors:
- Run `cd ios && pod install`
- Clean build folder in Xcode

## Next Steps

Once Firebase is set up:
1. Run `flutter pub get`
2. Run `flutter run`
3. Test user registration
4. Test lobby entry
5. Test multi-player with multiple devices/emulators

## Production Checklist

Before deploying:
- [ ] Update Firestore rules to production mode
- [ ] Enable proper authentication (email/password)
- [ ] Set up Firebase Security Rules
- [ ] Enable Firebase App Check
- [ ] Set up Firebase Analytics (optional)
- [ ] Configure rate limiting
