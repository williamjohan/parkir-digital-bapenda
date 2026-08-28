-keepclassmembers class * extends androidx.security.crypto.EncryptedSharedPreferences {
    <init>(...);
}
-keep class androidx.security.crypto.** { *; }
-keep class com.google.crypto.tink.** { *; }