#!/bin/bash

# Comprehensive build script for iOS with Razorpay fix
# This script ensures nested frameworks are removed before archiving

set -e

echo "🚀 Starting iOS build with Razorpay fix..."

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean
cd ios
rm -rf build
rm -rf Pods/.symlinks
rm -rf ~/Library/Developer/Xcode/DerivedData/Runner-*
cd ..

# Get dependencies
echo "📦 Getting Flutter dependencies..."
flutter pub get

# Install pods
echo "🔧 Installing iOS pods..."
cd ios
pod deintegrate || true
pod install
cd ..

# Build iOS
echo "🏗️  Building iOS release..."
flutter build ios --release --no-codesign

# Find and fix Razorpay framework in build output
echo "🔧 Fixing Razorpay framework in build output..."

BUILD_APP_PATH="build/ios/Release-iphoneos/Runner.app"
if [ -d "$BUILD_APP_PATH" ]; then
    RAZORPAY_FW="$BUILD_APP_PATH/Frameworks/Razorpay.framework"
    
    if [ -d "$RAZORPAY_FW" ]; then
        echo "📦 Found Razorpay.framework in build output"
        
        # Remove nested content
        if [ -d "$RAZORPAY_FW/Frameworks" ]; then
            echo "🗑️  Removing nested Frameworks..."
            rm -rf "$RAZORPAY_FW/Frameworks"
        fi
        
        rm -rf "$RAZORPAY_FW"/*.bundle 2>/dev/null || true
        rm -rf "$RAZORPAY_FW"/*.framework 2>/dev/null || true
        
        echo "✅ Razorpay.framework cleaned in build output"
    fi
fi

echo ""
echo "✅ Build completed successfully!"
echo ""
echo "📋 Next steps:"
echo "1. Open Xcode: open ios/Runner.xcworkspace"
echo "2. Select 'Any iOS Device (arm64)' as target"
echo "3. Product → Archive"
echo "4. After archive completes, run: ./ios/fix_razorpay_archive.sh"
echo "5. Then distribute the archive to App Store"

