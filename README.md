# Example App - Simple Android WebView Wrapper

A lightweight Android APK application that wraps and displays https://example.com/ in a WebView with no ads.

## Project Structure

```
App-maker/
├── app/
│   ├── src/
│   │   ├── main/
│   │   │   ├── AndroidManifest.xml       # App manifest with permissions
│   │   │   ├── java/com/example/myapp/
│   │   │   │   └── MainActivity.java     # Main activity with WebView & AdMob
│   │   │   └── res/
│   │   │       ├── layout/
│   │   │       │   └── activity_main.xml # UI layout
│   │   │       ├── values/
│   │   │       │   ├── strings.xml       # String resources
│   │   │       │   ├── colors.xml        # Color definitions
│   │   │       │   └── themes.xml        # Theme definitions
│   │   │       └── xml/
│   │   │           ├── network_security_config.xml
│   │   │           ├── backup_rules.xml
│   │   │           └── data_extraction_rules.xml
│   │   └── test/                         # Test directory
│   ├── build.gradle                      # App-level Gradle configuration
│   └── proguard-rules.pro                # ProGuard/R8 rules
├── gradle/
│   └── wrapper/
│       └── gradle-wrapper.properties      # Gradle wrapper configuration
├── build.gradle                          # Project-level Gradle configuration
├── settings.gradle                       # Gradle settings
├── gradle.properties                     # Gradle properties
├── gradlew                               # Gradle wrapper (Linux/Mac)
├── gradlew.bat                          # Gradle wrapper (Windows)
├── Dockerfile                            # Docker build configuration
├── .gitignore                            # Git ignore file
└── README.md                             # This file
```

## Specifications

- **Package Name**: com.example.myapp
- **App Name**: Example App
- **Minimum SDK**: 21 (Android 5.0)
- **Target SDK**: 34 (Android 14)
- **Java Version**: 11
- **Gradle Version**: 8.2+

## Features

✅ WebView component displaying https://example.com/
✅ JavaScript enabled for web functionality
✅ Back button navigation (returns to previous page in WebView)
✅ Internet and network state permissions
✅ Error handling and null checks
✅ ProGuard/R8 code obfuscation
✅ AndroidX support
✅ Network security configuration
✅ Backup and data extraction rules
✅ Minimal dependencies (no ads)

## Prerequisites

### For Local Building:
- Android Studios (optional)
- JDK 11+
- Gradle 8.2+
- Android SDK API 34
- 2GB+ RAM

### For Docker Building:
- Docker installed

## Setup

### Update Website URL (Optional)

To change the wrapped website, edit MainActivity.java:

```java
private static final String WEBSITE_URL = "https://example.com/";
```

## Build Instructions

### Option 1: Build Locally (Linux/Mac/Windows)

#### Prerequisites:
```bash
# Install Java 11
sudo apt-get install openjdk-11-jdk  # Ubuntu/Debian
brew install openjdk@11              # macOS

# Download Android SDK (if not using Android Studio)
# Or set ANDROID_SDK_ROOT environment variable
```

#### Build Debug APK:
```bash
chmod +x gradlew
./gradlew clean build
```

The APK will be generated at:
```
app/build/outputs/apk/debug/app-debug.apk
```

#### Build Release APK:
```bash
./gradlew clean assembleRelease
```

The APK will be generated at:
```
app/build/outputs/apk/release/app-release.apk
```

### Option 2: Build with Docker

```bash
# Build Docker image
docker build -t example-app-builder .

# Run container and build APK
docker run --rm -v $(pwd)/output:/output example-app-builder ./gradlew build

# APK will be in ./output/ directory
```

### Option 3: Build Release APK Signed

To create a release APK for Google Play Store:

```bash
# Create keystore (first time only)
keytool -genkey -v -keystore release.keystore -keyalg RSA -keysize 2048 -validity 10000 -alias example-app

# Build signed release APK
./gradlew clean assembleRelease -Pandroid.injected.signing.store.file=release.keystore \
  -Pandroid.injected.signing.store.password=YOUR_PASSWORD \
  -Pandroid.injected.signing.key.alias=example-app \
  -Pandroid.injected.signing.key.password=YOUR_PASSWORD
```

## Build Outputs

After successful build, APK files are located in:

### Debug Build:
```
app/build/outputs/apk/debug/app-debug.apk
```

### Release Build:
```
app/build/outputs/apk/release/app-release.apk
```

## Installation

### Install on Android Device/Emulator:

```bash
# Debug APK
adb install app/build/outputs/apk/debug/app-debug.apk

# Or with adb shell
./gradlew installDebug
```

## Key Configuration Files

### build.gradle
- Gradle plugins and repositories
- Android SDK configuration
- Dependency management
- Build types (debug/release)

### AndroidManifest.xml
- App permissions (INTERNET, ACCESS_NETWORK_STATE)
- Activity configuration
- App metadata

### MainActivity.java
- WebView initialization and configuration
- Back button navigation handling
- JavaScript settings
- Error handling

### activity_main.xml
- WebView layout
- AdMob banner ad container
- UI structure

## Permissions

The app requests the following permissions:
- `android.permission.INTERNET` - Required for WebView to load websites
- `android.permission.ACCESS_NETWORK_STATE` - For checking network connectivity

## Troubleshooting

### Build Fails with Gradle Error
```bash
# Clear Gradle cache
./gradlew clean

# Rebuild
./gradlew build
```

### WebView Not Loading Website
1. Ensure internet permission is granted in AndroidManifest.xml
2. Check network connectivity on device
3. Verify website URL is accessible
4. Check Logcat for WebView errors

### Java/Gradle Version Issues
```bash
# Check Java version
java -version

# Set JAVA_HOME manually
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
```

## Gradle Commands

```bash
# Clean build directory
./gradlew clean

# Build debug APK
./gradlew assembleDebug

# Build release APK
./gradlew assembleRelease

# Build and test
./gradlew build

# Install debug APK to connected device
./gradlew installDebug

# Run lint checks
./gradlew lint

# View dependencies
./gradlew dependencies

# Build with verbose output
./gradlew build --info
```

## Dependencies

The project includes the following main dependencies:
- **androidx.appcompat:appcompat:1.6.1** - AndroidX compatibility library
- **androidx.constraintlayout** - Layout library

## Code Quality

### ProGuard/R8 Configuration
- Located in proguard-rules.pro
- Enabled for release builds
- Obfuscates code while maintaining functionality
- Keeps necessary Android and Google Play Services classes

## Git Configuration

```bash
# Initialize git repository (if not already done)
git init
git add .
git commit -m "Initial commit: Android WebView wrapper app"

# Add remote repository (replace with your repo URL)
git remote add origin https://github.com/starcode111/App-maker.git

# Push to repository
git push -u origin main
```

## Version Information

- **App Version**: 1.0.0
- **Build Version**: 34
- **Gradle**: 8.2
- **Android Gradle Plugin**: 8.2.0
- **Target API**: 34
- **Min API**: 21

## Support

For issues or questions:
1. Check the troubleshooting section above
2. Review Android official documentation
3. Check Google Play Services documentation
4. Review logcat output for detailed error messages

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Notes

- Test on multiple Android versions
- Ensure website accessibility and performance
- Monitor app analytics through Google Play Console
- Regularly test app functionality

---

**Ready to build your APK!** 🚀

Start with: `./gradlew clean build`
