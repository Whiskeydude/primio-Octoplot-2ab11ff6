# Preserve Room database constructors used by WorkManager at startup.
-keep class * extends androidx.room.RoomDatabase { void <init>(); }
