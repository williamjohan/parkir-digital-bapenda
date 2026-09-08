# --- Aturan Keamanan (Untuk flutter_secure_storage) ---
-keepclassmembers class * extends androidx.security.crypto.EncryptedSharedPreferences {
    <init>(...);
}
-keep class androidx.security.crypto.** { *; }
-keep class com.google.crypto.tink.** { *; }

# --- Tambahan Aturan Baru (Untuk google_mlkit_text_recognition) ---
-dontwarn com.google.mlkit.vision.text.chinese.**
-dontwarn com.google.mlkit.vision.text.devanagari.**
-dontwarn com.google.mlkit.vision.text.japanese.**
-dontwarn com.google.mlkit.vision.text.korean.**