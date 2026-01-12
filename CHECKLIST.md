# ✅ Firebase Setup Checklist

Follow this checklist to fix the Firebase error and get Animigo running!

---

## 📋 Setup Checklist

### ⚡ Quick Commands

Copy and paste these in terminal:

```bash
# 1. Install FlutterFire CLI
dart pub global activate flutterfire_cli

# 2. Add to PATH (for current session)
export PATH="$PATH":"$HOME/.pub-cache/bin"

# 3. Configure Firebase
flutterfire configure
```

---

## 🔥 Firebase Console Setup

### Step 1: Authentication
- [ ] Go to https://console.firebase.google.com/
- [ ] Open your project
- [ ] Click "Authentication" in left menu
- [ ] Click "Get Started" button
- [ ] Find "Anonymous" in the list
- [ ] Toggle "Enable" switch
- [ ] Click "Save"

✅ Authentication Done!

### Step 2: Firestore Database
- [ ] Click "Firestore Database" in left menu
- [ ] Click "Create database" button
- [ ] Select "Start in test mode"
- [ ] Choose location (any is fine)
- [ ] Click "Enable"

✅ Firestore Created!

### Step 3: Security Rules
- [ ] In Firestore, click "Rules" tab
- [ ] Delete existing rules
- [ ] Copy rules from FIREBASE_SETUP.md
- [ ] Paste into editor
- [ ] Click "Publish"

✅ Rules Set!

---

## 🎯 Verification

Check if setup worked:

```bash
# Should show REAL values (not YOUR_API_KEY)
cat lib/firebase_options.dart | grep apiKey
```

Expected:
```
apiKey: 'AIzaSyD...'  ✅ Real key
```

NOT:
```
apiKey: 'YOUR_API_KEY'  ❌ Still template
```

---

## 🚀 Run the App

```bash
flutter run
```

### Expected Result:
- [ ] App launches
- [ ] Splash screen appears
- [ ] Login screen loads
- [ ] Can create account
- [ ] Can enter lobby

✅ Everything Working!

---

## 🐛 Troubleshooting

### Issue: "flutterfire: command not found"

**Fix:**
```bash
export PATH="$PATH":"$HOME/.pub-cache/bin"
```

Or add permanently:
```bash
echo 'export PATH="$PATH":"$HOME/.pub-cache/bin"' >> ~/.zshrc
source ~/.zshrc
```

### Issue: "No Firebase projects"

**Fix:**
1. Go to https://console.firebase.google.com/
2. Click "Add project"
3. Name: "Animigo"
4. Create
5. Run `flutterfire configure` again

### Issue: Still getting error

**Fix:**
```bash
flutter clean
rm lib/firebase_options.dart
flutterfire configure
flutter pub get
flutter run
```

---

## 📖 Need More Help?

Read these in order:

1. **FIX_ERROR.md** - Main troubleshooting guide
2. **SETUP_NOW.md** - Detailed step-by-step
3. **FIREBASE_SETUP.md** - Complete documentation

Or run the automated script:
```bash
./setup_firebase.sh
```

---

## ⏱️ Time Required

- FlutterFire CLI install: 30 seconds
- Configure Firebase: 1 minute
- Enable Auth: 1 minute
- Create Firestore: 1 minute
- Set Rules: 1 minute
- **Total: ~5 minutes**

---

## 🎉 Success Indicators

You'll know it worked when:
- ✅ No Firebase errors in terminal
- ✅ App reaches login screen
- ✅ Can create username
- ✅ Can select avatar
- ✅ Can enter lobby

---

## 📞 Quick Reference

**Firebase Console:**
https://console.firebase.google.com/

**Install CLI:**
```bash
dart pub global activate flutterfire_cli
```

**Configure:**
```bash
flutterfire configure
```

**Run App:**
```bash
flutter run
```

**Clean Build:**
```bash
flutter clean && flutter pub get && flutter run
```

---

## Summary

1. ⚡ Run 3 commands (CLI + PATH + configure)
2. 🔥 Enable 2 services (Auth + Firestore)
3. 🚀 Run app

**Total: 5 minutes** → App works! 🎉

