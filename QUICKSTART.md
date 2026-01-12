# Animigo - Quick Start Guide

Get Animigo up and running in 5 minutes!

## Before You Start

Make sure you have:
- [ ] Flutter 3.35+ installed (`flutter --version`)
- [ ] Firebase account created
- [ ] iOS/Android emulator or physical device ready

## Setup Steps

### 1. Install Dependencies (1 min)

```bash
cd Animigo
flutter pub get
```

### 2. Firebase Setup (3 min)

**Option A: FlutterFire CLI (Recommended)**

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase (this will create firebase_options.dart)
flutterfire configure
```

Follow the prompts:
- Select your Firebase project (or create new)
- Select platforms (iOS, Android)
- Done!

**Option B: Manual Setup**

See detailed instructions in [FIREBASE_SETUP.md](FIREBASE_SETUP.md)

### 3. Enable Firebase Services (2 min)

Go to [Firebase Console](https://console.firebase.google.com/):

1. **Authentication**
   - Click "Get Started"
   - Enable "Anonymous" sign-in
   - Save

2. **Firestore Database**
   - Click "Create database"
   - Start in **test mode**
   - Copy rules from [FIREBASE_SETUP.md](FIREBASE_SETUP.md)
   - Publish rules

### 4. Run the App! (1 min)

```bash
flutter run
```

## Testing the App

### Test User Registration
1. Launch app
2. Enter username: `TestUser1`
3. Select any avatar
4. Click "Enter Animigo"
5. You should see the Home screen

### Test Lobby
1. Go to "Lobby" tab
2. Click "Enter Lobby"
3. Use joystick to move character
4. Character should move smoothly

### Test Multiplayer (2 devices needed)
1. Launch app on Device 1, create user: `User1`
2. Launch app on Device 2, create user: `User2`
3. Both enter lobby
4. You should see both characters in the lobby
5. Move close to each other
6. Test chat functionality

## Troubleshooting

### App crashes on launch
**Solution**: Make sure Firebase is initialized
```bash
flutterfire configure
```

### "Firebase not found" error
**Solution**: Add firebase_options.dart manually or run:
```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

### Characters not syncing
**Solution**: Check Firestore rules allow read/write
- Go to Firebase Console → Firestore → Rules
- Ensure rules allow authenticated users

### Joystick not working
**Solution**: Make sure you're in the lobby screen (not lobby entry)

## Project Structure Overview

```
Animigo/
├── lib/
│   ├── main.dart              # Entry point
│   ├── config/                # Theme & constants
│   ├── models/                # Data models
│   ├── services/              # Firebase services
│   ├── providers/             # State management
│   ├── screens/               # UI screens
│   │   ├── splash/
│   │   ├── auth/
│   │   ├── home/
│   │   └── lobby/
│   └── game/                  # Flame game engine
│       ├── lobby_world.dart
│       ├── components/
│       └── controllers/
└── assets/                    # Images & sprites
```

## Key Files to Know

| File | Purpose |
|------|---------|
| `lib/main.dart` | App entry point |
| `lib/config/constants.dart` | App-wide settings |
| `lib/game/lobby_world.dart` | Main game world |
| `lib/services/auth_service.dart` | Authentication logic |
| `FIREBASE_SETUP.md` | Detailed Firebase guide |

## Common Commands

```bash
# Install dependencies
flutter pub get

# Run app
flutter run

# Run on specific device
flutter run -d <device-id>

# Build for Android
flutter build apk

# Build for iOS
flutter build ios

# Clean build
flutter clean
flutter pub get
flutter run

# Check for issues
flutter doctor
```

## Next Steps

Once the app is running:
1. ✅ Test user registration with different usernames
2. ✅ Try all 6 avatar types
3. ✅ Explore the Friends tab
4. ✅ Enter the lobby and move around
5. ✅ Test with 2+ devices for multiplayer
6. ✅ Test proximity chat

## Need Help?

- 📖 Read [README.md](README.md) for full documentation
- 🔥 Check [FIREBASE_SETUP.md](FIREBASE_SETUP.md) for Firebase issues
- 🏗️ Review [STRUCTURE.md](STRUCTURE.md) for architecture
- 🐛 Open an issue on GitHub for bugs

## Development Tips

### Hot Reload
- Press `r` in terminal to hot reload
- Press `R` to hot restart
- Press `q` to quit

### Debugging
- Use Flutter DevTools for debugging
- Check Firebase Console for real-time data
- Use `print()` statements in code

### Performance
- Test on real devices for accurate performance
- Use `flutter run --release` for production builds

---

Happy coding! 🎮
