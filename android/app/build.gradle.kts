plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.school.notifications"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.school.notifications"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        
        // دعم Multidex إذا كان مطلوباً
        multiDexEnabled = true
    }

    buildTypes {
        release {
            // تحديد ملف المفاتيح للتوقيع (استبدل بمفاتيحك الخاصة)
            signingConfig = signingConfigs.getByName("debug")
            
            // تفعيل تقليل الكود
            minifyEnabled = false
        }
        
        debug {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
    
    // تكوين البناء للإصدار
    packagingOptions {
        exclude 'META-INF/proguard/androidx-*.pro'
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

dependencies {
    // Firebase
    implementation(platform("com.google.firebase:firebase-bom:34.14.1"))
    implementation("com.google.firebase:firebase-messaging")
    implementation("com.google.firebase:firebase-analytics")
    
    // Multidex (if needed)
    implementation("androidx.multidex:multidex:2.0.1")
}

flutter {
    source = "../.."
}