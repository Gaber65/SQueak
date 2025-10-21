#!/bin/bash

# Complete fix for qr_code_scanner build issues
QR_SCANNER_BUILD_GRADLE="/Users/mac/.pub-cache/hosted/pub.dev/qr_code_scanner-1.0.1/android/build.gradle"

if [ -f "$QR_SCANNER_BUILD_GRADLE" ]; then
    echo "Applying comprehensive fix to qr_code_scanner build.gradle..."
    
    # Create a backup if it doesn't exist
    if [ ! -f "$QR_SCANNER_BUILD_GRADLE.backup" ]; then
        cp "$QR_SCANNER_BUILD_GRADLE" "$QR_SCANNER_BUILD_GRADLE.backup"
    fi
    
    # Create the complete fixed build.gradle file
    cat > "$QR_SCANNER_BUILD_GRADLE" << 'EOF'
group 'net.touchcapture.qr.flutterqr'
version '1.0-SNAPSHOT'

buildscript {
    ext.kotlin_version = '1.7.10'
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath 'com.android.tools.build:gradle:7.2.2'
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
    }
}

rootProject.allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

apply plugin: 'com.android.library'
apply plugin: 'kotlin-android'

android {
    namespace "net.touchcapture.qr.flutterqr"
    compileSdkVersion 32

    sourceSets {
        main.java.srcDirs += 'src/main/kotlin'
    }
    defaultConfig {
        // minSdkVersion is determined by Native View.
        minSdkVersion 20
        targetSdkVersion 32
        testInstrumentationRunner "androidx.test.runner.AndroidJUnitRunner"
        multiDexEnabled true
    }

    compileOptions {
        // Flag to enable support for the new language APIs
        coreLibraryDesugaringEnabled true
        // Sets Java compatibility to Java 8
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }
}

dependencies {
    implementation "org.jetbrains.kotlin:kotlin-stdlib-jdk7:$kotlin_version"
    implementation('com.journeyapps:zxing-android-embedded:4.3.0') { transitive = false }
    implementation 'androidx.appcompat:appcompat:1.4.2'
    implementation 'com.google.zxing:core:3.5.0'
    coreLibraryDesugaring 'com.android.tools:desugar_jdk_libs:1.2.0'
}
EOF
    
    echo "qr_code_scanner build.gradle completely fixed with proper JVM target"
else
    echo "qr_code_scanner build.gradle not found"
fi
