# Port Registry — مرجع Ports المشاريع
**المرجع:** P031
**النهج:** Random port assignment — لا ports ثابتة لتفادي التعارض مع مشاريع الاختبار.

---

## المشاريع المسجّلة (دائمة)

| المشروع | Backend | Frontend | DB Port | DB Name |
|---------|---------|----------|---------|---------|
| FahadCompanyConst | 8000 | 3000 | 5432 | fahadconst_db |
| TVTCMedical | 8002 | 3002 | 5434 | tvtc_medical_db |
| ShipmentSharingLoad | 8010 | 3010 | 5440 | shipment_db |
| EducationPlatformUNI | 8001 | 3001 | 5433 | education_db |
| HotelEnterprise | 8482 | 3460 | 5866 | hotel_enterprise_db |
| HospitalityPlatform | 8364 | 3721 | 5998 | hospitality_db |

---

## آلية تعيين الـ Ports — Random Assignment

### الخطوة 0 (إلزامية قبل أي مشروع جديد)

**شغّل هذا السكريبت للحصول على ports متاحة:**

```powershell
# C:\Users\fahad\OneDrive\Desktop\AgentsSnapBlenderAutoCAD\protocols\find_free_ports.ps1
# يجد 3 ports عشوائية متاحة في نطاقات منفصلة

function Get-FreePort {
    param([int]$RangeStart, [int]$RangeEnd)
    $used = (netstat -ano | Select-String "LISTENING" | 
             ForEach-Object { ($_ -split '\s+')[2] } | 
             ForEach-Object { ($_ -split ':')[-1] } | 
             Where-Object { $_ -match '^\d+$' } | 
             ForEach-Object { [int]$_ })
    $candidates = $RangeStart..$RangeEnd | Get-Random -Count 50
    foreach ($port in $candidates) {
        if ($port -notin $used) { return $port }
    }
    throw "No free port found in range $RangeStart-$RangeEnd"
}

$backend  = Get-FreePort -RangeStart 8100 -RangeEnd 8999
$frontend = Get-FreePort -RangeStart 3100 -RangeEnd 3999
$db       = Get-FreePort -RangeStart 5500 -RangeEnd 5999

Write-Host ""
Write-Host "=== Ports المتاحة لمشروعك ==="
Write-Host "Backend  : $backend"
Write-Host "Frontend : $frontend"
Write-Host "DB       : $db"
Write-Host "================================"
Write-Host ""
Write-Host "أضفها في CLAUDE.md ثم سجّلها في port_registry.md"
```

---

## نطاقات الـ Ports

| النوع | المشاريع الدائمة | المشاريع المؤقتة/الاختبار |
|-------|----------------|--------------------------|
| Backend | 8000-8099 | 8100-8999 (عشوائي) |
| Frontend | 3000-3099 | 3100-3999 (عشوائي) |
| DB | 5432-5499 | 5500-5999 (عشوائي) |

---

## قواعد التعيين

```
① مشروع دائم (production/staging) → ports ثابتة في 8000-8099 / 3000-3099
② مشروع مؤقت/اختبار → ports عشوائية من النطاق العالي
③ دائماً شغّل find_free_ports.ps1 للتحقق من التوفر
④ سجّل الـ ports المُعيَّنة هنا فوراً (حتى المؤقتة)
⑤ عند حذف مشروع مؤقت → احذف سطره من الجدول
```

---

## قالب CLAUDE.md — قسم Ports

```markdown
## Ports
- Backend:  http://localhost:[BACKEND_PORT]
- Frontend: http://localhost:[FRONTEND_PORT]
- Database: postgresql://postgres:admin@localhost:[DB_PORT]/[DB_NAME]

## CORS Origins (backend)
BACKEND_CORS_ORIGINS=http://localhost:[FRONTEND_PORT],http://localhost:[FRONTEND_PORT+1],http://localhost:[FRONTEND_PORT+2]
```

---

## قالب .env

```bash
# backend/.env
DATABASE_URL=postgresql+asyncpg://postgres:admin@localhost:[DB_PORT]/[DB_NAME]
BACKEND_CORS_ORIGINS=http://localhost:[FE_PORT],http://localhost:[FE_PORT+1],http://localhost:[FE_PORT+2]
SECRET_KEY=your-secret-key

# frontend/.env.local
NEXT_PUBLIC_API_URL=http://localhost:[BACKEND_PORT]
```
