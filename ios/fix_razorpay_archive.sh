#!/bin/bash

# Script to fix Razorpay nested frameworks in an already-built archive
# Run this AFTER creating the archive but BEFORE uploading to App Store

echo "🔧 Fixing Razorpay nested frameworks in archive..."

# Find the most recent archive
ARCHIVES_PATH="$HOME/Library/Developer/Xcode/Archives"
LATEST_ARCHIVE=$(find "$ARCHIVES_PATH" -name "*.xcarchive" -type d -print0 | xargs -0 ls -t | head -n 1)

if [ -z "$LATEST_ARCHIVE" ]; then
    echo "❌ No archive found. Please create an archive first."
    exit 1
fi

echo "📦 Found archive: $LATEST_ARCHIVE"

# Path to the Razorpay framework in the archive
RAZORPAY_FRAMEWORK="$LATEST_ARCHIVE/Products/Applications/Runner.app/Frameworks/Razorpay.framework"

if [ ! -d "$RAZORPAY_FRAMEWORK" ]; then
    echo "❌ Razorpay.framework not found in archive"
    exit 1
fi

echo "📦 Found Razorpay.framework"

# Backup the archive first
BACKUP_PATH="${LATEST_ARCHIVE}.backup"
if [ ! -d "$BACKUP_PATH" ]; then
    echo "💾 Creating backup..."
    cp -R "$LATEST_ARCHIVE" "$BACKUP_PATH"
    echo "✅ Backup created at: $BACKUP_PATH"
fi

# Remove nested Frameworks directory
if [ -d "$RAZORPAY_FRAMEWORK/Frameworks" ]; then
    echo "🗑️  Removing nested Frameworks directory..."
    rm -rf "$RAZORPAY_FRAMEWORK/Frameworks"
    echo "✅ Removed nested Frameworks"
fi

# Remove nested bundles
BUNDLES_FOUND=false
for bundle in "$RAZORPAY_FRAMEWORK"/*.bundle; do
    if [ -e "$bundle" ]; then
        BUNDLES_FOUND=true
        echo "🗑️  Removing bundle: $(basename "$bundle")"
        rm -rf "$bundle"
    fi
done

if [ "$BUNDLES_FOUND" = true ]; then
    echo "✅ Removed nested bundles"
fi

# Remove any nested framework files
FRAMEWORKS_FOUND=false
for framework in "$RAZORPAY_FRAMEWORK"/*.framework; do
    if [ -e "$framework" ]; then
        FRAMEWORKS_FOUND=true
        echo "🗑️  Removing framework: $(basename "$framework")"
        rm -rf "$framework"
    fi
done

if [ "$FRAMEWORKS_FOUND" = true ]; then
    echo "✅ Removed nested frameworks"
fi

# List remaining contents to verify
echo ""
echo "📋 Remaining contents of Razorpay.framework:"
ls -la "$RAZORPAY_FRAMEWORK"

echo ""
echo "✅ Archive fixed successfully!"
echo "📦 Archive location: $LATEST_ARCHIVE"
echo ""
echo "Now you can:"
echo "1. Open Xcode → Window → Organizer"
echo "2. Select this archive"
echo "3. Click 'Distribute App'"
echo "4. Upload to App Store Connect"

