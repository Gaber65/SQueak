#!/bin/bash

# Fix qr_code_scanner namespace issue
QR_SCANNER_BUILD_GRADLE="/Users/mac/.pub-cache/hosted/pub.dev/qr_code_scanner-1.0.1/android/build.gradle"

if [ -f "$QR_SCANNER_BUILD_GRADLE" ]; then
    echo "Fixing qr_code_scanner namespace issue..."
    
    # Create a backup
    cp "$QR_SCANNER_BUILD_GRADLE" "$QR_SCANNER_BUILD_GRADLE.backup"
    
    # Add namespace to android block
    if ! grep -q "namespace" "$QR_SCANNER_BUILD_GRADLE"; then
        # Use sed to add namespace after the android { line
        sed -i '' '/android {/a\
    namespace "net.touchcapture.qr.flutterqr"
' "$QR_SCANNER_BUILD_GRADLE"
        echo "Namespace added to qr_code_scanner build.gradle"
    else
        echo "Namespace already exists"
    fi
else
    echo "qr_code_scanner build.gradle not found"
fi
