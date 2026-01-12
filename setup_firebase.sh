#!/bin/bash

# Animigo Firebase Setup Script
# This script helps you set up Firebase for the Animigo app

echo "🔥 Animigo Firebase Setup"
echo "=========================="
echo ""

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter not found. Please install Flutter first."
    exit 1
fi

echo "✅ Flutter found"

# Check if dart is installed
if ! command -v dart &> /dev/null; then
    echo "❌ Dart not found. Please install Dart first."
    exit 1
fi

echo "✅ Dart found"

# Install FlutterFire CLI
echo ""
echo "📦 Installing FlutterFire CLI..."
dart pub global activate flutterfire_cli

# Add to PATH if not already
export PATH="$PATH":"$HOME/.pub-cache/bin"

echo ""
echo "✅ FlutterFire CLI installed"
echo ""

# Check if firebase CLI is installed
if ! command -v firebase &> /dev/null; then
    echo "⚠️  Firebase CLI not found"
    echo ""
    echo "To install Firebase CLI:"
    echo "  npm install -g firebase-tools"
    echo ""
    echo "Or visit: https://firebase.google.com/docs/cli#install_the_firebase_cli"
    echo ""
    read -p "Do you want to continue without Firebase CLI? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
else
    echo "✅ Firebase CLI found"
    echo ""
    echo "🔐 Logging into Firebase..."
    firebase login
fi

echo ""
echo "🔧 Configuring Firebase for Animigo..."
echo ""
echo "This will:"
echo "  1. Show your Firebase projects"
echo "  2. Let you select or create a project"
echo "  3. Configure Android and iOS"
echo "  4. Generate firebase_options.dart"
echo ""

# Run flutterfire configure
flutterfire configure

echo ""
echo "✅ Firebase configuration complete!"
echo ""
echo "📋 Next Steps:"
echo ""
echo "1. Enable Firebase Authentication:"
echo "   → Go to https://console.firebase.google.com/"
echo "   → Click your project"
echo "   → Authentication → Get Started"
echo "   → Enable 'Anonymous' sign-in"
echo ""
echo "2. Create Firestore Database:"
echo "   → Firestore Database → Create database"
echo "   → Start in 'test mode'"
echo "   → Select location"
echo ""
echo "3. Set Firestore Rules:"
echo "   → Copy rules from FIREBASE_SETUP.md"
echo "   → Paste in Rules tab"
echo "   → Publish"
echo ""
echo "4. Run the app:"
echo "   flutter run"
echo ""
echo "📖 For detailed instructions, see:"
echo "   → SETUP_NOW.md"
echo "   → FIREBASE_SETUP.md"
echo ""
echo "🎉 Setup script complete!"
