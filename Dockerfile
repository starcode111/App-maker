FROM ubuntu:24.04

# Install Java 11 and build tools
RUN apt-get update && apt-get install -y \
    openjdk-11-jdk \
    wget \
    unzip \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Set JAVA_HOME
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH

# Install Android SDK
ENV ANDROID_SDK_ROOT=/android-sdk
ENV PATH=$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$PATH

RUN mkdir -p $ANDROID_SDK_ROOT/cmdline-tools

# Download and install Android SDK command-line tools
RUN wget -q https://dl.google.com/android/repository/commandlinetools-linux-9862592_latest.zip && \
    unzip -q commandlinetools-linux-9862592_latest.zip -d $ANDROID_SDK_ROOT/cmdline-tools && \
    mv $ANDROID_SDK_ROOT/cmdline-tools/cmdline-tools $ANDROID_SDK_ROOT/cmdline-tools/latest && \
    rm commandlinetools-linux-9862592_latest.zip

# Accept licenses and install Android SDK components
RUN yes | sdkmanager --licenses
RUN sdkmanager "platforms;android-34" "platforms;android-21" \
    "build-tools;34.0.0" \
    "platform-tools"

# Set working directory
WORKDIR /workspace

# Clone or copy the project
COPY . /workspace/

# Build the APK
RUN chmod +x gradlew && \
    ./gradlew clean build

# Output directory
RUN mkdir -p /output && \
    cp app/build/outputs/apk/debug/app-debug.apk /output/example-app-debug.apk || true && \
    cp app/build/outputs/apk/release/app-release.apk /output/example-app-release.apk || true

VOLUME ["/output"]
CMD ["bash"]
