plugins {
    id("com.android.application")
    id("kotlin-android") // or: id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.softicare.squeak"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.softicare.squeak"
        minSdk = 21  // Explicitly set to API 21 (Android 5.0) for broader device support
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
        ndk {
            abiFilters.addAll(listOf("armeabi-v7a", "arm64-v8a", "x86_64"))
        }
    }

    // Prefer loading from key.properties, but keeping your direct file config works too.
    signingConfigs {
        create("release") {
            storeFile = file("/Users/mac/StudioProjects/SqueakFlutter/android/new-upload-key.jks")
            storePassword = "Squeak"   // ⚠️ move to key.properties/CI secrets later
            keyAlias = "upload"        // ensure this is the alias with SHA1 18:1C:...:AF
            keyPassword = "Squeak"     // ⚠️ move to key.properties/CI secrets later
        }
    }

    buildTypes {
        getByName("release") {
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            // ✅ Use the release signing config (NOT debug!)
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:1.2.2")
}
