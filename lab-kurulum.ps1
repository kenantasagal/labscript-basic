# ============================================================
#  LAB BILGISAYAR KURULUM ARACI
#  Bilgisayar adini ayarlar ve ogrenci kullanicisi olusturur
# ============================================================

# --- Otomatik Admin Yukseltme ---
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# --- Yardimci Fonksiyonlar ---
function Baslik {
    Clear-Host
    Write-Host ""
    Write-Host "  ==========================================" -ForegroundColor Cyan
    Write-Host "     LAB BILGISAYAR KURULUM ARACI v1.0    " -ForegroundColor Cyan
    Write-Host "  ==========================================" -ForegroundColor Cyan
    Write-Host ""
}

function Durum($mesaj, $tip = "bilgi") {
    switch ($tip) {
        "ok"     { Write-Host "  [TAMAM]  $mesaj" -ForegroundColor Green }
        "hata"   { Write-Host "  [HATA]   $mesaj" -ForegroundColor Red }
        "uyari"  { Write-Host "  [UYARI]  $mesaj" -ForegroundColor Yellow }
        "bilgi"  { Write-Host "  [BİLGİ]  $mesaj" -ForegroundColor Cyan }
    }
}

# --- ANA PROGRAM ---
Baslik

# 1) ATELYE NUMARASI
Write-Host "  Adim 1/2 - Atelye Numarasi" -ForegroundColor White
Write-Host "  ----------------------------" -ForegroundColor DarkGray
do {
    Write-Host "  Ornek: 1 → Lab01,  2 → Lab02,  12 → Lab12" -ForegroundColor DarkGray
    $girdi_lab = Read-Host "  Atelye numarasini girin"
    $girdi_lab = $girdi_lab.Trim()
    if ($girdi_lab -notmatch '^\d{1,2}$') {
        Write-Host "  Gecersiz giris! Sadece 1-2 haneli sayi girin." -ForegroundColor Red
    }
} while ($girdi_lab -notmatch '^\d{1,2}$')

$lab_no  = $girdi_lab.PadLeft(2, '0')
$lab_adi = "Lab$lab_no"
Write-Host "  Atelye adi : " -NoNewline; Write-Host $lab_adi -ForegroundColor Green
Write-Host ""

# 2) BILGISAYAR NUMARASI
Write-Host "  Adim 2/2 - Bilgisayar Numarasi" -ForegroundColor White
Write-Host "  ---------------------------------" -ForegroundColor DarkGray
do {
    Write-Host "  Ornek: 1 → Bil01,  2 → Bil02,  10 → Bil10" -ForegroundColor DarkGray
    $girdi_bil = Read-Host "  Bilgisayar numarasini girin"
    $girdi_bil = $girdi_bil.Trim()
    if ($girdi_bil -notmatch '^\d{1,2}$') {
        Write-Host "  Gecersiz giris! Sadece 1-2 haneli sayi girin." -ForegroundColor Red
    }
} while ($girdi_bil -notmatch '^\d{1,2}$')

$bil_no       = $girdi_bil.PadLeft(2, '0')
$bil_adi      = "Bil$bil_no"
$pc_adi       = "$lab_adi-$bil_adi"
$ogrenci_adi  = "Ogrenci$bil_no"

Write-Host "  Bilgisayar adi: " -NoNewline; Write-Host $bil_adi -ForegroundColor Green
Write-Host ""

# --- OZET ---
Write-Host "  ==========================================" -ForegroundColor DarkGray
Write-Host "  Yapilacak Islemler:" -ForegroundColor White
Write-Host "    Bilgisayar adi  →  " -NoNewline; Write-Host $pc_adi -ForegroundColor Yellow
Write-Host "    Yeni kullanici  →  " -NoNewline; Write-Host $ogrenci_adi -ForegroundColor Yellow
Write-Host "  ==========================================" -ForegroundColor DarkGray
Write-Host ""

$onay = Read-Host "  Devam etmek istiyor musunuz? (E/H)"
if ($onay -notin @("e","E","evet","Evet","EVET")) {
    Write-Host ""
    Durum "Islem iptal edildi." "uyari"
    Write-Host ""
    Read-Host "  Cikmak icin Enter'a basin"
    exit 0
}

Write-Host ""
Write-Host "  Islemler yurutüluyor..." -ForegroundColor White
Write-Host ""

# --- BILGISAYAR ADINI DEGISTIR ---
try {
    $mevcut_ad = $env:COMPUTERNAME
    if ($mevcut_ad -eq $pc_adi) {
        Durum "Bilgisayar adi zaten '$pc_adi' olarak ayarli." "uyari"
    } else {
        Rename-Computer -NewName $pc_adi -Force -ErrorAction Stop
        Durum "Bilgisayar adi '$pc_adi' olarak ayarlandi. (Yeniden baslatmada aktif olur)" "ok"
    }
} catch {
    Durum "Bilgisayar adi degistirilemedi: $($_.Exception.Message)" "hata"
}

# --- OGRENCI KULLANICISI OLUSTUR ---
try {
    $mevcut = Get-LocalUser -Name $ogrenci_adi -ErrorAction SilentlyContinue
    if ($mevcut) {
        Durum "'$ogrenci_adi' kullanicisi zaten mevcut, atlanıyor." "uyari"
    } else {
        New-LocalUser `
            -Name              $ogrenci_adi `
            -NoPassword        `
            -FullName          $ogrenci_adi `
            -Description       "Ogrenci Hesabi - $lab_adi" `
            -PasswordNeverExpires $true `
            -ErrorAction       Stop | Out-Null

        Add-LocalGroupMember -Group "Users" -Member $ogrenci_adi -ErrorAction SilentlyContinue

        Durum "'$ogrenci_adi' kullanicisi sifresiz olarak olusturuldu." "ok"
    }
} catch {
    Durum "Kullanici olusturulamadi: $($_.Exception.Message)" "hata"
}

# --- BITIS ---
Write-Host ""
Write-Host "  ==========================================" -ForegroundColor Cyan
Write-Host "  Kurulum tamamlandi!" -ForegroundColor Green
Write-Host "  Bilgisayar adinin aktif olmasi icin" -ForegroundColor White
Write-Host "  sistemi yeniden baslatin." -ForegroundColor White
Write-Host "  ==========================================" -ForegroundColor Cyan
Write-Host ""

$yeniden = Read-Host "  Simdi yeniden baslatmak ister misiniz? (E/H)"
if ($yeniden -in @("e","E","evet","Evet","EVET")) {
    Restart-Computer -Force
}

Read-Host "  Cikmak icin Enter'a basin"
