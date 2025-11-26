import java.util.Properties

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

// Read keystore properties for signing
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(keystorePropertiesFile.inputStream())
}

android {
    namespace = "com.wevoride"
    compileSdk = 36
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    sourceSets {
        getByName("main") {
            java.srcDirs("src/main/kotlin")
        }
    }

    defaultConfig {
        manifestPlaceholders += mapOf()
        applicationId = "com.wevoride"
        minSdk = 24
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
        
        // Ensure 16KB page size support
        manifestPlaceholders["android"] = "true"
        manifestPlaceholders["applicationName"] = "io.flutter.app.FlutterApplication"
        
        // Enhanced 16KB page size support configuration
        ndk {
            // Only include ARM architectures for 16KB page size compatibility
            abiFilters.addAll(listOf("arm64-v8a", "armeabi-v7a"))
        }
        
        // Add 16KB page size alignment configuration
        packagingOptions {
            jniLibs {
                useLegacyPackaging = false
            }
        }
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties.getProperty("keyAlias")
            keyPassword = keystoreProperties.getProperty("keyPassword")
            storeFile = keystoreProperties.getProperty("storeFile")?.let { file(it) }
            storePassword = keystoreProperties.getProperty("storePassword")
        }
    }

    buildTypes {
        getByName("release") {
            isMinifyEnabled = false
            isShrinkResources = false
            signingConfig = signingConfigs.getByName("release")
            
            // Enable 16KB page alignment for release builds
            packagingOptions {
                jniLibs {
                    useLegacyPackaging = false
                }
            }
        }
    }

    packaging {
        jniLibs {
            useLegacyPackaging = false
            // Exclude Card.io native libraries that don't support 16KB page sizes
            excludes += listOf(
                "**/libcardioDecider.so",
                "**/libcardioRecognizer.so",
                "**/libcardioRecognizer_tegra2.so",
                "**/libopencv_core.so",
                "**/libopencv_imgproc.so"
            )
        }
        
        // Enhanced 16KB page size alignment
        pickFirsts += listOf(
            "**/libc++_shared.so", 
            "**/libjsc.so",
            "**/libflutter.so"
        )
        
        // Exclude metadata files to reduce APK size
        resources {
            excludes += listOf(
                "META-INF/DEPENDENCIES",
                "META-INF/LICENSE",
                "META-INF/LICENSE.txt",
                "META-INF/license.txt",
                "META-INF/NOTICE",
                "META-INF/NOTICE.txt",
                "META-INF/notice.txt",
                "META-INF/ASL2.0",
                "META-INF/*.version",
                "META-INF/proguard/*"
            )
        }
    }

    lint {
        checkReleaseBuilds = false
        abortOnError = false
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
    implementation("androidx.multidex:multidex:2.0.1")
    implementation("io.card:android-sdk:5.5.1")
    
    // Play Integrity API - replaces deprecated SafetyNet
    implementation("com.google.android.play:integrity:1.5.0")
    
    // Enhanced edge-to-edge support with latest versions
    implementation("androidx.core:core:1.17.0")
    implementation("androidx.core:core-ktx:1.17.0")
    implementation("androidx.activity:activity:1.11.0")
    implementation("androidx.activity:activity-ktx:1.11.0")
    
    // Window insets handling for edge-to-edge
    implementation("androidx.core:core-splashscreen:1.0.1")
    
    // Material3 with edge-to-edge support
    implementation("com.google.android.material:material:1.12.0")
    
    // Exclude deprecated SafetyNet if pulled in transitively
    configurations.all {
        exclude(group = "com.google.android.gms", module = "play-services-safetynet")
    }
}
