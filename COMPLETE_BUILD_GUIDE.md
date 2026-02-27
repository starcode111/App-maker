# 🚀 Complete Android WebView APK Build Guide

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Architecture Overview](#architecture-overview)
3. [Complete Step-by-Step Build Process](#step-by-step-process)
4. [All Bash Commands (Copy & Run)](#all-bash-commands)
5. [Configuration Files](#configuration-files)
6. [Customization Template](#customization-template)
7. [Troubleshooting](#troubleshooting)
8. [Example Websites for WebView](#example-websites)

---

## Prerequisites

### System Requirements
- Linux (Ubuntu 20.04+) or macOS
- 2GB RAM minimum, 4GB recommended
- 10GB free disk space
- Network connection (for downloading SDK)

### Required Software
```
✓ Java 11 (OpenJDK or Oracle)
✓ Gradle 9.0+
✓ Android SDK (will be downloaded)
✓ Git (for version control)
```

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    What We're Building                       │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  WebView APK = Web Browser inside Android App               │
│                                                              │
│  Components:                                                │
│  • MainActivity.java     → App logic & lifecycle            │
│  • activity_main.xml     → UI layout with WebView           │
│  • AndroidManifest.xml   → App configuration & permissions │
│  • build.gradle          → Dependencies & build settings    │
│  • gradle.properties     → Java & Gradle configuration      │
│                                                              │
│  Process:                                                    │
│  1. Write Java code                                         │
│  2. Create XML layouts & config                             │
│  3. Configure Gradle build files                            │
│  4. Install Android SDK                                     │
│  5. Gradle compiles everything                              │
│  6. DEX compiler converts to Android bytecode               │
│  7. APK packager creates final APK file                     │
│  8. Test on device or emulator                              │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Complete Step-by-Step Build Process

### PHASE 1: Environment Setup

#### Step 1A: Create Project Directory
```bash
mkdir -p ~/android-projects/MyWebApp
cd ~/android-projects/MyWebApp
```

#### Step 1B: Check Java Installation
```bash
java -version
# Expected: Java 11 or higher
# If not installed:
#   Ubuntu: sudo apt update && sudo apt install openjdk-11-jdk
#   macOS: brew install openjdk@11
```

#### Step 1C: Verify Gradle
```bash
gradle --version
# Expected: Gradle 9.0 or higher
# If not installed:
#   Ubuntu: sudo apt install gradle
#   macOS: brew install gradle
```

---

### PHASE 2: Android SDK Installation

#### Step 2A: Create SDK Directory
```bash
mkdir -p ~/android-sdk/cmdline-tools
cd ~/android-sdk/cmdline-tools
```

#### Step 2B: Download Android SDK Tools
```bash
# Download latest command-line tools (for Linux)
wget -q https://dl.google.com/android/repository/commandlinetools-linux-9862592_latest.zip

# For macOS, use:
# wget -q https://dl.google.com/android/repository/commandlinetools-mac-9862592_latest.zip
```

#### Step 2C: Extract and Organize
```bash
unzip -q commandlinetools-linux-9862592_latest.zip
mv cmdline-tools latest
rm commandlinetools-linux-9862592_latest.zip
```

#### Step 2D: Set Environment Variables
```bash
# Add to ~/.bashrc or ~/.zshrc
export ANDROID_SDK_ROOT=$HOME/android-sdk
export PATH=$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$PATH

# Apply immediately:
source ~/.bashrc
# or for zsh:
source ~/.zshrc
```

#### Step 2E: Accept SDK Licenses
```bash
yes | sdkmanager --licenses
```

#### Step 2F: Install Required SDK Components
```bash
sdkmanager "platforms;android-34" "platforms;android-21" \
           "build-tools;34.0.0" "platform-tools"
```

---

### PHASE 3: Project Structure Creation

#### Step 3A: Create Gradle Files
```bash
cd ~/android-projects/MyWebApp

# Create root build.gradle
cat > build.gradle << 'EOF'
plugins {
    id 'com.android.application' version '8.4.0' apply false
    id 'com.android.library' version '8.4.0' apply false
}

task clean(type: Delete) {
    delete rootProject.buildDir
}
EOF
```

#### Step 3B: Create settings.gradle
```bash
cat > settings.gradle << 'EOF'
pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}
dependencyResolution {
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.name = "MyWebApp"
include ':app'
EOF
```

#### Step 3C: Create gradle.properties
```bash
cat > gradle.properties << 'EOF'
org.gradle.jvmargs=-Xmx2048m -Dfile.encoding=UTF-8
org.gradle.daemon=true

android.useAndroidX=true
android.enableJetifier=true

# Point to your Java 11 installation
org.gradle.java.home=/usr/lib/jvm/java-11-openjdk-amd64

android.nonTransitiveRClass=true
EOF
```

#### Step 3D: Create local.properties
```bash
cat > local.properties << 'EOF'
sdk.dir=$HOME/android-sdk
EOF
```

#### Step 3E: Create Project Structure
```bash
mkdir -p app/src/main/{java/com/example/myapp,res/{layout,mipmap-mdpi,mipmap-hdpi,mipmap-xhdpi,mipmap-xxhdpi,mipmap-xxxhdpi,mipmap-anydpi-v33,values,xml}}
mkdir -p app/src/test/java
```

---

### PHASE 4: Create Application Files

#### Step 4A: Create app/build.gradle
```bash
cat > app/build.gradle << 'EOF'
plugins {
    id 'com.android.application'
}

android {
    namespace 'com.example.myapp'
    compileSdk 34

    defaultConfig {
        applicationId "com.example.myapp"
        minSdk 21
        targetSdk 34
        versionCode 1
        versionName "1.0.0"
        testInstrumentationRunner "androidx.test.runner.AndroidJUnitRunner"
    }

    buildTypes {
        release {
            minifyEnabled false
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
        debug {
            minifyEnabled false
        }
    }

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_11
        targetCompatibility JavaVersion.VERSION_11
    }

    buildFeatures {
        viewBinding false
    }

    lintOptions {
        checkReleaseBuilds false
    }
}

dependencies {
    implementation 'androidx.appcompat:appcompat:1.6.1'
    implementation 'androidx.constraintlayout:constraintlayout:2.1.4'
    testImplementation 'junit:junit:4.13.2'
    androidTestImplementation 'androidx.test.ext:junit:1.1.5'
    androidTestImplementation 'androidx.test.espresso:espresso-core:3.5.1'
}
EOF
```

#### Step 4B: Create app/proguard-rules.pro
```bash
cat > app/proguard-rules.pro << 'EOF'
-keep class com.example.myapp.** { *; }
-dontwarn android.webkit.**
-keep class android.webkit.** { *; }
EOF
```

#### Step 4C: Create AndroidManifest.xml
```bash
cat > app/src/main/AndroidManifest.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools">

    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />

    <application
        android:allowBackup="true"
        android:dataExtractionRules="@xml/data_extraction_rules"
        android:fullBackupContent="@xml/backup_rules"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.MyApp"
        android:usesCleartextTraffic="false"
        tools:targetApi="31">

        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:configChanges="orientation|screenSize|keyboardHidden"
            android:screenOrientation="portrait">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

    </application>

</manifest>
EOF
```

#### Step 4D: Create MainActivity.java
```bash
cat > app/src/main/java/com/example/myapp/MainActivity.java << 'EOF'
package com.example.myapp;

import android.annotation.SuppressLint;
import android.os.Bundle;
import android.view.KeyEvent;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

public class MainActivity extends AppCompatActivity {

    private WebView webView;
    private static final String WEBSITE_URL = "https://example.com/";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        initializeWebView();
    }

    @SuppressLint("SetJavaScriptEnabled")
    private void initializeWebView() {
        webView = findViewById(R.id.webView);

        if (webView != null) {
            configureWebViewSettings();

            webView.setWebViewClient(new WebViewClient() {
                @Override
                public boolean shouldOverrideUrlLoading(WebView view, String url) {
                    if (url != null && url.startsWith("http")) {
                        view.loadUrl(url);
                        return true;
                    }
                    return false;
                }

                @Override
                public void onPageFinished(WebView view, String url) {
                    super.onPageFinished(view, url);
                }

                @Override
                public void onReceivedError(WebView view, int errorCode, String description, String failingUrl) {
                    super.onReceivedError(view, errorCode, description, failingUrl);
                    Toast.makeText(MainActivity.this, "Error: " + description, Toast.LENGTH_SHORT).show();
                }
            });

            if (webView.getUrl() == null) {
                webView.loadUrl(WEBSITE_URL);
            }
        } else {
            Toast.makeText(this, "Error initializing WebView", Toast.LENGTH_SHORT).show();
        }
    }

    @SuppressLint("SetJavaScriptEnabled")
    private void configureWebViewSettings() {
        if (webView == null) return;

        try {
            webView.getSettings().setJavaScriptEnabled(true);
            webView.getSettings().setDomStorageEnabled(true);
            webView.getSettings().setDatabaseEnabled(true);
            webView.getSettings().setUserAgentString("Mozilla/5.0 (Linux; Android 12) AppleWebKit/537.36");
            
            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.LOLLIPOP) {
                webView.getSettings().setMixedContentMode(android.webkit.WebSettings.MIXED_CONTENT_ALWAYS_ALLOW);
            }
            
            webView.getSettings().setCacheMode(android.webkit.WebSettings.LOAD_DEFAULT);
            webView.getSettings().setBuiltInZoomControls(true);
            webView.getSettings().setDisplayZoomControls(false);
            webView.getSettings().setMediaPlaybackRequiresUserGesture(false);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public boolean onKeyDown(int keyCode, @NonNull KeyEvent event) {
        if ((keyCode == KeyEvent.KEYCODE_BACK) && webView != null) {
            if (webView.canGoBack()) {
                webView.goBack();
                return true;
            }
        }
        return super.onKeyDown(keyCode, event);
    }

    @Override
    protected void onDestroy() {
        if (webView != null) {
            webView.destroy();
            webView = null;
        }
        super.onDestroy();
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (webView != null) {
            webView.onResume();
        }
    }

    @Override
    protected void onPause() {
        if (webView != null) {
            webView.onPause();
        }
        super.onPause();
    }
}
EOF
```

#### Step 4E: Create activity_main.xml
```bash
cat > app/src/main/res/layout/activity_main.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="vertical"
    android:backgroundTint="@color/white"
    tools:context=".MainActivity">

    <WebView
        android:id="@+id/webView"
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:background="@color/white" />

</LinearLayout>
EOF
```

#### Step 4F: Create Resource Files
```bash
# colors.xml
cat > app/src/main/res/values/colors.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="white">#FFFFFF</color>
    <color name="black">#000000</color>
    <color name="primary">#2196F3</color>
</resources>
EOF

# strings.xml
cat > app/src/main/res/values/strings.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">My Web App</string>
</resources>
EOF

# themes.xml
cat > app/src/main/res/values/themes.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <style name="Theme.MyApp" parent="Theme.AppCompat.Light">
        <item name="colorPrimary">@color/primary</item>
        <item name="colorPrimaryDark">@color/primary</item>
        <item name="colorAccent">@color/primary</item>
    </style>
</resources>
EOF

# backup_rules.xml
cat > app/src/main/res/xml/backup_rules.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<full-backup-content>
</full-backup-content>
EOF

# data_extraction_rules.xml
cat > app/src/main/res/xml/data_extraction_rules.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<data-extraction-rules>
</data-extraction-rules>
EOF

# network_security_config.xml
cat > app/src/main/res/xml/network_security_config.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <domain-config cleartextTrafficPermitted="false">
        <domain includeSubdomains="true">example.com</domain>
    </domain-config>
</network-security-config>
EOF

# ic_launcher_background.xml
cat > app/src/main/res/values/ic_launcher_background.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="ic_launcher_bg">#2196F3</color>
</resources>
EOF

# ic_launcher.xml (adaptive icon)
cat > app/src/main/res/mipmap-anydpi-v33/ic_launcher.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@color/ic_launcher_bg"/>
    <foreground android:drawable="@mipmap/ic_launcher_foreground"/>
</adaptive-icon>
EOF
```

---

#### Step 4G: Create Launcher Icons
```bash
python3 << 'PYEOF'
import struct
import zlib
import os

def create_png(filepath, width=192, height=192, color=b"\x21\x96\xf3"):
    """Create solid color PNG"""
    png_sig = b"\x89PNG\r\n\x1a\n"
    
    # IHDR chunk
    ihdr_data = struct.pack(">IIBBBBB", width, height, 8, 2, 0, 0, 0)
    ihdr_crc = zlib.crc32(b"IHDR" + ihdr_data) & 0xffffffff
    ihdr = struct.pack(">I", 13) + b"IHDR" + ihdr_data + struct.pack(">I", ihdr_crc)
    
    # IDAT chunk
    scanline = b"\x00" + (color * width)
    idat_data = zlib.compress(scanline * height)
    idat_crc = zlib.crc32(b"IDAT" + idat_data) & 0xffffffff
    idat = struct.pack(">I", len(idat_data)) + b"IDAT" + idat_data + struct.pack(">I", idat_crc)
    
    # IEND chunk
    iend_crc = zlib.crc32(b"IEND") & 0xffffffff
    iend = struct.pack(">I", 0) + b"IEND" + struct.pack(">I", iend_crc)
    
    os.makedirs(os.path.dirname(filepath), exist_ok=True)
    with open(filepath, "wb") as f:
        f.write(png_sig + ihdr + idat + iend)

base = "app/src/main/res"
for density in ["mdpi", "hdpi", "xhdpi", "xxhdpi", "xxxhdpi"]:
    create_png(f"{base}/mipmap-{density}/ic_launcher.png")
    create_png(f"{base}/mipmap-{density}/ic_launcher_round.png")

print("✓ Icons created successfully")
PYEOF
```

---

### PHASE 5: Build APK

#### Step 5A: Navigate to Project
```bash
cd ~/android-projects/MyWebApp
```

#### Step 5B: Clean Previous Build
```bash
gradle clean
```

#### Step 5C: Build Debug APK
```bash
gradle assembleDebug
```

**Expected Output:**
```
...
> Task :app:assembleDebug
BUILD SUCCESSFUL in XX seconds
```

#### Step 5D: Verify APK
```bash
ls -lh app/build/outputs/apk/debug/
# Output: app-debug.apk (~3.4 MB)

file app/build/outputs/apk/debug/app-debug.apk
# Output: Android package (APK)
```

---

### PHASE 6: Save & Deploy

#### Step 6A: Create releases folder
```bash
mkdir -p releases
cp app/build/outputs/apk/debug/app-debug.apk releases/MyWebApp-debug.apk
```

#### Step 6B: Install on Device/Emulator
```bash
# Connect your Android device via USB with USB debugging enabled
adb install releases/MyWebApp-debug.apk

# Or use:
adb install -r releases/MyWebApp-debug.apk  # Force reinstall
```

#### Step 6C: Check Installation
```bash
adb shell pm list packages | grep myapp
# Output: package:com.example.myapp

# Launch app
adb shell am start -n com.example.myapp/.MainActivity
```

---

### PHASE 7: Version Control

#### Step 7A: Initialize Git
```bash
git init
git add .
git commit -m "Initial Android WebView app"
```

#### Step 7B: Push to Remote
```bash
git remote add origin https://github.com/YOUR_USERNAME/MyWebApp.git
git branch -M main
git push -u origin main
```

---

## All Bash Commands (Copy & Run)

Here's the complete sequence as one executable bash script:

```bash
#!/bin/bash
set -e  # Exit on any error

echo "🚀 Starting Android APK Build..."

# ==================== PHASE 1: Setup ====================
echo "📦 Phase 1: Setting up environment..."
mkdir -p ~/android-projects/MyWebApp
cd ~/android-projects/MyWebApp

# ==================== PHASE 2: SDK ====================
echo "📥 Phase 2: Installing Android SDK..."
mkdir -p ~/android-sdk/cmdline-tools
cd ~/android-sdk/cmdline-tools

# Download (already done if file exists)
if [ ! -f "latest/bin/sdkmanager" ]; then
    echo "Downloading SDK tools..."
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-9862592_latest.zip
    unzip -q commandlinetools-linux-9862592_latest.zip
    mv cmdline-tools latest
    rm commandlinetools-linux-9862592_latest.zip
fi

# Set environment
export ANDROID_SDK_ROOT=$HOME/android-sdk
export PATH=$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$PATH

# Accept licenses
yes | sdkmanager --licenses > /dev/null 2>&1

# Install components
echo "Installing SDK components (this takes 2-3 minutes)..."
sdkmanager "platforms;android-34" "platforms;android-21" "build-tools;34.0.0" "platform-tools" > /dev/null 2>&1

# ==================== PHASE 3: Project ====================
echo "🏗️  Phase 3: Creating project structure..."
cd ~/android-projects/MyWebApp

# Create directories
mkdir -p app/src/main/{java/com/example/myapp,res/{layout,mipmap-mdpi,mipmap-hdpi,mipmap-xhdpi,mipmap-xxhdpi,mipmap-xxxhdpi,mipmap-anydpi-v33,values,xml}}
mkdir -p app/src/test/java

# Create root build.gradle
cat > build.gradle << 'EOF'
plugins {
    id 'com.android.application' version '8.4.0' apply false
    id 'com.android.library' version '8.4.0' apply false
}

task clean(type: Delete) {
    delete rootProject.buildDir
}
EOF

# Create settings.gradle
cat > settings.gradle << 'EOF'
pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}
dependencyResolution {
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.name = "MyWebApp"
include ':app'
EOF

# Create gradle.properties
cat > gradle.properties << 'EOF'
org.gradle.jvmargs=-Xmx2048m -Dfile.encoding=UTF-8
org.gradle.daemon=true
android.useAndroidX=true
android.enableJetifier=true
org.gradle.java.home=/usr/lib/jvm/java-11-openjdk-amd64
android.nonTransitiveRClass=true
EOF

# Create local.properties
cat > local.properties << 'EOF'
sdk.dir=$HOME/android-sdk
EOF

# ==================== PHASE 4: App Files ====================
echo "📝 Phase 4: Creating application files..."

# app/build.gradle
cat > app/build.gradle << 'EOF'
plugins {
    id 'com.android.application'
}

android {
    namespace 'com.example.myapp'
    compileSdk 34

    defaultConfig {
        applicationId "com.example.myapp"
        minSdk 21
        targetSdk 34
        versionCode 1
        versionName "1.0.0"
        testInstrumentationRunner "androidx.test.runner.AndroidJUnitRunner"
    }

    buildTypes {
        release {
            minifyEnabled false
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
        debug {
            minifyEnabled false
        }
    }

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_11
        targetCompatibility JavaVersion.VERSION_11
    }

    buildFeatures {
        viewBinding false
    }

    lintOptions {
        checkReleaseBuilds false
    }
}

dependencies {
    implementation 'androidx.appcompat:appcompat:1.6.1'
    implementation 'androidx.constraintlayout:constraintlayout:2.1.4'
    testImplementation 'junit:junit:4.13.2'
    androidTestImplementation 'androidx.test.ext:junit:1.1.5'
    androidTestImplementation 'androidx.test.espresso:espresso-core:3.5.1'
}
EOF

# MainActivity.java
cat > app/src/main/java/com/example/myapp/MainActivity.java << 'EOF'
package com.example.myapp;

import android.annotation.SuppressLint;
import android.os.Bundle;
import android.view.KeyEvent;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

public class MainActivity extends AppCompatActivity {

    private WebView webView;
    private static final String WEBSITE_URL = "https://example.com/";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        initializeWebView();
    }

    @SuppressLint("SetJavaScriptEnabled")
    private void initializeWebView() {
        webView = findViewById(R.id.webView);

        if (webView != null) {
            configureWebViewSettings();

            webView.setWebViewClient(new WebViewClient() {
                @Override
                public boolean shouldOverrideUrlLoading(WebView view, String url) {
                    if (url != null && url.startsWith("http")) {
                        view.loadUrl(url);
                        return true;
                    }
                    return false;
                }

                @Override
                public void onReceivedError(WebView view, int errorCode, String description, String failingUrl) {
                    super.onReceivedError(view, errorCode, description, failingUrl);
                    Toast.makeText(MainActivity.this, "Error: " + description, Toast.LENGTH_SHORT).show();
                }
            });

            if (webView.getUrl() == null) {
                webView.loadUrl(WEBSITE_URL);
            }
        } else {
            Toast.makeText(this, "Error initializing WebView", Toast.LENGTH_SHORT).show();
        }
    }

    @SuppressLint("SetJavaScriptEnabled")
    private void configureWebViewSettings() {
        if (webView == null) return;

        try {
            webView.getSettings().setJavaScriptEnabled(true);
            webView.getSettings().setDomStorageEnabled(true);
            webView.getSettings().setDatabaseEnabled(true);
            webView.getSettings().setUserAgentString("Mozilla/5.0 (Linux; Android 12) AppleWebKit/537.36");
            
            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.LOLLIPOP) {
                webView.getSettings().setMixedContentMode(android.webkit.WebSettings.MIXED_CONTENT_ALWAYS_ALLOW);
            }
            
            webView.getSettings().setCacheMode(android.webkit.WebSettings.LOAD_DEFAULT);
            webView.getSettings().setBuiltInZoomControls(true);
            webView.getSettings().setDisplayZoomControls(false);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public boolean onKeyDown(int keyCode, @NonNull KeyEvent event) {
        if ((keyCode == KeyEvent.KEYCODE_BACK) && webView != null) {
            if (webView.canGoBack()) {
                webView.goBack();
                return true;
            }
        }
        return super.onKeyDown(keyCode, event);
    }

    @Override
    protected void onDestroy() {
        if (webView != null) {
            webView.destroy();
            webView = null;
        }
        super.onDestroy();
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (webView != null) {
            webView.onResume();
        }
    }

    @Override
    protected void onPause() {
        if (webView != null) {
            webView.onPause();
        }
        super.onPause();
    }
}
EOF

# AndroidManifest.xml
cat > app/src/main/AndroidManifest.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools">

    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />

    <application
        android:allowBackup="true"
        android:dataExtractionRules="@xml/data_extraction_rules"
        android:fullBackupContent="@xml/backup_rules"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.MyApp"
        android:usesCleartextTraffic="false"
        tools:targetApi="31">

        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:configChanges="orientation|screenSize|keyboardHidden"
            android:screenOrientation="portrait">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

    </application>

</manifest>
EOF

# activity_main.xml
cat > app/src/main/res/layout/activity_main.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="vertical"
    tools:context=".MainActivity">

    <WebView
        android:id="@+id/webView"
        android:layout_width="match_parent"
        android:layout_height="match_parent" />

</LinearLayout>
EOF

# Resource files
cat > app/src/main/res/values/colors.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="white">#FFFFFF</color>
    <color name="primary">#2196F3</color>
</resources>
EOF

cat > app/src/main/res/values/strings.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">My Web App</string>
</resources>
EOF

cat > app/src/main/res/values/themes.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <style name="Theme.MyApp" parent="Theme.AppCompat.Light">
        <item name="colorPrimary">@color/primary</item>
    </style>
</resources>
EOF

cat > app/src/main/res/xml/backup_rules.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<full-backup-content></full-backup-content>
EOF

cat > app/src/main/res/xml/data_extraction_rules.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<data-extraction-rules></data-extraction-rules>
EOF

cat > app/src/main/res/xml/network_security_config.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<network-security-config></network-security-config>
EOF

cat > app/proguard-rules.pro << 'EOF'
-keep class com.example.myapp.** { *; }
-dontwarn android.webkit.**
EOF

# ==================== PHASE 5: Icons ====================
echo "🎨 Phase 5: Creating launcher icons..."

python3 << 'PYEOF'
import struct, zlib, os

def create_png(filepath, width=192, height=192):
    png_sig = b"\x89PNG\r\n\x1a\n"
    ihdr_data = struct.pack(">IIBBBBB", width, height, 8, 2, 0, 0, 0)
    ihdr_crc = zlib.crc32(b"IHDR" + ihdr_data) & 0xffffffff
    ihdr = struct.pack(">I", 13) + b"IHDR" + ihdr_data + struct.pack(">I", ihdr_crc)
    
    color = b"\x21\x96\xf3"  # Blue
    scanline = b"\x00" + (color * width)
    idat_data = zlib.compress(scanline * height)
    idat_crc = zlib.crc32(b"IDAT" + idat_data) & 0xffffffff
    idat = struct.pack(">I", len(idat_data)) + b"IDAT" + idat_data + struct.pack(">I", idat_crc)
    
    iend_crc = zlib.crc32(b"IEND") & 0xffffffff
    iend = struct.pack(">I", 0) + b"IEND" + struct.pack(">I", iend_crc)
    
    os.makedirs(os.path.dirname(filepath), exist_ok=True)
    with open(filepath, "wb") as f:
        f.write(png_sig + ihdr + idat + iend)

base = "app/src/main/res"
for density in ["mdpi", "hdpi", "xhdpi", "xxhdpi", "xxxhdpi"]:
    create_png(f"{base}/mipmap-{density}/ic_launcher.png")
    create_png(f"{base}/mipmap-{density}/ic_launcher_round.png")

PYEOF

cat > app/src/main/res/mipmap-anydpi-v33/ic_launcher.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:color="#2196F3"/>
</adaptive-icon>
EOF

# ==================== PHASE 6: Build ====================
echo "🔨 Phase 6: Building APK..."
gradle clean assembleDebug

# ==================== PHASE 7: Save ====================
echo "💾 Phase 7: Saving APK..."
mkdir -p releases
cp app/build/outputs/apk/debug/app-debug.apk releases/MyWebApp-debug.apk

# ==================== PHASE 8: Verify ====================
echo "✅ Phase 8: Verifying..."
echo "APK Details:"
ls -lh releases/MyWebApp-debug.apk
file releases/MyWebApp-debug.apk

echo ""
echo "✨ BUILD COMPLETE!"
echo "📱 APK Location: $(pwd)/releases/MyWebApp-debug.apk"
echo ""
echo "To install:"
echo "  adb install releases/MyWebApp-debug.apk"
echo ""
```

---

## Configuration Files

### Complete Project Tree
```
MyWebApp/
├── build.gradle
├── settings.gradle
├── gradle.properties
├── local.properties
├── app/
│   ├── build.gradle
│   ├── proguard-rules.pro
│   └── src/main/
│       ├── AndroidManifest.xml
│       ├── java/com/example/myapp/
│       │   └── MainActivity.java
│       └── res/
│           ├── layout/activity_main.xml
│           ├── mipmap-*/ic_launcher.png
│           ├── values/
│           │   ├── colors.xml
│           │   ├── strings.xml
│           │   ├── themes.xml
│           │   └── ic_launcher_background.xml
│           └── xml/
│               ├── backup_rules.xml
│               ├── data_extraction_rules.xml
│               └── network_security_config.xml
└── releases/
    └── MyWebApp-debug.apk
```

---

## Customization Template

### Change Website URL
Edit `MainActivity.java`, line ~24:

```java
private static final String WEBSITE_URL = "https://YOUR_WEBSITE.com/";
```

### Change App Name
Edit `strings.xml`:
```xml
<string name="app_name">My Custom App Name</string>
```

Edit `AndroidManifest.xml`:
```xml
android:label="@string/app_name"
```

### Change Package Name
1. Edit `AndroidManifest.xml`:
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    android:package="your.new.package">
```

2. Edit `app/build.gradle`:
```gradle
android {
    namespace 'your.new.package'
    
    defaultConfig {
        applicationId "your.new.package"
```

3. Rename folder:
```bash
mv app/src/main/java/com/example/myapp app/src/main/java/your/new/package
```

4. Update Java file package line:
```java
package your.new.package;
```

### Change App Icon Color
Edit Python icon creation (change `\x21\x96\xf3` to desired hex color):

```python
# Red: \xff\x00\x00
# Green: \x00\xff\x00
# Blue: \x00\x00\xff
# Purple: \x80\x00\x80
color = b"\x80\x00\x80"  # Purple
```

### Change Min/Target SDK
Edit `app/build.gradle`:
```gradle
android {
    compileSdk 34      # Latest Android version
    
    defaultConfig {
        minSdk 21      # Oldest supported Android
        targetSdk 34   # Latest tested Android
```

---

## Troubleshooting

### "SDK location not found"
**Solution:**
```bash
echo "sdk.dir=$HOME/android-sdk" > local.properties
# or
export ANDROID_SDK_ROOT=$HOME/android-sdk
```

### "Cannot find sdkmanager"
**Solution:**
```bash
export PATH=$HOME/android-sdk/cmdline-tools/latest/bin:$PATH
which sdkmanager  # Should show path
```

### "Java 11 not found"
**Solution:**
```bash
# Ubuntu
sudo apt install openjdk-11-jdk

# macOS
brew install openjdk@11

# Verify
java -version
```

### "Gradle daemon timeout"
**Solution:**
```bash
gradle --stop
gradle clean assembleDebug
```

### "WebView not inflating"
**Check:**
1. activity_main.xml has `<WebView>` element
2. MainActivity.java has `findViewById(R.id.webView)`
3. Resources compiled correctly: `gradle clean`

### "Build fails with resource errors"
**Solution:**
```bash
rm -rf app/build .gradle
gradle clean assembleDebug
```

### "APK won't install"
**Solution:**
```bash
# Clear previous installation
adb uninstall com.example.myapp

# Install with reinstall flag
adb install -r releases/MyWebApp-debug.apk
```

---

## Example Websites for WebView

### Production-Ready Examples
Replace `https://example.com/` with:

#### E-Commerce
```java
private static final String WEBSITE_URL = "https://www.amazon.com/";
private static final String WEBSITE_URL = "https://www.aliexpress.com/";
private static final String WEBSITE_URL = "https://www.etsy.com/";
```

#### News & Content
```java
private static final String WEBSITE_URL = "https://www.bbc.com/";
private static final String WEBSITE_URL = "https://www.cnn.com/";
private static final String WEBSITE_URL = "https://news.ycombinator.com/";
```

#### Social Media
```java
private static final String WEBSITE_URL = "https://www.reddit.com/";
private static final String WEBSITE_URL = "https://www.instagram.com/";
private static final String WEBSITE_URL = "https://www.twitter.com/";
```

#### Streaming Services
```java
private static final String WEBSITE_URL = "https://www.youtube.com/";
private static final String WEBSITE_URL = "https://www.netflix.com/";
private static final String WEBSITE_URL = "https://www.spotify.com/";
```

#### Development Tools
```java
private static final String WEBSITE_URL = "https://github.com/";
private static final String WEBSITE_URL = "https://stackoverflow.com/";
private static final String WEBSITE_URL = "https://www.codepen.io/";
```

#### Your Own Website
```java
private static final String WEBSITE_URL = "https://yourdomain.com/";
private static final String WEBSITE_URL = "https://app.yourdomain.com/";  // Web app
```

### Mobile-Optimized Testing Domains
```java
// Google's test sites
private static final String WEBSITE_URL = "https://www.google.com/";

// MDN Web Docs (responsive)
private static final String WEBSITE_URL = "https://developer.mozilla.org/";

// Wikipedia (lightweight)
private static final String WEBSITE_URL = "https://www.wikipedia.org/";

// Local testing (if hosting locally)
private static final String WEBSITE_URL = "http://192.168.1.100:8000/";
```

---

## Quick Reference Card

```
┌──────────────────────────────────────────────────────────────┐
│              ANDROID APK BUILD QUICK REFERENCE               │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  VERSION INFO                                                │
│  ├─ Java:                   Java 11                          │
│  ├─ Gradle:                 9.2.1                            │
│  ├─ Android Gradle Plugin:  8.4.0                            │
│  └─ Target SDK:             Android 14 (API 34)              │
│                                                              │
│  7 MAIN METHODS                                              │
│  ├─ onCreate()              - Initialize app                 │
│  ├─ initializeWebView()     - Setup WebView                  │
│  ├─ configureWebViewSettings() - Enable features            │
│  ├─ onKeyDown()             - Back button handling           │
│  ├─ onResume()              - Resume WebView                 │
│  ├─ onPause()               - Pause WebView                  │
│  └─ onDestroy()             - Cleanup resources              │
│                                                              │
│  WEBVIEW FEATURES ENABLED                                    │
│  ├─ JavaScript              ✓ Enabled                        │
│  ├─ DOM Storage             ✓ Enabled                        │
│  ├─ Database                ✓ Enabled                        │
│  ├─ Caching                 ✓ Enabled                        │
│  ├─ Zoom Controls           ✓ Enabled                        │
│  ├─ Media Playback          ✓ Enabled             │
│  └─ Mixed Content           ✓ Allowed (HTTP+HTTPS)           │
│                                                              │
│  BUILD COMMAND                                               │
│  gradle clean assembleDebug                                 │
│                                                              │
│  OUTPUT                                                      │
│  app/build/outputs/apk/debug/app-debug.apk (~3.4 MB)        │
│                                                              │
│  INSTALL                                                     │
│  adb install releases/MyWebApp-debug.apk                     │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

---

## Summary

✅ **This guide provides:**
- Complete project setup from zero
- All configuration files
- All source code
- Copy-paste bash commands
- Step-by-step instructions
- Troubleshooting solutions
- Website customization examples
- Icon generation automation

✅ **You can now:**
- Build Android APKs from command line
- Wrap any website in a native app
- Customize app name, icon, package
- Install on real devices
- Deploy to Google Play Store (after signing)

**Total build time:** ~5-10 minutes (first time), ~1-2 minutes (subsequent)

---

Generated: February 27, 2026
Version: 1.0
