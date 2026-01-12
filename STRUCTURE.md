# Animigo - Project Structure

## Folder Architecture

```
lib/
├── config/          # App configuration (colors, theme, constants)
├── models/          # Data models (User, Message, Character)
├── services/        # Business logic (Firebase, Auth)
├── providers/       # State management (Provider)
├── screens/         # All app screens
│   ├── splash/
│   ├── auth/
│   ├── home/
│   └── lobby/
├── widgets/         # Reusable UI components
├── game/            # Flame game components
│   ├── components/  # Game entities (Character, Map)
│   ├── controllers/ # Input handling (Joystick)
│   └── lobby_world.dart
└── utils/           # Helper functions

assets/
├── images/          # App images (splash, backgrounds)
├── characters/      # Character sprites and animations
├── icons/           # App icons
└── lobby/           # Lobby map assets
```

## Tech Stack

- **Framework**: Flutter 3.35+
- **Game Engine**: Flame 1.18+
- **Backend**: Firebase (Auth, Firestore, Storage)
- **State Management**: Provider
- **UI**: Material Design with custom anime theme

## Core Features

1. **Authentication**: Firebase Auth with username + avatar
2. **Friends System**: Real-time friend list with online status
3. **Chat**: DM chat (pre-lobby) + Proximity chat (in-lobby)
4. **Lobby**: Multiplayer anime world with character movement
5. **Real-time Sync**: Player positions and chat bubbles

## Data Flow

```
User Login → Firebase Auth
    ↓
Home Screen (Friends + Chats)
    ↓
Enter Lobby → Flame Game World
    ↓
Joystick Input → Character Movement → Firestore Sync
    ↓
Proximity Detection → Chat Bubbles
```
