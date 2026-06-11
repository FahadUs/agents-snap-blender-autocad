# find_free_ports.ps1
# يجد ports عشوائية متاحة لمشروع جديد
# الاستخدام: .\find_free_ports.ps1
# الاستخدام مع نوع: .\find_free_ports.ps1 -ProjectType temp

param(
    [string]$ProjectType = "temp"  # "temp" = عشوائي عالي | "permanent" = ثابت منخفض
)

function Get-FreePort {
    param([int]$RangeStart, [int]$RangeEnd)

    $usedPorts = @()
    try {
        $usedPorts = (netstat -ano) |
            Select-String "LISTENING" |
            ForEach-Object { ($_ -split '\s+')[2] } |
            ForEach-Object { ($_ -split ':')[-1] } |
            Where-Object { $_ -match '^\d+$' } |
            ForEach-Object { [int]$_ }
    } catch {}

    $range = $RangeStart..$RangeEnd
    $shuffled = $range | Sort-Object { Get-Random }

    foreach ($port in $shuffled) {
        if ($port -notin $usedPorts) {
            return $port
        }
    }
    throw "لا يوجد port متاح في النطاق $RangeStart-$RangeEnd"
}

if ($ProjectType -eq "permanent") {
    $backendRange  = @(8000, 8099)
    $frontendRange = @(3000, 3099)
    $dbRange       = @(5432, 5499)
    $label         = "دائم"
} else {
    $backendRange  = @(8100, 8999)
    $frontendRange = @(3100, 3999)
    $dbRange       = @(5500, 5999)
    $label         = "مؤقت/اختبار"
}

try {
    $backend  = Get-FreePort -RangeStart $backendRange[0]  -RangeEnd $backendRange[1]
    $frontend = Get-FreePort -RangeStart $frontendRange[0] -RangeEnd $frontendRange[1]
    $db       = Get-FreePort -RangeStart $dbRange[0]       -RangeEnd $dbRange[1]

    Write-Host ""
    Write-Host "======================================"
    Write-Host "  Ports المتاحة ($label)"
    Write-Host "======================================"
    Write-Host "  Backend  : $backend"
    Write-Host "  Frontend : $frontend"
    Write-Host "  DB       : $db"
    Write-Host "======================================"
    Write-Host ""
    Write-Host "الخطوات التالية:"
    Write-Host "  1. سجّل هذه الـ ports في port_registry.md"
    Write-Host "  2. أضفها في CLAUDE.md تحت قسم Ports"
    Write-Host "  3. أنشئ .env بهذه القيم"
    Write-Host ""
    Write-Host "CORS Origins للـ backend:"
    Write-Host "  http://localhost:$frontend,http://localhost:$($frontend+1),http://localhost:$($frontend+2)"
    Write-Host ""
} catch {
    Write-Error "خطأ: $_"
    exit 1
}
