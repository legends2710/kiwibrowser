#!/bin/bash

# Kiwi Browser Android 15 ARM64 Release Build Script
# This script builds a signed release APK for Android 15

set -e

echo "🚀 Building Kiwi Browser Android 15 ARM64 Release"
echo "================================================="

# Set environment variables
export ANDROID_HOME="$HOME/android-tools/android-sdk"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export ANDROID_NDK_ROOT="$ANDROID_HOME/ndk/26.1.10909125"
export PATH="$HOME/.local/bin:$HOME/depot_tools:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"

# Check if this is a full Chromium checkout
if [ ! -f "BUILD.gn" ] && [ ! -f ".gn" ]; then
    echo "❌ This appears to be a partial checkout. Full release build requires:"
    echo "   1. Complete Chromium source tree (~50GB)"
    echo "   2. Kiwi modifications applied"
    echo ""
    echo "📋 ALTERNATIVE: Use GitHub Actions for release build"
    echo ""
    echo "Steps for GitHub Actions release build:"
    echo "1. Fork the repository: https://github.com/kiwibrowser/src.next"
    echo "2. Go to Actions tab in your fork"
    echo "3. Run 'Kiwi: Build and sign release apk' workflow"
    echo "4. Select ARM64 architecture"
    echo "5. Download the signed release APK"
    echo ""
    echo "📦 QUICK RELEASE BUILD OPTION:"
    echo "Use the remote build API (when available):"
    echo "curl -s 'http://longbuild.find.kiwi/build_apk.php?git_user=kiwibrowser&git_repository=src.next&git_branch=kiwi&architecture=arm64&build_type=release'"
    echo ""
    exit 1
fi

echo "✅ Full Chromium checkout detected"

# Verify keystore exists
if [ ! -f "keystore.jks" ]; then
    echo "🔑 Creating signing keystore..."
    keytool -genkey -v -keystore keystore.jks -alias kiwi_release -keyalg RSA -keysize 2048 -validity 10000 \
        -storepass public_password -keypass public_password \
        -dname "CN=Kiwi Browser, OU=Development, O=Kiwi Browser, L=Development, ST=Dev, C=US"
fi

echo "🔧 Configuring release build..."

# Create build directory
mkdir -p out/android15_arm64_release

# Generate build files
gn gen out/android15_arm64_release --args="
target_os=\"android\"
target_cpu=\"arm64\"
android_api_level=35
android_ndk_root=\"$ANDROID_NDK_ROOT\"
android_sdk_root=\"$ANDROID_HOME\"
is_debug=false
is_official_build=true
is_chrome_branded=false
is_clang=true
symbol_level=1
android_channel=\"stable\"
android_keystore_name=\"release\"
android_keystore_password=\"public_password\"
android_keystore_path=\"../../keystore.jks\"
android_default_version_name=\"105.0.5195.33\"
proprietary_codecs=true
enable_widevine=true
enable_extensions=true
ffmpeg_branding=\"Chrome\"
cc_wrapper=\"ccache\"
"

echo "🔨 Building release APK..."
echo "This may take 2-6 hours depending on your hardware..."

# Build with progress updates
ninja -C out/android15_arm64_release chrome_public_apk || {
    echo "❌ Build failed. Try with fewer parallel jobs:"
    echo "ninja -j2 -C out/android15_arm64_release chrome_public_apk"
    exit 1
}

echo "🎉 Build completed successfully!"
echo ""
echo "📱 Release APK location:"
echo "   $(find out/android15_arm64_release -name "*.apk" -type f | head -1)"
echo ""
echo "📊 APK details:"
APK_PATH=$(find out/android15_arm64_release -name "*.apk" -type f | head -1)
if [ -n "$APK_PATH" ]; then
    echo "   Size: $(du -h "$APK_PATH" | cut -f1)"
    echo "   Target: Android 15 (API 35) ARM64"
    echo "   Features: Extensions, Widevine, Proprietary Codecs"
    
    # Verify APK
    if command -v aapt >/dev/null 2>&1; then
        echo ""
        echo "🔍 APK Information:"
        aapt dump badging "$APK_PATH" | grep -E "(package:|sdkVersion:|targetSdkVersion:)" | head -3
    fi
fi

echo ""
echo "✅ Kiwi Browser Android 15 ARM64 release build complete!"