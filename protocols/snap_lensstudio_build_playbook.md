# Snap Lens Studio — Real Build Automation Playbook (Phase 4 Execution)

**Version:** 1.1.0 (validated 2026-06-07 on Lens Studio 5.21, Windows 11)
**Changelog:** 1.1.0 — أضيف: أداة verify_3d_asset، §7.5 محفّز الابتسامة + ربط السكربت، §7.6 SnapML، §7.7 تنفيذ Phases 7/8/10.
**Owner:** snap_007 (Lens Studio Engineer) · **Part of:** [snap_lens_delivery_pipeline.md](snap_lens_delivery_pipeline.md) Phase 4
**Validated on:** عدسة "مبروك التخرج" — `C:\SnapLenses\GraduationLens`

> هذا الـ playbook يحوّل Phase 4 من "مواصفات" إلى **تنفيذ فعلي مؤتمت** داخل Lens Studio عبر PowerShell (screenshot + click + SendKeys). مبني على جلسة بناء حقيقية ناجحة.

---

## 0. نموذج التنفيذ الهجين (مهم)
الأتمتة العمياء (صوّر → حلّل → احسب إحداثي → انقر) **موثوقة للقوائم والحقول الرقمية والاستيراد**، وتفشل في **السحب-الإفلات داخل الشجرة والمنبثقات المعقّدة وتداخل النوافذ**.

| الأتمتة تتولّى | المستخدم يتولّى (عند الفشل) |
|----------------|-----------------------------|
| نسخ الأصول لمجلد Assets | drag-drop reparent في الشجرة |
| إضافة كائنات عبر "+" | إفلات prefab في المشهد |
| ضبط Inspector رقميًا | (إن تعذّر) منتقيات معقّدة |
| منتقيات الأصول (search+select) | — |
| التصوير والتحقق بعد كل خطوة | — |

**قاعدة:** بعد كل خطوة، التقط لقطة وتحقّق قبل التالية. لا تفترض النجاح.

---

## 1. تشغيل المشروع
```
1. Start-Process "Lens Studio.exe"
2. Home → بطاقة Snapchat (اكتشفها بتحليل اللون البرتقالي) → Default
3. Ctrl+Shift+S → اكتب اسم المشروع في حقل File name (Alt+N, Ctrl+A, type) → Enter
   ⚠️ LS 5.x يستخدم امتداد .esproj (ليس .lsproj) وينشئ مجلد مشروع كامل
```

## 2. استيراد الأصول
- **2D / صوت / سكربت:** انسخ الملفات مباشرة إلى `<project>\<name>\Assets\` → استيراد تلقائي (Automatic assets directory sync).
- **3D (GLB/FBX):** لا يلتقطه folder-sync. استخدم:
  ```
  Ctrl+Shift+I → Alt+N → اكتب المسار الكامل → Enter → نافذة الإعدادات → Accept (الزر الأزرق)
  ```
- ⛔ **تحقّق من صحة الملف قبل الاستيراد** بالأداة الجاهزة:
  ```powershell
  & "C:\Users\fahad\OneDrive\Desktop\AgentsSnapBlenderAutoCAD\protocols\tools\verify_3d_asset.ps1" -Path "<file>"
  ```
  ترفض الصور المقنّعة (PNG/JPEG بامتداد .glb)، وتؤكد وجود meshes/nodes، وتنبّه على Draco. exit 0 = آمن للاستيراد، exit 1 = لا تستورد. (الدرس: grad_cap.glb كان PNG → "SceneObject count: 0").

## 3. القبعة على الرأس (Head Binding)
```
1. Scene Hierarchy "+" → اكتب "head" → نقرتان على "Head Binding" (قسم Face)
2. [USER drag] اسحب الموديل من Asset Browser وأفلته على "Head Binding" ليصير ابنًا له
   (drag-reparent يفشل آليًا — سلّمه للمستخدم)
3. حدّد الموديل → Inspector → Transform:
   - Scale: موحّد على X و Y و Z (السلسلة قد تكون مفصولة → اضبط الثلاثة). مثال التخرج: 20
   - Position Y: موجب لرفعها على الرأس. مثال: 12
   (نقر مزدوج على الحقل → Ctrl+A → اكتب القيمة → Enter)
4. تحقّق من المعاينة (اقتص لوحة Preview اليمنى) واضبط حتى تجلس صح.
```

## 4. النص على الشاشة (Screen Image)
```
1. "+" → "image" → نقرتان على "Screen Image" (ينشئ Orthographic Camera + Full Frame Region)
2. حدّد Screen Image → Inspector → مكوّن Image → حقل Texture → اختر صورة النص من المنتقي
3. اضبط الموضع/الحجم عبر Screen Transform إذا لزم
```

## 5. القصاصات (Confetti)
```
1. Asset Library (زر الشريط - toggle، احذر تكراره) → search "confetti" → Import على "Confetti VFX"
2. ينشئ prefab "Confetti__PLACE_IN_SCENE" في Assets
3. [USER drag] اسحب الـ prefab إلى الشجرة/المشهد (أحيانًا يُضاف تلقائيًا)
4. أغلق Asset Library قبل المتابعة (يعترض النقرات)
```

## 6. الصوت (Audio)
```
1. "+" → "audio" → نقرتان على "Audio"
2. حدّد كائن Audio → Inspector → مكوّن Audio:
   - حقل "Audio Track" → انقره → منتقي يفتح → اكتب "sfx" في بحثه → نقرتان على الملف
   - فعّل "Autoplay Loop" (checkbox) للتشغيل التلقائي
     (أو اتركه للتشغيل عبر Behavior/script عند الابتسامة - متقدّم)
```

## 7. الحفظ والتصدير
```
1. Ctrl+S بعد كل مرحلة مهمة
2. التصدير: Project → Export، أو النشر: Publish Lens (يتطلب تسجيل دخول حساب Snap - تدخّل المستخدم)
3. Snapcode يُولَّد بعد النشر في My Lenses
```

---

## 7.5 محفّز الابتسامة + ربط السكربت (Interactive Celebration)
طريقتان لجعل الاحتفال (قصاصات+صوت) ينطلق **عند الابتسامة** بدل الاستمرار:

### الطريقة A — Behavior (موصى، بلا كود) ✅
1. Asset Library → ابحث "Behavior" → Import (مرة واحدة).
2. على كائن جديد: "+" → Helper Scripts → **Behavior** (سمِّه `SmileTrigger`).
3. في Inspector للـ Behavior:
   - **Trigger Type** = Face → **Smile Started** (faceIndex 0). (بديل: Mouth Opened.)
   - **Response 1** = "Enable/Disable Object" → On → Confetti (أو "Play Animation/VFX").
   - **Response 2** = "Audio - Play Sound" → الكائن: Audio، أو فعّل كائن Audio.
4. لإيقاف الاحتفال بعد ثوانٍ: Behavior ثانٍ بـ **Delay** يعطّل Confetti (cooldown).

### الطريقة B — السكربت المخصّص (تحكّم أدق)
- `GraduationController.js` يوفّر `script.api.celebrate` + cooldown + إدارة الحالات.
- اربط Behavior (Smile Started) → Response "Call Object API" → Target=Controller، Function=`celebrate`.
- **ربط حقول @input** (hat/tassel/text/hint/faceMsg/confetti/firework/sfx): على كائن Controller، **اسحب** كل كائن مطابق إلى حقله في Inspector.
  - ⚠️ ربط الحقول بالسحب = خطوة يدوية للمستخدم (drag غير موثوق آليًا). الأتمتة: حضّر الكائنات وسمِّها بوضوح؛ المستخدم يسحب.
- **Face expression في الكود:** إن دعمت النسخة قراءة أوزان التعبير، استطلع وزن الابتسامة في UpdateEvent واستدعِ `celebrate()` عند تجاوز عتبة (يلغي الحاجة لـ Behavior).

### قاعدة الاختيار
- نشر سريع/بسيط → الطريقة A. منطق غني (حالات/cooldown/تسلسل) → الطريقة B.
- في عدسة التخرج اكتُفي بـ Autoplay Loop (أبسط)؛ الترقية للابتسامة عبر الطريقة A.

## 7.6 SnapML (Phase 5 — اختياري، snap_008)
خطوات دمج نموذج ذكاء اصطناعي مخصّص:
1. **حدّد المهمة + المخرج:** segmentation (خلفية/شعر/سماء) · style transfer · classification · keypoints. المخرج على الجهاز = mask / إطار منمّق / تصنيف / نقاط.
2. **درّب وصدّر:** PyTorch/TF → **ONNX** (opset متوافق مع مستورد Lens Studio)، نموذج صغير، دقّة إدخال ثابتة معروفة.
3. **استورد كـ ML Asset:** انسخ ملف `.onnx` إلى `<project>/Assets/` (أو Import Asset) → يظهر كـ ML Asset.
4. **أضف MLComponent:** على كائن، Add Component → **MLComponent** → عيّن الـ Model = ملف ONNX.
5. **اربط المخرج:**
   - segmentation: وجّه الـ mask (output texture) إلى مادة (alpha/blend) لاستبدال/عزل الخلفية.
   - style transfer: وجّه الإطار المنمّق إلى Screen Image/material.
   - classification/keypoints: اقرأ المخرج في سكربت وحرّك السلوك.
6. **شغّل الاستدلال:** عبر سكربت (run on update/frame) أو إعداد MLComponent للتشغيل التلقائي.
7. **تحقّق على الجهاز:** دقّة + latency/FPS؛ لو ثقيل → quantize/prune (مع snap_010).
- ⚠️ تأكد أن **شكل tensor المخرج** يطابق توقّع MLComponent وإلا فشل صامت.
- ⛔ فحص رخصة/تحيّز البيانات (ألوان البشرة/الديموغرافيا) موثّق في `ml/README.md`.

## 7.7 Phases 7/8/10 — خطوات تنفيذية فعلية

### Phase 7 — Optimization (snap_010)
- **قياس الحجم:** بعد Publish/Export يظهر حجم العدسة، أو من Project Info / لوحة الأداء. الحد ~8MB (تحقّق الحالي).
- **قياس الأداء:** Preview → فعّل عرض FPS/الإحصاءات (Lens Studio performance panel)؛ جرّب على جهاز ضعيف عبر Send to device.
- **أكبر المكاسب عادة:** ضغط/تصغير القوام + atlas، decimate للموديلات، Unlit/additive، تقليل الجسيمات، صوت mono مضغوط. (في عدسة التخرج: استبدال GLB الوهمي 6.3MB بموديل حقيقي 9KB وفّر الكثير.)
- سجّل قبل/بعد في `docs/07-optimization.md`.

### Phase 8 — QA & Device (snap_011)
- **الاختبار على الجهاز:** اضغط **"Send to Snapchat"** / استخدم Snapcode، أو رابط My Lenses → افتح بالجوال.
- نفّذ مصفوفة الأجهزة + شروط التتبّع (إضاءة/وجوه متعددة/no-face) من PROMPT snap_011.
- سجّل النتائج في `docs/08-qa-report.md`؛ لا إغلاق مع HIGH مفتوح.

### Phase 10 — Analytics (snap_013)
- **المصدر:** `my-lenses.snapchat.com` → اختر العدسة → Insights/Analytics (views, plays, share rate, avg play time, screenshots, scans).
- قارن بأهداف Phase 1؛ شخّص نقاط التسرّب؛ أنتج backlog مرتّب في `docs/10-analytics.md`.
- ⏳ يتطلب مرور وقت بعد النشر لتجميع بيانات كافية.

## 8. تقنيات PowerShell المعتمدة
- **لقطة:** `System.Windows.Forms.SystemInformation.VirtualScreen` + `Graphics.CopyFromScreen` → PNG، ثم Read لقراءتها، وتكبير بـ `DrawImage` (HighQualityBicubic) للتفاصيل.
- **نقر:** `SetCursorPos` + `mouse_event(0x02/0x04)` (يسار)، `0x08/0x10` (يمين)، `mouse_event(0x0800,...,-120)` (عجلة).
- **كتابة:** `WScript.Shell.SendKeys` (Ctrl+A=`^a`, Enter=`{ENTER}`, Alt+N=`%n`, Esc=`{ESC}`).
- **تركيز النافذة:** `ShowWindow(h,3)` (maximize - يثبّت الإحداثيات) + `SetForegroundWindow`. ⚠️ ShowWindow(h,9)=restore يلغي التكبير ويزيح الإحداثيات.
- **اكتشاف عناصر بالألوان:** centroid لبكسلات لون الزر (مثل البرتقالي/الأزرق) بدل إحداثيات ثابتة.
- **التحقق على القرص:** `magic bytes`, وجود `.meta` بجانب الأصل = استيراد ناجح.

## 9. مزالق من الجلسة الحقيقية
- ملف GLB كان PNG مقنّعًا (صورة AI) → فحص التوقيع إلزامي.
- "Convert Meters To Centimeters" في استيراد 3D يجعل المقياس 100 (ضخم) → صغّر Scale.
- Scale غير موحّد (X فقط) = تشويه → اضبط X/Y/Z.
- Asset Library زر toggle متقلّب + يعترض النقرات → أغلقه صراحةً.
- نافذة Claude Code نفسها قد تقفز للمقدمة → أعد تركيز LS قبل أي نقر.

---

## 9.5 دروس فلتر التجميل Beauty Glow (2026-06-10) — مكياج + حقن نصّي

### المكياج/الرموش (الأهم)
- ❌ **الصور (Image) على نقاط تتبّع العين (`AttachmentPointType: LeftEye/RightEye/HeadCenter`) لا تُرسَم بكاميرا المعاينة** — جرّبنا كل المواضع/الأحجام (حتى 40×20) بلا نتيجة. لا تستخدمها للمكياج.
- ✅ **Face Mesh** هو الحل: أضِفه من "+" (3D → Face Mesh، يظهر تحت Effects/Head Binding). ارسم المكياج على **خريطة UV الوجه القياسية** `FaceMeshMaterial/Resources/FaceMeshTexture.jpg` (1024²، العينان عند ~(355,348)/(670,348)، الفم ~(510,680)).
- **اربط القوام:** عدّل `baseTex.id` في `Face Mesh N.mat` **المرتبطة بالـ RenderMeshVisual فعليًا** (تحقّق من المرجع في scene؛ الـ .mat الأخرى يتيمة وفارغة `PassesInfo: []`).
- 🎭 **القناع الأبيض على الوجه** = `ENABLE_FACE_TEX` + maskTex (FaceMeshTexture) + baseColor أبيض. الإزالة: احذف سطر `- ENABLE_FACE_TEX` من Defines.
- توليد رموش volume برمجيًا (Python/PIL على UV): قاعدة آيلاينر عريضة (تخفي الرموش الطبيعية — لا يمكن حذفها في AR) + رموش winged متدرّجة + curl. مولّد: `assets/generate_facemesh_lashes.py`.

### الحقن النصّي + المزالق
- ⛔ **لا تكتب `.scene`/`.mat` بـ `Set-Content -Encoding UTF8`** (PS 5.1 يضيف BOM → `YAML PARSE FAIL @ PackagePath`). استخدم `[System.IO.File]::WriteAllText($f,$text,(New-Object System.Text.UTF8Encoding($false)))`.
- 🖥️ **شاشة مزدوجة:** VirtualScreen 3840×1080، LS على الأولى. احسب إحداثيات النقر/الاقتصاص حسب العرض الفعلي — افتراض 1920 يزيح كل شيء.
- مؤثرات التجميل المحلية (presets) في `JsPlugins/PresetsRegistry/Assets/` (ColorCorrection/EyeColor/FaceMesh/FaceMask) — من "+" بلا تنزيل. **Face Retouch من Asset Library** (شبكة). أسماء presets Color Correction: Brightening/Crisp Warm/Clean/Cinematic...
- تحذيرات `getFacesCount/getLandmark` deprecated من سكربت `Lips Fix_NEW.js` **داخل** مؤثر Face Retouch (Snap) — غير قابلة للتعديل (ليست ملفًا) وغير ضارة؛ تُخفى من فلتر Logger.
- folder-sync لا يلتقط استبدال نفس ملف texture فورًا → أغلق/افتح LS.
- **Preview Lens** (زر، أعلى يمين) = اختبار حيّ على جوال المستخدم؛ **Publish** (أزرق) = النشر. كلاه: يتطلب تسجيل دخول Snap.

---

## 10. الربط مع البيبلاين
- ينفّذه **snap_007** في Phase 4 من [snap_lens_delivery_pipeline.md](snap_lens_delivery_pipeline.md).
- يكمله **snap_009** (VFX/Audio - §5،6)، **snap_010** (تحقّق الحجم/الأداء)، **snap_012** (التصدير/النشر §7).
- يلتزم [Senior_Agent_Operating_Standard.md](Senior_Agent_Operating_Standard.md) والدرس المسجّل feedback_lensstudio_gui_automation.
- يُحدَّث بعد كل مشروع عدسة (تحسين مستمر).
