class AppConstants {
  // App info
  static const String appName = 'Animigo';
  static const String appVersion = '1.0.0';

  // Lobby settings
  static const double lobbyWidth = 800.0;
  static const double lobbyHeight = 600.0;
  static const double characterSize = 48.0;
  static const double characterSpeed = 120.0; // pixels per second

  // Proximity chat settings
  static const double proximityRadius = 150.0; // Distance for chat visibility
  static const double interactionRadius = 80.0; // Distance for interaction

  // Chat bubble settings
  static const int chatBubbleDisplayDuration = 5; // seconds
  static const int maxChatMessageLength = 100;

  // Animation settings
  static const int idleAnimationDelay = 30; // seconds before idle animation
  static const int sleepAnimationDelay = 120; // seconds before sleep animation

  // Firestore collections
  static const String usersCollection = 'users';
  static const String messagesCollection = 'messages';
  static const String lobbyPlayersCollection = 'lobby_players';
  static const String friendsCollection = 'friends';

  // Avatar types
  static const List<String> avatarTypes = [
    'warrior',
    'mage',
    'ninja',
    'samurai',
    'archer',
    'healer',
  ];

  // User status
  static const String statusOnline = 'online';
  static const String statusOffline = 'offline';
  static const String statusInLobby = 'in_lobby';
}
