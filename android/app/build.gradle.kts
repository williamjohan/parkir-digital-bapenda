import java.util.Properties
import java.io.FileInputStream

// 🚀 1. MEMBACA FILE KEY.PROPERTIES DARI FOLDER ANDROID/
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
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
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "id.go.surabaya.tsparkbapenda"
        minSdk = 24
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    flavorDimensions += "env"

    productFlavors {
        create("jukir") {
            dimension = "env"
            applicationIdSuffix = ".jukir"
            resValue("string", "app_name", "TS Park Jukir")
        }
        create("demo") {
            dimension = "env"
            applicationIdSuffix = ".demo"
            resValue("string", "app_name", "TS Park Bapenda")
        }
        create("playstore") {
            dimension = "env"
            resValue("string", "app_name", "TS Park Bapenda")
        }
    }

    // 🚀 2. DAFTARKAN CONFIG SIGNING RESMI PLAYSTORE
    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String?
            keyPassword = keystoreProperties["keyPassword"] as String?
            // Membaca file .jks yang ditaruh di dalam folder android/app/
            storeFile = keystoreProperties["storeFile"]?.let { file(it) }
            storePassword = keystoreProperties["storePassword"] as String?
        }
    }

    buildTypes {
        release {
            // 🚀 3. GANTI DARI "debug" MENJADI getByName("release")
            signingConfig = signingConfigs.getByName("release")

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