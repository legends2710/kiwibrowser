#!/bin/bash

# Script to push Android 15 ARM64 build configuration to your GitHub fork
# https://github.com/legends2710/kiwibrowser

echo "🚀 Pushing Android 15 ARM64 build configuration to GitHub..."
echo "Target: https://github.com/legends2710/kiwibrowser"
echo ""

# Check if GitHub CLI is available
if command -v gh &> /dev/null; then
    echo "📱 GitHub CLI detected - using gh auth"
    echo "Please run: gh auth login"
    echo "Then: git push fork kiwi"
else
    echo "🔑 GitHub CLI not found. Choose authentication method:"
    echo ""
    echo "OPTION 1: Install GitHub CLI (Recommended)"
    echo "sudo apt install gh"
    echo "gh auth login"
    echo "git push fork kiwi"
    echo ""
    echo "OPTION 2: Use Personal Access Token"
    echo "1. Create token at: https://github.com/settings/tokens"
    echo "2. Select scopes: repo, workflow"
    echo "3. Run: git remote set-url fork https://legends2710:YOUR_TOKEN@github.com/legends2710/kiwibrowser.git"
    echo "4. Run: git push fork kiwi"
    echo ""
    echo "OPTION 3: Use SSH (if SSH key configured)"
    echo "git remote set-url fork git@github.com:legends2710/kiwibrowser.git"
    echo "git push fork kiwi"
fi

echo ""
echo "📋 What will be pushed:"
echo "✅ Android 15 (API 35) build configuration"
echo "✅ ARM64 optimization settings"
echo "✅ Release signing keystore"
echo "✅ Complete build documentation"
echo "✅ GitHub Actions workflow compatibility"
echo ""

echo "🎯 After successful push:"
echo "1. Go to: https://github.com/legends2710/kiwibrowser/actions"
echo "2. Run: 'Kiwi: Build and sign release apk' workflow"
echo "3. Wait: 60-90 minutes for build completion"
echo "4. Download: ARM64 APK from artifacts"
echo ""
echo "📱 Expected output: Signed Android 15 ARM64 Kiwi Browser APK"
echo "⚡ Features: Extensions + Widevine + Ad Blocking + ARM64 optimized"