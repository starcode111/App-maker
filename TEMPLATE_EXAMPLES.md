# 📱 Android WebView APK - Template Examples

## Quick Start: Copy & Run One-Liner

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/starcode111/App-maker/main/quick-build.sh)"
```

---

## 🎯 Example 1: YouTube App Wrapper

Perfect for: Music/Video streaming

### Step 1: Modified MainActivity.java
```java
package com.example.youtubeapp;

import android.annotation.SuppressLint;
import android.os.Bundle;
import android.view.KeyEvent;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

public class MainActivity extends AppCompatActivity {

    private WebView webView;
    private static final String WEBSITE_URL = "https://www.youtube.com/";

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
            });

            if (webView.getUrl() == null) {
                webView.loadUrl(WEBSITE_URL);
            }
        }
    }

    @SuppressLint("SetJavaScriptEnabled")
    private void configureWebViewSettings() {
        if (webView == null) return;

        try {
            // Enable all features for video streaming
            webView.getSettings().setJavaScriptEnabled(true);
            webView.getSettings().setDomStorageEnabled(true);
            webView.getSettings().setDatabaseEnabled(true);
            webView.getSettings().setMediaPlaybackRequiresUserGesture(false);
            webView.getSettings().setMixedContentMode(android.webkit.WebSettings.MIXED_CONTENT_ALWAYS_ALLOW);
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
}
```

### Step 2: Modification in build.gradle
```gradle
android {
    defaultConfig {
        applicationId "com.example.youtubeapp"
        minSdk 21
        targetSdk 34
    }
}
```

### Step 3: strings.xml
```xml
<string name="app_name">YouTube App</string>
```

### Step 4: Build
```bash
cd ~/android-projects/YouTubeApp
gradle clean assembleDebug
adb install app/build/outputs/apk/debug/app-debug.apk
```

---

## 🎯 Example 2: E-Commerce App (AliExpress)

Perfect for: Shopping app

### Configuration Changes
```java
// MainActivity.java
private static final String WEBSITE_URL = "https://www.aliexpress.com/";

// Enable extra features for shopping
webView.getSettings().setJavaScriptEnabled(true);
webView.getSettings().setDomStorageEnabled(true);
webView.getSettings().setGeolocationEnabled(true);  // Location for shipping
```

### build.gradle
```gradle
defaultConfig {
    applicationId "com.example.aliapp"
}
```

### AndroidManifest.xml - Add Permissions
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.CAMERA" />
```

---

## 🎯 Example 3: News Reader App (BBC)

Perfect for: News/Content consumption

### MainActivity.java
```java
private static final String WEBSITE_URL = "https://www.bbc.com/";

// Optimize for reading
webView.getSettings().setDefaultFontSize(16);  // Larger text
webView.getSettings().setMinimumFontSize(12);
```

### build.gradle
```gradle
defaultConfig {
    applicationId "com.example.newsapp"
    versionName "1.0.0"
}
```

### strings.xml
```xml
<string name="app_name">BBC News</string>
```

---

## 🎯 Example 4: Weather App

Perfect for: Simple utility wrapper

### MainActivity.java
```java
private static final String WEBSITE_URL = "https://weather.com/";

// Enable geolocation for weather
webView.getSettings().setGeolocationEnabled(true);
```

### AndroidManifest.xml
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

---

## 🎯 Example 5: Personal Blog/Portfolio

Perfect for: Showcase your work

### MainActivity.java
```java
private static final String WEBSITE_URL = "https://yourname.com/";
```

### build.gradle
```gradle
defaultConfig {
    applicationId "com.yourname.portfolio"
    versionName "1.0"
}
```

### strings.xml
```xml
<string name="app_name">Your Name</string>
```

---

## 🎯 Example 6: Document Editor (Google Docs Wrapper)

Perfect for: Productivity

### MainActivity.java
```java
private static final String WEBSITE_URL = "https://docs.google.com/";

webView.getSettings().setJavaScriptEnabled(true);
webView.getSettings().setDomStorageEnabled(true);
webView.getSettings().setDatabaseEnabled(true);

// Allow full screen for editing
webView.getSettings().setMediaPlaybackRequiresUserGesture(false);
```

### AndroidManifest.xml
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.MICROPHONE" />
```

---

## ⚡ Automated Template Script

Save as `create_webview_app.sh`:

```bash
#!/bin/bash

# Usage: ./create_webview_app.sh "app-name" "https://website.com" "com.example.app"

APP_NAME="${1:-MyWebApp}"
WEBSITE_URL="${2:-https://example.com/}"
PACKAGE_NAME="${3:-com.example.myapp}"

# Convert package to path
PACKAGE_PATH=$(echo $PACKAGE_NAME | sed 's/\./\//g')

echo "🚀 Creating: $APP_NAME"
echo "📱 Package: $PACKAGE_NAME"
echo "🌐 Website: $WEBSITE_URL"

# Create directories
mkdir -p "$APP_NAME/app/src/main/java/$PACKAGE_PATH"
mkdir -p "$APP_NAME/app/src/main/res/layout"
mkdir -p "$APP_NAME/app/src/main/res/values"
mkdir -p "$APP_NAME/app/src/main/res/xml"
for density in mdpi hdpi xhdpi xxhdpi xxxhdpi; do
    mkdir -p "$APP_NAME/app/src/main/res/mipmap-$density"
done

cd "$APP_NAME"

# Create build.gradle (root)
cat > build.gradle << 'EOF'
plugins {
    id 'com.android.application' version '8.4.0' apply false
    id 'com.android.library' version '8.4.0' apply false
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
rootProject.name = "APPNAME"
include ':app'
EOF

sed -i "s/APPNAME/$APP_NAME/g" settings.gradle

# Create gradle.properties
cat > gradle.properties << 'EOF'
org.gradle.jvmargs=-Xmx2048m -Dfile.encoding=UTF-8
org.gradle.daemon=true
android.useAndroidX=true
android.enableJetifier=true
android.nonTransitiveRClass=true
EOF

# Create local.properties
echo "sdk.dir=$HOME/android-sdk" > local.properties

# Create app/build.gradle
cat > app/build.gradle << 'EOF'
plugins {
    id 'com.android.application'
}

android {
    namespace 'PACKAGE'
    compileSdk 34

    defaultConfig {
        applicationId "PACKAGE"
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
    }

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_11
        targetCompatibility JavaVersion.VERSION_11
    }

    lintOptions {
        checkReleaseBuilds false
    }
}

dependencies {
    implementation 'androidx.appcompat:appcompat:1.6.1'
    implementation 'androidx.constraintlayout:constraintlayout:2.1.4'
    testImplementation 'junit:junit:4.13.2'
}
EOF

sed -i "s/PACKAGE/$PACKAGE_NAME/g" app/build.gradle

# Create MainActivity.java
cat > "app/src/main/java/$PACKAGE_PATH/MainActivity.java" << 'EOF'
package PACKAGE;

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
    private static final String WEBSITE_URL = "WEBSITE";

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
                    Toast.makeText(MainActivity.this, "Error: " + description, Toast.LENGTH_SHORT).show();
                }
            });

            webView.loadUrl(WEBSITE_URL);
        }
    }

    @SuppressLint("SetJavaScriptEnabled")
    private void configureWebViewSettings() {
        if (webView == null) return;

        try {
            webView.getSettings().setJavaScriptEnabled(true);
            webView.getSettings().setDomStorageEnabled(true);
            webView.getSettings().setDatabaseEnabled(true);
            webView.getSettings().setBuiltInZoomControls(true);
            webView.getSettings().setDisplayZoomControls(false);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public boolean onKeyDown(int keyCode, @NonNull KeyEvent event) {
        if ((keyCode == KeyEvent.KEYCODE_BACK) && webView != null && webView.canGoBack()) {
            webView.goBack();
            return true;
        }
        return super.onKeyDown(keyCode, event);
    }

    @Override
    protected void onDestroy() {
        if (webView != null) {
            webView.destroy();
        }
        super.onDestroy();
    }
}
EOF

sed -i "s|PACKAGE|$PACKAGE_NAME|g; s|WEBSITE|$WEBSITE_URL|g" "app/src/main/java/$PACKAGE_PATH/MainActivity.java"

# Create AndroidManifest.xml
cat > app/src/main/AndroidManifest.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools">

    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.MyApp"
        android:usesCleartextTraffic="false"
        tools:targetApi="31">

        <activity
            android:name="PACKAGE_PATH.MainActivity"
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

sed -i "s|PACKAGE_PATH|$PACKAGE_NAME|g" app/src/main/AndroidManifest.xml

# Create layout
cat > app/src/main/res/layout/activity_main.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="vertical">

    <WebView
        android:id="@+id/webView"
        android:layout_width="match_parent"
        android:layout_height="match_parent" />

</LinearLayout>
EOF

# Create resources
echo '<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="white">#FFFFFF</color>
    <color name="primary">#2196F3</color>
</resources>' > app/src/main/res/values/colors.xml

echo '<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">'$APP_NAME'</string>
</resources>' > app/src/main/res/values/strings.xml

echo '<?xml version="1.0" encoding="utf-8"?>
<resources>
    <style name="Theme.MyApp" parent="Theme.AppCompat.Light">
        <item name="colorPrimary">@color/primary</item>
    </style>
</resources>' > app/src/main/res/values/themes.xml

echo '<?xml version="1.0" encoding="utf-8"?>
<full-backup-content></full-backup-content>' > app/src/main/res/xml/backup_rules.xml

echo '<?xml version="1.0" encoding="utf-8"?>
<data-extraction-rules></data-extraction-rules>' > app/src/main/res/xml/data_extraction_rules.xml

echo '-keep class '$PACKAGE_NAME'.** { *; }
-dontwarn android.webkit.**' > app/proguard-rules.pro

# Create icons
python3 << 'PYEOF'
import struct, zlib, os, sys

def create_png(filepath):
    png_sig = b"\x89PNG\r\n\x1a\n"
    ihdr_data = struct.pack(">IIBBBBB", 192, 192, 8, 2, 0, 0, 0)
    ihdr_crc = zlib.crc32(b"IHDR" + ihdr_data) & 0xffffffff
    ihdr = struct.pack(">I", 13) + b"IHDR" + ihdr_data + struct.pack(">I", ihdr_crc)
    
    scanline = b"\x00" + (b"\x21\x96\xf3" * 192)
    idat_data = zlib.compress(scanline * 192)
    idat_crc = zlib.crc32(b"IDAT" + idat_data) & 0xffffffff
    idat = struct.pack(">I", len(idat_data)) + b"IDAT" + idat_data + struct.pack(">I", idat_crc)
    
    iend_crc = zlib.crc32(b"IEND") & 0xffffffff
    iend = struct.pack(">I", 0) + b"IEND" + struct.pack(">I", iend_crc)
    
    os.makedirs(os.path.dirname(filepath), exist_ok=True)
    with open(filepath, "wb") as f:
        f.write(png_sig + ihdr + idat + iend)

for density in ["mdpi", "hdpi", "xhdpi", "xxhdpi", "xxxhdpi"]:
    create_png(f"app/src/main/res/mipmap-{density}/ic_launcher.png")
    create_png(f"app/src/main/res/mipmap-{density}/ic_launcher_round.png")

PYEOF

# Build
echo "✅ Project created: $APP_NAME"
echo "🔨 Building APK..."
gradle clean assembleDebug 2>&1 | tail -20

if [ -f "app/build/outputs/apk/debug/app-debug.apk" ]; then
    mkdir -p releases
    cp app/build/outputs/apk/debug/app-debug.apk releases/$APP_NAME-debug.apk
    echo "✨ APK built successfully!"
    echo "📍 Location: $(pwd)/releases/$APP_NAME-debug.apk"
    ls -lh releases/$APP_NAME-debug.apk
else
    echo "❌ Build failed"
    exit 1
fi
```

### Usage:
```bash
chmod +x create_webview_app.sh

# Create YouTube app
./create_webview_app.sh "YouTubeApp" "https://youtube.com" "com.example.youtubeapp"

# Create News app  
./create_webview_app.sh "NewsApp" "https://bbc.com" "com.example.newsapp"

# Create Portfolio
./create_webview_app.sh "MyPortfolio" "https://yoursite.com" "com.yourname.portfolio"
```

---

## 🔥 All-in-One Build Command

```bash
#!/bin/bash
# Full build from scratch with all dependencies

set -e

APP_NAME="${1:-MyWebApp}"
WEBSITE="${2:-https://example.com}"
PKG="${3:-com.example.myapp}"

echo "🚀 Building $APP_NAME..."

# Setup
export ANDROID_SDK_ROOT=$HOME/android-sdk
export PATH=$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$PATH

# Create project
mkdir -p ~/$APP_NAME/app/src/main/{java,res/{layout,values,xml,mipmap-mdpi,mipmap-hdpi,mipmap-xhdpi,mipmap-xxhdpi,mipmap-xxxhdpi}}
cd ~/$APP_NAME

# Add all config files (see previous examples)
# ... [generate gradle files, MainActivity.java, AndroidManifest.xml, etc]

# Build
gradle clean assembleDebug

# Install
mkdir -p releases
cp app/build/outputs/apk/debug/app-debug.apk releases/$APP_NAME.apk

echo "✅ Complete! APK: ~/releases/$APP_NAME.apk"
adb install releases/$APP_NAME.apk
```

---

## 📊 Comparison Table

| Website | App Type | Features to Enable | Min SDK | Special Config |
|---------|----------|-------------------|---------|-----------------|
| YouTube | Video Streaming | Media playback, JS, DOM | 21 | `setMediaPlaybackRequiresUserGesture(false)` |
| AliExpress | E-Commerce | Location, Camera, JS | 21 | Add geolocation & camera permissions |
| BBC | News Reader | DOM, Cache, Larger fonts | 21 | `setDefaultFontSize(16)` |
| Docs.Google | Productivity | JS, DOM, Database, Full screen | 21 | `setMediaPlaybackRequiresUserGesture(false)` |
| Reddit | Social Media | DOM, Database, Cache | 21 | Standard config |
| Portfolio | Personal Site | Basic | 21 | Minimal config |

---

## ✅ Checklist Before Building

- [ ] Java 11 installed (`java -version`)
- [ ] Gradle installed (`gradle --version`)
- [ ] Android SDK at `$HOME/android-sdk`
- [ ] Licenses accepted (`sdkmanager --licenses`)
- [ ] SDK components installed (`sdkmanager "platforms;android-34"`)
- [ ] Project directory created
- [ ] All Gradle files present (build.gradle, gradle.properties, etc.)
- [ ] MainActivity.java with correct website URL
- [ ] IconsPNG files generated (5 densities)
- [ ] AndroidManifest.xml configured
- [ ] Proper permissions added

---

## 🚀 Build Output Sizes (Examples)

- YouTube wrapper: 3.2 MB
- News app: 3.1 MB  
- E-Commerce: 3.5 MB
- Productivity: 3.3 MB
- Portfolio: 3.0 MB

All are ~3.0-3.5 MB because they include the WebView engine + AndroidX libraries + resources.

---

**Ready to build? Start with COMPLETE_BUILD_GUIDE.md!**
