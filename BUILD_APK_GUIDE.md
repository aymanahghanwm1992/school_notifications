# دليل بناء ملف APK للتطبيق

## المشكلة
Android SDK غير مثبت على الجهاز، وهو مطلوب لبناء ملف APK.

---

## ✅ الحل 1: استخدام Android Studio (الطريقة الرسمية)

### الخطوة 1: تحميل Android Studio
1. اذهب إلى: https://developer.android.com/studio
2. حمّل النسخة الكاملة (يتضمن SDK تلقائياً)
3. ثبّت البرنامج على جهازك

### الخطوة 2: إكمال الإعداد
1. افتح Android Studio
2. انتظر حتى ينتهي من تحميل المكونات
3. اذهب إلى **Tools → SDK Manager**
4. تحقق من تثبيت:
   - ✅ Android SDK Platform 34 أو أحدث
   - ✅ Android SDK Build-Tools
   - ✅ Google APIs

### الخطوة 3: ضبط متغيرات البيئة

افتح **PowerShell** كمسؤول وأدخل:

```powershell
# اضبط مسار Android SDK
[Environment]::SetEnvironmentVariable("ANDROID_HOME", "$env:LOCALAPPDATA\Android\sdk", [EnvironmentVariableTarget]::User)

# تحقق من التثبيت
flutter doctor
```

### الخطوة 4: بناء APK

```bash
cd c:/Users/hp/school_notifications
flutter build apk --release
```

الملف سيكون في: `build/app/outputs/flutter-apk/app-release.apk`

---

## ⚡ الحل 2: استخدام خدمة سحابية (بدون تثبيت SDK)

### استخدام Codemagic (مجاني)

1. اذهب إلى: https://codemagic.io
2. سجل حساباً جديداً (استخدم GitHub)
3. اربط مشروعك على GitHub
4. اختر: **Android APK** من القائمة
5. اضغط **Build**
6. انتظر الانتهاء وحمّل ملف APK

---

## 📲 الحل 3: استخدام Firebase App Distribution

### الخطوات:

1. اذهب إلى: https://console.firebase.google.com
2. اختر مشروعك `school_notifications`
3. اذهب إلى: **Release → App Distribution**
4. أضف البريد الإلكتروني للمختبرين
5. حمّل الملف APK بعد بناؤه
6. أرسل الرابط للمختبرين

---

## 🎯 الخطوات السريعة (الطريقة الموصى بها)

### إذا كنت على عجلة:

1. **حمّل Android Studio**
   ```
   https://developer.android.com/studio
   ```

2. **بعد التثبيت، افتح Terminal وشغّل:**
   ```bash
   flutter doctor
   ```
   (لحل أي مشاكل متبقية)

3. **بعدها، ابنِ APK:**
   ```bash
   cd c:/Users/hp/school_notifications
   flutter build apk --release
   ```

4. **الملف يكون هنا:**
   ```
   c:\Users\hp\school_notifications\build\app\outputs\flutter-apk\app-release.apk
   ```

5. **انسخ الملف إلى الهاتف وثبّته**

---

## 📝 ملاحظات مهمة

- **حجم ملف APK**: حوالي 50-80 MB
- **متطلبات الهاتف**: Android 5.0 فما فوق
- **المدة الزمنية للبناء**: 5-15 دقيقة (أول مرة)
- **الإنترنت**: مطلوب للتحميل الأولي للمكونات

---

## 🆘 حل المشاكل

### إذا ظهرت مشاكل:

```bash
# نظف المشروع
flutter clean

# جرّب البناء مجدداً
flutter pub get
flutter build apk --release
```

### إذا استمرت المشاكل:

```bash
# تحقق من التثبيت
flutter doctor -v

# أصلح المشاكل المقترحة
```

---

## ✨ خيارات بديلة للتثبيت على الهاتف

### 1️⃣ **البريد الإلكتروني**
- أرسل ملف APK عبر البريد
- افتحه على الهاتف وثبّته

### 2️⃣ **Google Drive**
- ارفع الملف على Google Drive
- حمّله من الهاتف
- ثبّته من هاتفك

### 3️⃣ **USB مباشر**
```bash
adb install build/app/outputs/flutter-apk/app-release.apk
```

### 4️⃣ **أي خدمة نقل (WhatsApp, Telegram, إلخ)**
- أرسل الملف مباشرة

---

## 🎉 بعد تثبيت التطبيق

✅ افتح التطبيق على الهاتف
✅ سيرى الإشعارات من Supabase مباشرة
✅ عند وصول إشعار جديد:
- سيسمع نغمة
- سيشعر باهتزاز
- سيرى الإشعار في التطبيق فوراً

---

**هل تحتاج لمساعدة في أي خطوة؟**
