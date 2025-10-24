#!/bin/bash

# Fix qr_code_scanner JVM target issue
QR_SCANNER_BUILD_GRADLE="/Users/mac/.pub-cache/hosted/pub.dev/qr_code_scanner-1.0.1/android/build.gradle"

if [ -f "$QR_SCANNER_BUILD_GRADLE" ]; then
    echo "Fixing qr_code_scanner JVM target issue..."
    
    # Fix JVM target from 21 to 11
    sed -i '' 's/jvmTarget.*/jvmTarget = "11"/g' "$QR_SCANNER_BUILD_GRADLE"
    sed -i '' 's/JavaVersion.VERSION_21/JavaVersion.VERSION_11/g' "$QR_SCANNER_BUILD_GRADLE"
    sed -i '' 's/targetCompatibility.*21/targetCompatibility JavaVersion.VERSION_11/g' "$QR_SCANNER_BUILD_GRADLE"
    sed -i '' 's/sourceCompatibility.*21/sourceCompatibility JavaVersion.VERSION_11/g' "$QR_SCANNER_BUILD_GRADLE"
    
    echo "JVM target fixed in qr_code_scanner build.gradle"
else
    echo "qr_code_scanner build.gradle not found"
fi
