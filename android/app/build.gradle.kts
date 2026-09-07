plugins {
    id("com.android.application")
    // 🎯 فائر بیس کے لیے لازمی گوگل سروسز پلگ ان
    id("com.google.gms.google-services")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.nayab_qist_point_customer"
    
    // 🟢 SDK 36 پر سیٹ کیا گیا ہے تاکہ بلڈ بنا کسی ایرر کے پاس ہو جائے
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.example.nayab_qist_point_customer"
        // 🟢 local_auth اور Biometrics کے لیے minSdk 21
        minSdk = flutter.minSdkVersion 
        
        // 🟢 Target SDK 36
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}