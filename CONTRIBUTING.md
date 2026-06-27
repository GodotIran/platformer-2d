<div dir="rtl">

# راهنمای مشارکت در پروژه

به پروژه خوش اومدید! این سند فرآیند مشارکت رو توضیح می‌ده. لطفاً قبل از شروع هر کاری این راهنما رو بخوانید.

---

## ۱. چرخه مشارکت (GitHub Workflow)

### الف) فورک کردن (Fork)

1. به مخزن اصلی پروژه در GitHub بروید
2. روی دکمه **Fork** در بالای صفحه کلیک کنید
3. نسخه فورک‌شده را روی سیستم خودتان clone کنید:

```bash
git clone https://github.com/YOUR_USERNAME/REPO_NAME.git
cd REPO_NAME
```

---

### ب) ثبت کار (Issue)

> ⚠️ هیچ feature یا bugfix‌ای بدون Issue قبلی کدنویسی نشود.

1. در مخزن اصلی یک **Issue** جدید باز کنید
2. کار مورد نظر، منطق و نحوه پیاده‌سازی آن را واضح توضیح دهید
3. منتظر تأیید یا هماهنگی با تیم باشید، سپس شروع کنید

---

### ج) شاخه و Pull Request

برای هر کار یک **branch** جداگانه بسازید:

```bash
# ویژگی جدید
git checkout -b feature/double-jump

# رفع باگ
git checkout -b fix/player-crash
```

بعد از اتمام کار:

1. تغییرات را push کنید
2. یک **Pull Request** به سمت شاخه `master` در مخزن اصلی باز کنید
3. در توضیحات PR حتماً Issue مربوطه را لینک دهید:

```
Closes #12
```

4. حداقل یک نفر از تیم باید Review کند تا کد Merge شود

> راهنمای کامل: [Godot PR Workflow](https://docs.godotengine.org/en/stable/contributing/workflow/pr_workflow.html)

---

### د) تست اتوماتیک (CI)

پروژه از **gdUnit4** برای تست استفاده می‌کند:

- [gdUnit4 در GitHub](https://github.com/godot-gdunit-labs/gdUnit4)
- [ویدیو آموزشی تست در Godot](https://www.youtube.com/watch?v=CreugthdgJ0)

قبل از ارسال PR مطمئن شوید که تست‌های موجود pass می‌شوند.

---

## ۲. سازماندهی فایل‌ها

فایل‌ها بر اساس **feature** سازماندهی می‌شوند — صحنه و اسکریپت مرتبط کنار هم قرار می‌گیرند:

```
src/characters/player/
    player.tscn      ✅ کنار هم
    player.gd        ✅ کنار هم
```

**قوانین نام‌گذاری فایل و پوشه:**

| نوع | قرارداد | مثال |
|-----|---------|-------|
| فایل و پوشه | `snake_case` | `player_controller.gd` |
| متغیر و تابع | `snake_case` | `jump_force` |
| کلاس و نود | `PascalCase` | `PlayerController` |
| سیگنال | `snake_case` | `on_player_died` |
| ثابت | `SCREAMING_SNAKE_CASE` | `MAX_SPEED` |

> علت: ویندوز و لینوکس در حساسیت به حروف بزرگ/کوچک متفاوت عمل می‌کنند. نام‌گذاری یکدست از شکسته شدن مسیرها جلوگیری می‌کند.

> راهنمای کامل: [Godot Project Organization](https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html)

---

## ۳. استانداردهای کدنویسی (GDScript)

همه کدها باید از **[GDScript Style Guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html)** رسمی گودو پیروی کنند.

نکات کلیدی:

- indent با **Tab** (نه Space)
- یک خط خالی بین توابع
- ترتیب در هر اسکریپت: `class_name` ← `extends` ← سیگنال‌ها ← enum ← const ← var ← `_ready` ← `_process` ← توابع دیگر

**ابزار فرمت‌بندی خودکار:**

برای یکدستی کامل از افزونه **[GDScript Formatter](https://store.godotengine.org/asset/gdquest/gdscript-formatter/)** استفاده کنید. این افزونه کدها را به صورت خودکار بر اساس استانداردهای گودو فرمت می‌کند.

---

## ۴. قرارداد Commit

```
Add double jump mechanic
Fix player falling through floor
Update player HP bar UI
Remove unused audio files
```

- به **انگلیسی** باشد
- فعل در ابتدا (Add / Fix / Update / Remove)
- کوتاه و واضح

---

## ۵. قوانین کلی

- هیچ فایلی مستقیم روی شاخه `main` push نشود
- پوشه `.godot/` و فایل `export_presets.cfg` نباید commit شوند (در `.gitignore` هستند)
- همه asset های صوتی و تصویری باید تحت لایسنس آزاد (CC0 یا CC-BY) باشند
- قبل از شروع هر کار بزرگ با تیم هماهنگ کنید

---

سوالی دارید؟ یک Issue باز کنید یا در گروه تلگرام بپرسید.

</div>
