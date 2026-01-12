# 🔥 Fix Firebase Error - Setup Instructions

You're seeing this error because Firebase hasn't been configured yet. Follow these steps:

## Option 1: Automatic Setup (RECOMMENDED - 5 minutes)

### Step 1: Install FlutterFire CLI

```bash
dart pub global activate flutterfire_cli
```

Make sure the CLI is in your PATH:
```bash
export PATH="$PATH":"$HOME/.pub-cache/bin"
```

### Step 2: Login to Firebase

```bash
firebase login
```

If you don't have Firebase CLI:
```bash
npm install -g firebase-tools
firebase login
```

### Step 3: Run FlutterFire Configure

```bash
flutterfire configure
```

This will:
1. Show your Firebase projects (or let you create one)
2. Select platforms (choose Android and iOS)
3. Automatically generate `firebase_options.dart` with correct values
4. Set up everything for you!

### Step 4: Enable Firebase Services

Go to [Firebase Console](https://console.firebase.google.com/):

**Enable Authentication:**
1. Click "Authentication" in left menu
2. Click "Get Started"
3. Click "Anonymous" under Sign-in method
4. Toggle "Enable"
5. Click "Save"

**Create Firestore Database:**
1. Click "Firestore Database" in left menu
2. Click "Create database"
3. Choose "Start in test mode"
4. Select location (any)
5. Click "Enable"

**Set Firestore Rules:**
1. Go to "Rules" tab in Firestore
2. Replace with these rules:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    match /messages/{messageId} {
      allow read: if true;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null && request.auth.uid == resource.data.senderId;
    }
    match /lobby_players/{playerId} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.uid == playerId;
    }
    match /friends/{friendId} {
      allow read: if true;
      allow create: if request.auth != null;
    }
  }
}
```

3. Click "Publish"

### Step 5: Run the App

```bash
flutter run
```

---

## Option 2: Manual Setup (If CLI doesn't work)

### Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Name it "Animigo"
4. Disable Analytics (optional)
5. Create project

### Step 2: Add Android App

1. Click Android icon
2. Package name: `com.animigo.animigo`
3. Download `google-services.json`
4. Place it in: `android/app/google-services.json`

### Step 3: Add iOS App

1. Click iOS icon
2. Bundle ID: `com.animigo.animigo`
3. Download `GoogleService-Info.plist`
4. Place it in: `ios/Runner/GoogleService-Info.plist`

### Step 4: Update firebase_options.dart

After adding apps, Firebase will show you configuration values. Update `lib/firebase_options.dart` with your actual values:

```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'YOUR_ACTUAL_API_KEY',
  appId: 'YOUR_ACTUAL_APP_ID',
  messagingSenderId: 'YOUR_ACTUAL_SENDER_ID',
  projectId: 'your-project-id',
  storageBucket: 'your-project-id.appspot.com',
);
```

### Step 5: Enable Services (Same as Option 1)

Follow Step 4 from Option 1 above.

---

## Quick Test

After setup, test if Firebase works:

```bash
flutter run
```

You should be able to:
- ✅ See splash screen
- ✅ Reach login screen
- ✅ Create an account
- ✅ Enter home screen

---

## Troubleshooting

### Error: "flutterfire: command not found"

Add pub cache to PATH:
```bash
export PATH="$PATH":"$HOME/.pub-cache/bin"
```

Or add to your `~/.zshrc` or `~/.bashrc`:
```bash
echo 'export PATH="$PATH":"$HOME/.pub-cache/bin"' >> ~/.zshrc
source ~/.zshrc
```

### Error: "No Firebase projects found"

Create a project first:
1. Go to https://console.firebase.google.com/
2. Click "Add project"
3. Follow wizard
4. Run `flutterfire configure` again

### Error: "google-services.json not found"

You need to download it from Firebase Console:
1. Go to Project Settings
2. Scroll to "Your apps"
3. Click Android app
4. Download `google-services.json`
5. Place in `android/app/`

### Error: "GoogleService-Info.plist not found"

1. Go to Project Settings
2. Click iOS app
3. Download `GoogleService-Info.plist`
4. Place in `ios/Runner/`
5. Open Xcode and add file to project

---

## Verify Setup

Check if files exist:

```bash
# Check Firebase options
ls lib/firebase_options.dart

# Check Android config
ls android/app/google-services.json

# Check iOS config
ls ios/Runner/GoogleService-Info.plist
```

If all three exist, you're ready!

---

## Need Help?

1. Watch [Firebase Flutter Setup Video](https://firebase.google.com/docs/flutter/setup)
2. Read [FlutterFire Documentation](https://firebase.flutter.dev/docs/overview)
3. Check [FIREBASE_SETUP.md](FIREBASE_SETUP.md) for detailed guide

---

## One-Line Setup (If you have Firebase CLI)

```bash
dart pub global activate flutterfire_cli && flutterfire configure
```

Then enable Authentication (Anonymous) and Firestore in Firebase Console.

Done! 🚀
