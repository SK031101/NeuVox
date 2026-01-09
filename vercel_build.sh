#!/bin/bash

echo "--------------------------------------------------------"
echo "  🚀 NEUVOX: INITIATING VERCEL BUILD PROTOCOL"
echo "--------------------------------------------------------"

# 1. Install Flutter
echo "--> Downloading Flutter SDK (Stable)..."
git clone https://github.com/flutter/flutter.git --depth 1 -b stable _flutter
export PATH="$PWD/_flutter/bin:$PATH"

echo "--> Flutter Configured:"
flutter --version

# 2. Install Dependencies
echo "--> Installing Dependencies..."
flutter pub get

# 3. Build Web Release
echo "--> Building Production Assets..."
flutter build web --release

echo "--------------------------------------------------------"
echo "  ✅ BUILD COMPLETE. READY FOR DEPLOYMENT."
echo "--------------------------------------------------------"
