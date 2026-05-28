# Play Store Release Guide — lakasir POS

A step-by-step guide for building, signing, and publishing `lakasir POS` to the Google Play Store.

---

## Table of Contents

1. [Prerequisites](#1-prerequisites)
2. [App Signing](#2-app-signing)
3. [App Configuration](#3-app-configuration)
4. [Build the Release](#4-build-the-release)
5. [Store Listing Assets](#5-store-listing-assets)
6. [Google Play Console Setup](#6-google-play-console-setup)
7. [Upload and Release](#7-upload-and-release)
8. [Firebase & Backend](#8-firebase--backend)
9. [CI/CD Automation](#9-cicd-automation)
10. [Post-Release Monitoring](#10-post-release-monitoring)
11. [Quick Checklist](#11-quick-checklist)

---

## 1. Prerequisites

| Item | Details |
|------|---------|
| **Google Play Developer Account** | $25 one-time fee. Register at [play.google.com/console](https://play.google.com/console) |
| **App content ready** | App name, short description, full description, privacy policy URL |
| **Play Console verification** | New accounts require identity/address verification (allow 2–7 days) |
| **Java / Android SDK** | Installed via Flutter (`flutter doctor -v` to confirm) |
| **Keystore** | A `.jks` or `.keystore` file for signing the app |

Verify your environment:

```bash
flutter doctor -v
```

Expected output should show **Android toolchain** and **Android Studio** with green checkmarks.

---

## 2. App Signing

lakasir is already configured for signing via `key.properties`. You need to create the keystore if you haven't already.

### 2.1 Generate a Keystore

```bash
keytool -genkey -v \
  -keystore ~/lakasir-upload.keystore \
  -alias upload \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000
```

You will be prompted for:
- **Keystore password** — pick a strong password
- **Key alias password** — same as keystore (recommended) or different
- **First and last name** — organization or individual name
- **Organizational unit** — e.g. "Engineering"
- **Organization** — company name
- **City / State / Country** — your location

### 2.2 Create key.properties

Create `android/key.properties` (this file is in `.gitignore` and must never be committed):

```properties
storePassword=YOUR_KEYSTORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=upload
storeFile=/Users/YOUR_USER/lakasir-upload.keystore
```

> **⚠️ Security**
> - Never commit `key.properties` or the `.keystore` file. Both are already in `.gitignore`.
> - Store the keystore file in a secure, backed-up location. If lost, you cannot update the app on Play Store — Google Play signing can help mitigate this (see 2.3).

### 2.3 Google Play App Signing (Recommended)

Google Play App Signing lets Google manage your app signing key. Your keystore becomes the *upload key* only (used to authenticate each upload). If you lose your upload key, Google can reset it.

**Enable it in Play Console:**
1. Go to **Play Console → Your App → Setup → App Signing**
2. Choose **"Let Google manage and protect your app signing key"**
3. Upload your keystore when prompted during the first release (or use Play's PEPK tool)

With Play Signing enabled, you only need the upload key locally. The app signing key is owned by Google.

---

## 3. App Configuration

### 3.1 Versioning

Update `pubspec.yaml`:

```yaml
version: 0.0.21   # versionName (shown to users) + versionCode (derived from build-number)
```

- **versionName** (`X.Y.Z`) — user-facing version string
- **versionCode** — auto-derived from `flutter.versionCode` in `local.properties`, or defaults to `1`

To override versionCode manually, add to `android/local.properties`:

```properties
flutter.versionName=1.0.0
flutter.versionCode=2
```

> Every Play Store release must have a **higher versionCode** than the previous one.

### 3.2 Application ID

The Application ID is already set in `android/app/build.gradle`:

```gradle
applicationId "com.lakasir.com"
```

> This ID cannot be changed after the app is published. Make sure it's final.

### 3.3 Permissions

Current permissions in `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

Review if additional permissions are needed for your app's features:

| Feature | Permission Required |
|---------|-------------------|
| Camera (barcode scanner / photo) | `android.permission.CAMERA` |
| Bluetooth (thermal printer) | `android.permission.BLUETOOTH`, `BLUETOOTH_ADMIN`, `BLUETOOTH_CONNECT` (Android 12+) |
| Location | `android.permission.ACCESS_FINE_LOCATION` |
| Storage | `READ_EXTERNAL_STORAGE`, `WRITE_EXTERNAL_STORAGE` (Android < 13) |
| Notifications | `POST_NOTIFICATIONS` (Android 13+) |

> Add only what the app actually uses. Google Play reviews extra permissions closely and may reject if unjustified.

### 3.4 ProGuard / R8 (Code Shrinking & Obfuscation)

Enable in `android/app/build.gradle` inside the `release` build type:

```gradle
buildTypes {
    release {
        signingConfig signingConfigs.release
        minifyEnabled true    // Enable code shrinking
        shrinkResources true   // Remove unused resources
        proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
    }
}
```

Create `android/app/proguard-rules.pro` if you use libraries that need keep rules (Firebase, image_picker, etc.):

```proguard
# Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Firebase
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Image Picker
-keep class com.yalantis.ucrop.** { *; }
-keep interface com.yalantis.ucrop.** { *; }
```

### 3.5 Target API Level

Google Play requires apps to target a recent API level. Check your settings:

In `android/app/build.gradle`:

```gradle
targetSdkVersion flutter.targetSdkVersion   // Should be 34+
```

As of 2025, new apps must target **API 34+** (Android 14). Each year Google raises this requirement — check the [target API level requirements](https://developer.android.com/google/play/requirements/target-sdk).

### 3.6 App Label

The app label shown on the device is defined in `android/app/src/main/AndroidManifest.xml`:

```xml
android:label="lakasir POS"
```

---

## 4. Build the Release

### 4.1 Clean Build

```bash
flutter clean
flutter pub get
```

### 4.2 Build App Bundle (Recommended)

Google Play prefers Android App Bundles (`.aab`) over APKs. Bundles let Play generate optimized APKs per device, reducing download size.

```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

### 4.3 Build APK (for manual testing / sideloading)

```bash
flutter build apk --release --split-per-abi
```

Outputs (under `build/app/outputs/flutter-apk/`):
- `app-armeabi-v7a-release.apk`
- `app-arm64-v8a-release.apk`
- `app-x86_64-release.apk`

### 4.4 Verify the Build

Before uploading, install and test the release build on a real device:

```bash
# Install the APK directly
adb install build/app/outputs/flutter-apk/app-arm64-v8a-release.apk

# Or install all APKs from a directory
adb install-multiple build/app/outputs/flutter-apk/*.apk
```

Test these scenarios:
- Fresh install → sign in → product listing → POS transaction
- Bluetooth thermal printer connectivity
- Firebase push notifications
- PDF receipt generation
- Image uploads (product photos, profile)

### 4.5 Verify App Bundle Locally

```bash
# Install bundletool (one-time)
brew install bundletool

# Generate APKs from the AAB for a connected device
bundletool build-apks \
  --bundle=build/app/outputs/bundle/release/app-release.aab \
  --output=lakasir.apks \
  --ks=~/lakasir-upload.keystore \
  --ks-pass=pass:YOUR_KEYSTORE_PASSWORD \
  --ks-key-alias=upload \
  --key-pass=pass:YOUR_KEY_PASSWORD

# Install on connected device
bundletool install-apks --apks=lakasir.apks
```

---

## 5. Store Listing Assets

Your project already has `store-assets/` with a feature graphic and screenshot capture script.

### 5.1 Required Graphics

| Asset | Size | Format | Status |
|-------|------|--------|--------|
| **App icon** | 512×512 px | PNG | ✅ `assets/icons/lakasir.png` |
| **Feature graphic** | 1024×500 px | PNG/JPG | ✅ `store-assets/feature-graphic.png` |
| **Phone screenshots** | 1080×1920 px min (16:9) | PNG/JPG | ✅ capture script available |

### 5.2 Generate Feature Graphic

```bash
# Requires ImageMagick
brew install imagemagick
bash generate_feature_graphic.sh
```

### 5.3 Capture Screenshots

```bash
# Connect Android device/emulator, then run:
bash capture_screenshots.sh
```

Screenshots required: **minimum 2, recommended 6+**. For lakasir POS, capture:
1. Dashboard (menu grid)
2. POS / Cashier screen (cart + product list)
3. Product management (inventory)
4. Transaction history
5. Sales reports
6. Profile / Settings

### 5.4 Store Listing Text

Prepare these text assets for Play Console:

| Field | Max Length | Guidance |
|-------|------------|----------|
| **App name** | 30 chars | `lakasir POS` |
| **Short description** | 80 chars | "Point of Sale app for small businesses. Manage products, process sales, print receipts." |
| **Full description** | 4000 chars | Detailed feature list, supported devices, setup instructions |

**Full description template:**

```
lakasir POS is a point-of-sale application designed for small businesses, 
retail shops, and restaurants.

## Inventory Management
• Add, edit, and categorize products
• Track stock levels in real time
• Product images and pricing

## Point of Sale
• Fast checkout with cart system
• Barcode scanning support
• Discounts and tax calculations

## Receipt Printing
• Bluetooth thermal printer support
• PDF receipt generation
• Custom receipt templates

## Reports
• Daily and monthly sales reports
• Transaction history
• Export data for accounting

## Notifications
• Firebase push notifications
• Stock alerts

lakasir POS works with our backend service. Set up your lakasir 
server instance to get started.
```

### 5.5 Privacy Policy

If your app collects any user data, you need a privacy policy URL. Host it on your website or use a free service like [privacypolicies.com](https://www.privacypolicies.com).

---

## 6. Google Play Console Setup

### 6.1 Create the App

1. Go to [play.google.com/console](https://play.google.com/console)
2. Click **Create app**
3. Enter app name: `lakasir POS`
4. Select default language
5. Choose: App or Game → **App**
6. Select: Free or Paid → **Free**
7. Accept the Play Developer Program policies

### 6.2 Complete the Dashboard Checklist

Play Console shows a checklist you must complete before publishing:

**Store Listing**
- App name, short description, full description
- App icon, feature graphic, screenshots
- App category: **Business** (recommended)
- Tags (e.g., "POS", "retail", "inventory")

**App Content**
- **Content rating questionnaire** — fill truthfully based on app features
- **Target audience** — age groups; if it includes children, additional policies apply
- **Ads declaration** — does the app contain ads?
- **Data safety section** — disclose what user data you collect/transmit (see 6.3)

**Pricing & Distribution**
- Countries/regions where the app is available
- (Optional) Managed Google Play for enterprise if targeting business users

### 6.3 Data Safety Section

For lakasir, you need to declare:

| Data Type | Collected? | Purpose |
|-----------|-----------|---------|
| **Personal info** (name, email) | Yes | Account management |
| **Financial info** | No* | — |
| **Photos/videos** (product images) | Yes | App functionality |
| **Device ID** (FCM token) | Yes | App functionality (push notifications) |
| **App activity** | No* | — |

> *Unless your backend collects additional data. Match what your server actually stores.

---

## 7. Upload and Release

### 7.1 Upload the App Bundle

1. In Play Console, go to **Testing → Internal testing** (or **Production**)
2. Click **Create new release**
3. Upload `build/app/outputs/bundle/release/app-release.aab`
4. Add release notes (what's new in this version)
5. Click **Save**, then **Review release**

### 7.2 Release Tracks

Use this release strategy:

| Track | Purpose | Audience |
|-------|---------|----------|
| **Internal testing** | Fast iterations, early builds | Up to 100 testers (by email) |
| **Closed testing** | Alpha builds, real feedback | Select group of testers |
| **Open testing** | Beta testing, wide feedback | Public, limited slots |
| **Production** | Live to all users | Everyone |

**Recommended flow:**

```
Internal Testing → Closed Testing → Open Testing → Production
     (days)            (1-2 weeks)      (2-4 weeks)    (public launch)
```

> **Important:** New Play Console accounts must run **closed testing with 20+ testers for 14+ days** before production access is granted (as of late 2023). Plan for this.

### 7.3 Staged Rollout

For Production releases, use **staged rollout** to control risk:

1. Release to **5–20%** of users initially
2. Monitor crash rates and user feedback for 24–48 hours
3. Gradually increase to 50%, then 100%

---

## 8. Firebase & Backend

### 8.1 Firebase Configuration

Your `google-services.json` is already in `android/app/`. Verify it matches the correct Firebase project:

```bash
cat android/app/google-services.json | grep project_id
```

Make sure this Firebase project matches the one used for:
- FCM push notifications
- Analytics (if enabled)
- Crashlytics (recommended, see below)

### 8.2 Enable Firebase Crashlytics

Add to `pubspec.yaml`:

```yaml
dependencies:
  firebase_crashlytics: ^3.4.9
```

Initialize in `lib/main.dart`:

```dart
FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
PlatformDispatcher.instance.onError = (error, stack) {
  FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  return true;
};
```

### 8.3 Backend Considerations

- **API base URL**: Stored in `.env`. Make sure `--release` builds include the production API URL, not localhost.
- **Environment switching**: Use environment-specific `.env` files or Dart define flags.

Build with environment flags if needed:

```bash
flutter build appbundle --release --dart-define=API_URL=https://api.lakasir.com
```

---

## 9. CI/CD Automation

### 9.1 GitHub Actions Workflow

Create `.github/workflows/release-android.yml`:

```yaml
name: Android Release

on:
  push:
    tags:
      - 'v*'

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-java@v4
        with:
          java-version: '17'
          distribution: 'temurin'

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24'

      - name: Decode Keystore
        env:
          KEYSTORE_BASE64: ${{ secrets.KEYSTORE_BASE64 }}
        run: echo "$KEYSTORE_BASE64" | base64 -d > android/upload.keystore

      - name: Create key.properties
        run: |
          echo "storeFile=upload.keystore" > android/key.properties
          echo "storePassword=${{ secrets.KEYSTORE_PASSWORD }}" >> android/key.properties
          echo "keyPassword=${{ secrets.KEY_PASSWORD }}" >> android/key.properties
          echo "keyAlias=${{ secrets.KEY_ALIAS }}" >> android/key.properties

      - name: Build App Bundle
        run: flutter build appbundle --release

      - name: Upload to Play Console
        uses: r0adkll/upload-google-play@v1
        with:
          serviceAccountJsonPlainText: ${{ secrets.PLAY_SERVICE_ACCOUNT_JSON }}
          packageName: com.lakasir.com
          releaseFiles: build/app/outputs/bundle/release/app-release.aab
          track: internal
```

### 9.2 GitHub Secrets

Set these in **GitHub → Repo Settings → Secrets and variables → Actions**:

| Secret | Value |
|--------|-------|
| `KEYSTORE_BASE64` | `base64 -i ~/lakasir-upload.keystore` |
| `KEYSTORE_PASSWORD` | Keystore password |
| `KEY_PASSWORD` | Key password |
| `KEY_ALIAS` | `upload` |
| `PLAY_SERVICE_ACCOUNT_JSON` | JSON key from Google Cloud service account |

### 9.3 Fastlane (Alternative)

```bash
# Install Fastlane
gem install fastlane

# Initialize in android/
cd android && fastlane init
```

Configure `android/fastlane/Fastfile`:

```ruby
default_platform(:android)

platform :android do
  desc "Build and upload to internal testing track"
  lane :internal do
    gradle(
      task: "bundleRelease",
      properties: {
        "android.injected.signing.store.file" => ENV["KEYSTORE_FILE"],
        "android.injected.signing.store.password" => ENV["KEYSTORE_PASSWORD"],
        "android.injected.signing.key.alias" => ENV["KEY_ALIAS"],
        "android.injected.signing.key.password" => ENV["KEY_PASSWORD"],
      }
    )
    upload_to_play_store(
      track: "internal",
      aab: "../build/app/outputs/bundle/release/app-release.aab",
      release_status: "completed",
    )
  end
end
```

---

## 10. Post-Release Monitoring

### 10.1 Play Console

Monitor these regularly:

| Dashboard | What to Watch |
|-----------|---------------|
| **Android Vitals** | ANR rates, crash rates, startup time |
| **Ratings & Reviews** | Reply to reviews promptly |
| **Crashes & ANRs** | Investigate top crashes |
| **Statistics** | Installs, uninstalls, active devices |

### 10.2 Key Thresholds

| Metric | Bad Behavior Threshold | Good Behavior Threshold |
|--------|----------------------|------------------------|
| User-perceived crash rate | > 1.09% | < 0.47% |
| User-perceived ANR rate | > 0.47% | < 0.08% |
| App not responding | > 0.47% | < 0.08% |

Exceeding bad thresholds reduces discoverability on Play Store.

### 10.3 Firebase Crashlytics

Check [Firebase Console → Crashlytics](https://console.firebase.google.com/) for detailed crash reports with stack traces.

### 10.4 User Feedback

- Reply to all Play Store reviews within 24–48 hours
- Address bug reports with fixes in the next release
- Consider adding an in-app feedback form

---

## 11. Quick Checklist

### First Release

- [ ] Google Play Developer Account registered & verified
- [ ] Keystore created and securely backed up
- [ ] `android/key.properties` created (not committed)
- [ ] App ID (`com.lakasir.com`) is final
- [ ] `versionCode` set appropriately (start at `1` for first release)
- [ ] Target SDK ≥ 34
- [ ] Firebase `google-services.json` points to production project
- [ ] `.env` uses production API URL
- [ ] Privacy policy URL ready
- [ ] Store listing: icon, feature graphic, screenshots (all assets generated)
- [ ] Store listing: descriptions (short + full) written
- [ ] Content rating questionnaire filled
- [ ] Data safety section declared
- [ ] Release APK tested on real device
- [ ] App Bundle built and verified locally

### Every Release

- [ ] Increment `versionCode`
- [ ] Update `versionName` in `pubspec.yaml`
- [ ] Write release notes
- [ ] Build and test release APK on real device
- [ ] Upload `.aab` to Play Console
- [ ] Rollout through testing tracks → production
- [ ] Monitor Android Vitals for 48 hours post-release
- [ ] Check Crashlytics for new issues
- [ ] Tag the release in git: `git tag v1.0.0 && git push --tags`

### Common Commands Reference

```bash
# Clean and build
flutter clean && flutter pub get && flutter build appbundle --release

# Build APK for testing
flutter build apk --release --split-per-abi

# Install on device
adb install build/app/outputs/flutter-apk/app-arm64-v8a-release.apk

# Check keystore info
keytool -list -v -keystore ~/lakasir-upload.keystore -alias upload

# Tag a release
git tag v1.0.0
git push origin v1.0.0
```
