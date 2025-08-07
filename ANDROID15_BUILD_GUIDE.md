# Kiwi Browser Android 15 ARM64 Build Guide

## Setup Complete ✅

The build environment has been successfully configured with:
- Android SDK Platform 35 (Android 15) 
- Android Build Tools 35.0.0
- Android NDK 26.1.10909125
- Ninja Build System 1.13.1
- Chromium Depot Tools
- Java 21 LTS, Python 3.12, Git

## Final Setup Steps (Requires sudo)

Install the remaining system package:
```bash
sudo apt update
sudo apt install -y clang build-essential
```

## Environment Setup

Add to your shell profile (~/.bashrc):
```bash
export ANDROID_HOME="$HOME/android-tools/android-sdk"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export ANDROID_NDK_ROOT="$ANDROID_HOME/ndk/26.1.10909125"
export PATH="$HOME/.local/bin:$HOME/depot_tools:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"
```

Or source the setup script:
```bash
source ./setup_android15_build.sh
```

## Building for Android 15 ARM64

### 1. Configure Build Directory
```bash
cd /home/erick/Github/Repos/kiwibrowser
~/depot_tools/gn gen out/android_arm64 --args='
target_os="android"
target_cpu="arm64"
android_api_level=35
android_ndk_root="/home/erick/android-tools/android-sdk/ndk/26.1.10909125"
android_sdk_root="/home/erick/android-tools/android-sdk"
is_debug=false
is_clang=true
use_goma=false
symbol_level=1
'
```

### 2. Build the APK
```bash
# Build main Kiwi Browser APK
ninja -C out/android_arm64 chrome_public_apk

# Or build other components
ninja -C out/android_arm64 content_shell_apk
ninja -C out/android_arm64 webview_instrumentation_apk
```

### 3. Alternative: Use the Project's Remote Build System
Since this project uses a remote build system (build.find.kiwi), you can also:
```bash
# Follow the project's workflow
.github/workflows/build-experimental.yml
```

## Build Targets Available

Based on the BUILD.gn files found:
- `chrome_public_apk` - Main Kiwi Browser APK
- `content_shell_apk` - Content shell for testing
- `webview_instrumentation_apk` - WebView component
- Individual components in various subdirectories

## Troubleshooting

### Common Issues:
1. **GN not found**: Ensure depot_tools is in PATH
2. **NDK errors**: Verify ANDROID_NDK_ROOT points to correct NDK version
3. **Build failures**: Check that all dependencies are installed
4. **Memory issues**: Use `-j` flag to limit parallel jobs: `ninja -j4 -C out/android_arm64 chrome_public_apk`

### Build Verification:
```bash
# Check environment
./setup_android15_build.sh

# Verify GN can generate
~/depot_tools/gn check out/android_arm64

# Test ninja dry-run
ninja -C out/android_arm64 -n chrome_public_apk
```

## Output Location

Built APKs will be in:
```
out/android_arm64/apks/KiwiBrowser.apk
```

## Architecture Support

This setup specifically targets:
- **Target**: Android 15 (API Level 35)
- **Architecture**: ARM64 (arm64-v8a)
- **ABI**: aarch64-linux-android
- **Min SDK**: Inherits from project (likely API 23+)

## Performance Tips

1. **Use ccache** (already configured in args.gn)
2. **Limit parallel jobs** if memory constrained: `-j4`
3. **Incremental builds** - only changed files rebuilt
4. **Use goma** if available in your environment