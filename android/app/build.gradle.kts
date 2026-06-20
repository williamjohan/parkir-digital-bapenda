plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "id.go.surabaya.tsparkbapenda"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true 
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "id.go.surabaya.tsparkbapenda"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // 🚀 THE FACTORY ENGINE (FLAVORS) - KOTLIN DSL SYNTAX
    flavorDimensions += "env"

    productFlavors {
        // 1. JALUR PRODUKSI (LIVE)
        create("prod") {
            dimension = "env"
            resValue("string", "app_name", "TS Park Bapenda")
        }
        
        // 2. JALUR DEMO (PRESENTASI PIMPINAN)
        create("demo") {
            dimension = "env"
            applicationIdSuffix = ".demo"
            resValue("string", "app_name", "TS Park Bapenda (DEMO)")
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")

            isMinifyEnabled = true
            isShrinkResources = true

            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
    implementation("com.google.mlkit:text-recognition:16.0.0")
}

flutter {
    source = "../.."
}