plugins {
    id("com.android.application")
    id("com.google.gms.google-services")   // ✅ REQUIRED
    kotlin("android")
}

android {
    namespace = "com.example.tourist_safety_new"   // keep your package name
    compileSdk = 34

    defaultConfig {
        applicationId = "com.example.tourist_safety_new"
        minSdk = 21
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
        release {
            isMinifyEnabled = false
        }
    }
}

dependencies {
    implementation("org.jetbrains.kotlin:kotlin-stdlib")
}