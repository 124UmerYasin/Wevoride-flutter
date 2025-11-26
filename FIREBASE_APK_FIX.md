# Fix: Play Integrity & reCAPTCHA Error in Release APK

## Problem

When building a release APK, you get the error:
```
This request is missing a valid app identifier
Play Integrity checks and reCAPTCHA checks were unsuccessful
```

This happens because:
- `flutter run` uses the **debug keystore** (already registered in Firebase)
- Release APK uses the **release keystore** (SHA fingerprints not registered in Firebase)
- Firebase App Check with Play Integrity requires SHA-1 and SHA-256 fingerprints to be registered

## Solution

### Step 1: Get Release Keystore Fingerprints

Run the script to extract fingerprints:

```bash
cd android
./get-release-fingerprints.sh
```

Or manually run:
```bash
cd android
keytool -list -v -keystore app/my-release-key.keystore -alias my-key-alias -storepass "Umer@124" -keypass "Umer@124" | grep -E "(SHA1|SHA256)"
```

You should see:
- **SHA-1**: `0A:89:DC:4C:0C:B1:AF:ED:19:F0:21:60:93:F8:55:DC:45:0D:01:A7`
- **SHA-256**: `2A:4F:7C:18:C7:56:88:15:72:35:35:1D:D7:B0:3E:C7:7F:41:A1:8E:E3:EF:C2:B4:51:90:E4:97:AD:8A:67:F2`

### Step 2: Add Fingerprints to Firebase Console

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your project: **wevoride-21bb8**
3. Click the **gear icon** ⚙️ next to "Project Overview"
4. Select **Project settings**
5. Scroll down to **Your apps** section
6. Find your Android app (`com.wevoride`)
7. Click **Add fingerprint** button
8. Add both fingerprints:
   - **SHA-1**: `0A:89:DC:4C:0C:B1:AF:ED:19:F0:21:60:93:F8:55:DC:45:0D:01:A7`
   - **SHA-256**: `2A:4F:7C:18:C7:56:88:15:72:35:35:1D:D7:B0:3E:C7:7F:41:A1:8E:E3:EF:C2:B4:51:90:E4:97:AD:8A:67:F2`
9. Click **Save**
10. Download the updated `google-services.json` file
11. Replace `android/app/google-services.json` with the new file

### Step 3: Enable Play Integrity API

1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Select project: **wevoride-21bb8** (or the project linked to your Firebase project)
3. Navigate to **APIs & Services** > **Library**
4. Search for **Play Integrity API**
5. Click on **Play Integrity API**
6. Click **Enable** if not already enabled
7. Wait for the API to be enabled (usually takes a few seconds)

### Step 4: Verify Firebase App Check Configuration

Your app is already configured correctly in `lib/main.dart`:
```dart
await FirebaseAppCheck.instance.activate(
  androidProvider: AndroidProvider.playIntegrity,
  // ...
);
```

### Step 5: Rebuild the APK

After completing the above steps:

1. Clean the build:
   ```bash
   flutter clean
   ```

2. Build the release APK:
   ```bash
   flutter build apk --release
   ```

3. Or build an app bundle:
   ```bash
   flutter build appbundle --release
   ```

### Step 6: Test

Install the APK on a device and test OTP verification. It should work without the Play Integrity error.

## Why This Happens

- **Debug builds** (`flutter run`): Uses debug keystore located at `~/.android/debug.keystore`
- **Release builds** (`flutter build apk --release`): Uses your release keystore (`android/app/my-release-key.keystore`)
- Firebase App Check validates the app using SHA fingerprints
- Each keystore has unique SHA-1 and SHA-256 fingerprints
- Both must be registered in Firebase Console for the respective build types to work

## Additional Notes

1. **Keep your keystore safe**: If you lose the release keystore, you won't be able to update your app on Google Play Store.

2. **Debug keystore**: The debug keystore fingerprints are usually added automatically when you add Firebase to your project, which is why `flutter run` works.

3. **Google Play Console**: If you're uploading to Play Store, make sure the same keystore is used for signing.

## Troubleshooting

If you still get errors after following these steps:

1. **Wait a few minutes**: Firebase changes can take 5-10 minutes to propagate
2. **Verify fingerprints**: Double-check that fingerprints are exactly as shown (no extra spaces)
3. **Check API status**: Ensure Play Integrity API shows as "Enabled" in Google Cloud Console
4. **Check package name**: Ensure package name in Firebase matches `com.wevoride` exactly
5. **Clean rebuild**: Run `flutter clean` and rebuild
6. **Check google-services.json**: Verify the updated file is in `android/app/google-services.json`

## Quick Reference

- **SHA-1**: `0A:89:DC:4C:0C:B1:AF:ED:19:F0:21:60:93:F8:55:DC:45:0D:01:A7`
- **SHA-256**: `2A:4F:7C:18:C7:56:88:15:72:35:35:1D:D7:B0:3E:C7:7F:41:A1:8E:E3:EF:C2:B4:51:90:E4:97:AD:8A:67:F2`
- **Package Name**: `com.wevoride`
- **Firebase Project**: `wevoride-21bb8`

