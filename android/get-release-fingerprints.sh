#!/bin/bash

# Script to extract SHA-1 and SHA-256 fingerprints from release keystore
# This is required for Firebase App Check and Play Integrity API

KEYSTORE_FILE="app/my-release-key.keystore"
KEY_ALIAS="my-key-alias"

# Check if key.properties exists and read values
if [ -f "key.properties" ]; then
    echo "Reading key.properties..."
    STORE_FILE=$(grep "^storeFile=" key.properties | cut -d'=' -f2)
    KEY_ALIAS=$(grep "^keyAlias=" key.properties | cut -d'=' -f2)
    STORE_PASSWORD=$(grep "^storePassword=" key.properties | cut -d'=' -f2)
    KEY_PASSWORD=$(grep "^keyPassword=" key.properties | cut -d'=' -f2)
    
    # Convert relative path to absolute if needed
    if [[ "$STORE_FILE" != /* ]]; then
        KEYSTORE_FILE="app/$STORE_FILE"
    else
        KEYSTORE_FILE="$STORE_FILE"
    fi
fi

# Check if keystore exists
if [ ! -f "$KEYSTORE_FILE" ]; then
    echo "Error: Keystore file not found at $KEYSTORE_FILE"
    exit 1
fi

echo "========================================="
echo "Extracting fingerprints from release keystore"
echo "========================================="
echo "Keystore: $KEYSTORE_FILE"
echo "Alias: $KEY_ALIAS"
echo ""

# Extract SHA-1 fingerprint
echo "SHA-1 Fingerprint:"
SHA1_FULL=$(keytool -list -v -keystore "$KEYSTORE_FILE" -alias "$KEY_ALIAS" -storepass "$STORE_PASSWORD" -keypass "$KEY_PASSWORD" 2>/dev/null | grep -E "^.*SHA1:" | sed 's/.*SHA1: *\([0-9A-F:]*\).*/\1/')

# Remove colons and display
SHA1_CLEAN=$(echo "$SHA1_FULL" | tr -d ' ' | tr -d ':')
echo "$SHA1_CLEAN"
echo ""
echo "SHA-1 (with colons):"
echo "$SHA1_FULL"
echo ""

# Extract SHA-256 fingerprint
echo "SHA-256 Fingerprint:"
SHA256_FULL=$(keytool -list -v -keystore "$KEYSTORE_FILE" -alias "$KEY_ALIAS" -storepass "$STORE_PASSWORD" -keypass "$KEY_PASSWORD" 2>/dev/null | grep -E "^.*SHA256:" | sed 's/.*SHA256: *\([0-9A-F:]*\).*/\1/')

# Remove colons and display
SHA256_CLEAN=$(echo "$SHA256_FULL" | tr -d ' ' | tr -d ':')
echo "$SHA256_CLEAN"
echo ""
echo "SHA-256 (with colons):"
echo "$SHA256_FULL"
echo ""

echo "========================================="
echo "Instructions:"
echo "========================================="
echo "1. Copy the SHA-1 and SHA-256 fingerprints above"
echo "2. Go to Firebase Console: https://console.firebase.google.com"
echo "3. Select your project: wevoride-21bb8"
echo "4. Go to Project Settings (gear icon) > Your apps"
echo "5. Find your Android app (com.wevoride)"
echo "6. Click 'Add fingerprint'"
echo "7. Add both SHA-1 and SHA-256 fingerprints"
echo "8. Download the updated google-services.json and replace the existing one"
echo ""
echo "9. Also enable Play Integrity API in Google Cloud Console:"
echo "   https://console.cloud.google.com/apis/library/playintegrity.googleapis.com"
echo "   Make sure you select the correct project: wevoride-21bb8"
echo "========================================="

