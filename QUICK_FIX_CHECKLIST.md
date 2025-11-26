# Quick Fix Checklist - APK Build Issue

## ✅ MUST DO Before Building Release APK

### Step 1: Add Release Keystore Fingerprints to Firebase (5 minutes)

1. Open: https://console.firebase.google.com/project/wevoride-21bb8/settings/general/android:com.wevoride
2. Scroll to "SHA certificate fingerprints" section
3. Click "Add fingerprint"
4. Add these two fingerprints:

   **SHA-1:**
   ```
   0A:89:DC:4C:0C:B1:AF:ED:19:F0:21:60:93:F8:55:DC:45:0D:01:A7
   ```

   **SHA-256:**
   ```
   2A:4F:7C:18:C7:56:88:15:72:35:35:1D:D7:B0:3E:C7:7F:41:A1:8E:E3:EF:C2:B4:51:90:E4:97:AD:8A:67:F2
   ```

5. Click "Save"
6. **Download** the updated `google-services.json` file
7. **Replace** `android/app/google-services.json` with the downloaded file

### Step 2: Enable Play Integrity API (2 minutes)

1. Open: https://console.cloud.google.com/apis/library/playintegrity.googleapis.com?project=wevoride-21bb8
2. Click **"Enable"** button (if not already enabled)
3. Wait for confirmation

### Step 3: Wait & Rebuild (10 minutes total)

1. **Wait 5-10 minutes** for Firebase changes to propagate
2. Clean build:
   ```bash
   flutter clean
   ```
3. Build APK:
   ```bash
   flutter build apk --release
   ```

---

## ❌ What Happens If You Skip This?

- ✅ `flutter run` → **Works** (debug keystore registered)
- ❌ `flutter build apk --release` → **Fails** with error:
  ```
  This request is missing a valid app identifier
  Play Integrity checks and reCAPTCHA checks were unsuccessful
  ```

---

## 🔍 Quick Test

After completing the steps above, test OTP verification in the release APK. It should work!

---

## 📝 Current Status

- **Debug keystore**: ✅ Registered (that's why `flutter run` works)
- **Release keystore**: ❌ NOT registered (that's why APK fails)

