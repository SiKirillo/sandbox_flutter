plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.samarlandsoft.sandbox_flutter"
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.samarlandsoft.sandbox_flutter"
        minSdk = 28
        targetSdk = flutter.targetSdkVersion
        compileSdk = flutter.compileSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }

        debug {
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    applicationVariants.all {
        val variant = this
        variant.outputs.map { it as com.android.build.gradle.internal.api.BaseVariantOutputImpl }.forEach { output ->
            // Getting flavor (if exists) and build type
            val flavor = variant.flavorName ?: "noflavor"
            val buildType = variant.buildType.name
            val versionName = variant.versionName
            val applicationId = variant.applicationId
            val appIdSanitized = applicationId.replace(".", "-")

            // Generating APK name
            val outputFileName = if (flavor.contains("prod")) {
                "$appIdSanitized-prod-$buildType-$versionName.apk"
            } else {
                "$appIdSanitized-$buildType-$versionName.apk"
            }

            // Setting output file name
            output.outputFileName = outputFileName
        }
    }
}

flutter {
    source = "../.."
}
