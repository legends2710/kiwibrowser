#!/bin/bash

# Kiwi Browser Android 15 ARM64 Build Environment Setup Script
# This script sets up all required dependencies and tools for building Kiwi Browser for Android 15 (API 35) ARM64

set -e

echo "Setting up Kiwi Browser Android 15 ARM64 build environment..."

# Set environment variables
export ANDROID_HOME="$HOME/android-tools/android-sdk"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export ANDROID_NDK_ROOT="$ANDROID_HOME/ndk/26.1.10909125"
export PATH="$HOME/.local/bin:$HOME/depot_tools:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"

# Verify installations
echo "Verifying installations..."

echo "✓ Android SDK Platform 35 (Android 15): $(ls -d $ANDROID_HOME/platforms/android-35 2>/dev/null && echo "INSTALLED" || echo "MISSING")"
echo "✓ Android Build Tools 35.0.0: $(ls -d $ANDROID_HOME/build-tools/35.0.0 2>/dev/null && echo "INSTALLED" || echo "MISSING")"
echo "✓ Android NDK 26.1: $(ls -d $ANDROID_NDK_ROOT 2>/dev/null && echo "INSTALLED" || echo "MISSING")"
echo "✓ Ninja build system: $($HOME/.local/bin/ninja --version 2>/dev/null || echo "MISSING")"
echo "✓ Depot Tools: $(ls -d $HOME/depot_tools 2>/dev/null && echo "INSTALLED" || echo "MISSING")"
echo "✓ Java: $(java -version 2>&1 | head -1)"
echo "✓ Python3: $(python3 --version)"
echo "✓ Git: $(git --version)"

# Build configuration suggestions
echo ""
echo "=== BUILD CONFIGURATION FOR ANDROID 15 ARM64 ==="
echo ""
echo "GN build arguments for Android 15 ARM64 build:"
echo "target_os = \"android\""
echo "target_cpu = \"arm64\""
echo "android_api_level = 35"
echo "android_ndk_root = \"$ANDROID_NDK_ROOT\""
echo "android_sdk_root = \"$ANDROID_HOME\""
echo "is_debug = false"
echo "is_clang = true"
echo "use_goma = false"
echo "symbol_level = 1"
echo ""

# Check for missing system packages
echo "=== SYSTEM REQUIREMENTS CHECK ==="
missing_packages=()

# Check for essential build tools
if ! command -v clang &> /dev/null; then
    missing_packages+="clang"
fi

if ! command -v make &> /dev/null; then
    missing_packages+="build-essential"
fi

if ! dpkg -l | grep -q python3-dev; then
    missing_packages+="python3-dev"
fi

if [ ${#missing_packages[@]} -eq 0 ]; then
    echo "✓ All system packages are installed"
else
    echo "⚠ Missing system packages (install with sudo apt install):"
    printf '  %s\n' "${missing_packages[@]}"
fi

echo ""
echo "=== BUILD COMMANDS ==="
echo ""
echo "To build Kiwi Browser for Android 15 ARM64:"
echo "1. Set up build directory:"
echo "   gn gen out/android_arm64 --args='target_os=\"android\" target_cpu=\"arm64\" android_api_level=35'"
echo ""
echo "2. Build the APK:"
echo "   ninja -C out/android_arm64 chrome_public_apk"
echo ""
echo "3. Or build specific components:"
echo "   ninja -C out/android_arm64 content_shell_apk"
echo "   ninja -C out/android_arm64 webview_instrumentation_apk"
echo ""

echo "Environment setup complete! Source this script or restart your terminal to use the environment."
echo "Note: You may need to install system packages with sudo privileges."