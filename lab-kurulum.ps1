<#
.SYNOPSIS
    Okul lab bilgisayarlari icin otomatik konfigurasyon araci.

.DESCRIPTION
    - LAB-01 ile LAB-06 arasinda lab gruplari olusturur
    - OgrenciXX kullanicilari olusturur (Standart kullanici - Admin degil)
    - Bilgisayar adini LAB-LL-BILXX formatinda degistirir
    - Windows Update'i tamamen kapatir
    - Mevcut kurulum tespiti yapar
    - CSV tabanli toplu yapilandirma destekler

.NOTES
    Kurum  : Emel-Ozgur Subasıay MTAL - Edirne
    Versiyon: 3.0
#>

# ============================================================
#  RENK PALETİ
# ============================================================
$C = @{
    Baslik  = "Cyan"
    Beyaz   = "White"
    Yesil   = "Green"
    Kirmizi = "Red"
    Sari    = "Yellow"
    Mavi    = "Blue"
    Gri     = "DarkGray"
    Magenta = "Magenta"
}

# ============================================================
#  YARDIMCI GORSEL FONKSİYONLAR
# ============================================================

function Show-Menu {
    Clear-Host
    Write-Host ""
    Write-Host "  ╔══════════════════════════════════════════════════╗" -ForegroundColor $C.Baslik
    Write-Host "  ║" -ForegroundColor $C.Baslik -NoNewline
    Write-Host "     ██╗      █████╗ ██████╗      " -ForegroundColor $C.Baslik -NoNewline
    Write-Host "     ║" -ForegroundColor $C.Baslik
    Write-Host "  ║" -ForegroundColor $C.Baslik -NoNewline
    Write-Host "     ██║     ██╔══██╗██╔══██╗     " -ForegroundColor $C.Baslik -NoNewline
    Write-Host "     ║" -ForegroundColor $C.Baslik
    Write-Host "  ║" -ForegroundColor $C.Baslik -NoNewline
    Write-Host "     ██║     ███████║██████╔╝     " -ForegroundColor $C.Baslik -NoNewline
    Write-Host "     ║" -ForegroundColor $C.Baslik
    Write-Host "  ║" -ForegroundColor $C.Baslik -NoNewline
    Write-Host "     ██║     ██╔══██║██╔══██╗     " -ForegroundColor $C.Baslik -NoNewline
    Write-Host "     ║" -ForegroundColor $C.Baslik
    Write-Host "  ║" -ForegroundColor $C.Baslik -NoNewline
    Write-Host "     ███████╗██║  ██║██████╔╝     " -ForegroundColor $C.Baslik -NoNewline
    Write-Host "     ║" -ForegroundColor $C.Baslik
    Write-Host "  ║" -ForegroundColor $C.Baslik -NoNewline
    Write-Host "     ╚══════╝╚═╝  ╚═╝╚═════╝      " -ForegroundColor $C.Baslik -NoNewline
    Write-Host "     ║" -ForegroundColor $C.Baslik
    Write-Host "  ╠══════════════════════════════════════════════════╣" -ForegroundColor $C.Baslik
    Write-Host "  ║" -ForegroundColor $C.Baslik -NoNewline
    Write-Host "      BİLGİSAYAR YAPILANDIRMA ARACI  v3.0       " -ForegroundColor $C.Beyaz -NoNewline
    Write-Host "║" -ForegroundColor $C.Baslik
    Write-Host "  ║" -ForegroundColor $C.Baslik -NoNewline
    Write-Host "    Emel-Özgür Subaşıay MTAL · Edirne           " -ForegroundColor $C.Gri -NoNewline
    Write-Host "║" -ForegroundColor $C.Baslik
    Write-Host "  ╚══════════════════════════════════════════════════╝" -ForegroundColor $C.Baslik
    Write-Host ""

    # Windows Update durumunu menüde göster
    $wuDurum = Get-WindowsUpdateStatus
    $wuRenk  = if ($wuDurum -eq "Kapali") { $C.Yesil } else { $C.Kirmizi }
    $wuIkon  = if ($wuDurum -eq "Kapali") { "🔒" } else { "🔓" }

    Write-Host "  ┌──────────────────────────────────────────────────┐" -ForegroundColor $C.Gri
    Write-Host "  │  " -NoNewline -ForegroundColor $C.Gri
    Write-Host "1" -NoNewline -ForegroundColor $C.Sari
    Write-Host "  │  Yeni ogrenci bilgisayari yapilandir        " -ForegroundColor $C.Beyaz
    Write-Host "  ├──────────────────────────────────────────────────┤" -ForegroundColor $C.Gri
    Write-Host "  │  " -NoNewline -ForegroundColor $C.Gri
    Write-Host "2" -NoNewline -ForegroundColor $C.Magenta
    Write-Host "  │  Kullanici sil (dosyalari ile beraber)      " -ForegroundColor $C.Beyaz
    Write-Host "  ├──────────────────────────────────────────────────┤" -ForegroundColor $C.Gri
    Write-Host "  │  " -NoNewline -ForegroundColor $C.Gri
    Write-Host "3" -NoNewline -ForegroundColor $C.Baslik
    Write-Host "  │  Bilgisayar bilgilerini topla (CSV)         " -ForegroundColor $C.Beyaz
    Write-Host "  ├──────────────────────────────────────────────────┤" -ForegroundColor $C.Gri
    Write-Host "  │  " -NoNewline -ForegroundColor $C.Gri
    Write-Host "4" -NoNewline -ForegroundColor $C.Yesil
    Write-Host "  │  CSV'den otomatik yapilandirma              " -ForegroundColor $C.Beyaz
    Write-Host "  ├──────────────────────────────────────────────────┤" -ForegroundColor $C.Gri
    Write-Host "  │  " -NoNewline -ForegroundColor $C.Gri
    Write-Host "5" -NoNewline -ForegroundColor $C.Mavi
    Write-Host "  │  Hizli otomatik yapilandirma (CSV kontrol)  " -ForegroundColor $C.Beyaz
    Write-Host "  ├──────────────────────────────────────────────────┤" -ForegroundColor $C.Gri
    Write-Host "  │  " -NoNewline -ForegroundColor $C.Gri
    Write-Host "6" -NoNewline -ForegroundColor $wuRenk
    Write-Host "  │  Windows Update: " -NoNewline -ForegroundColor $C.Beyaz
    Write-Host "$wuIkon $wuDurum" -ForegroundColor $wuRenk
    Write-Host "  ├──────────────────────────────────────────────────┤" -ForegroundColor $C.Gri
    Write-Host "  │  " -NoNewline -ForegroundColor $C.Gri
    Write-Host "0" -NoNewline -ForegroundColor $C.Kirmizi
    Write-Host "  │  Cikis                                      " -ForegroundColor $C.Beyaz
    Write-Host "  └──────────────────────────────────────────────────┘" -ForegroundColor $C.Gri
    Write-Host ""
}

function Write-Status {
    param([string]$Mesaj, [string]$Tip = "bilgi")
    switch ($Tip) {
        "ok"    { Write-Host "  ✔  $Mesaj" -ForegroundColor $C.Yesil }
        "hata"  { Write-Host "  ✘  $Mesaj" -ForegroundColor $C.Kirmizi }
        "uyari" { Write-Host "  ⚠  $Mesaj" -ForegroundColor $C.Sari }
        "bilgi" { Write-Host "  ℹ  $Mesaj" -ForegroundColor $C.Baslik }
        "isle"  { Write-Host "  ►  $Mesaj" -ForegroundColor $C.Magenta }
    }
}

function Show-StepHeader {
    param([int]$No, [int]$Toplam, [string]$Baslik)
    Write-Host ""
    Write-Host "  ┌─────────────────────────────────────────────────┐" -ForegroundColor $C.Gri
    Write-Host "  │  " -ForegroundColor $C.Gri -NoNewline
    Write-Host "Adım $No/$Toplam" -ForegroundColor $C.Sari -NoNewline
    Write-Host "  ·  " -ForegroundColor $C.Gri -NoNewline
    Write-Host "$Baslik" -ForegroundColor $C.Beyaz -NoNewline
    $pad = " " * [math]::Max(0, (38 - $Baslik.Length))
    Write-Host "$pad│" -ForegroundColor $C.Gri
    Write-Host "  └─────────────────────────────────────────────────┘" -ForegroundColor $C.Gri
    Write-Host ""
}

function Show-Loading {
    param([string]$Mesaj)
    Write-Host "  ►  $Mesaj " -ForegroundColor $C.Magenta -NoNewline
    1..3 | ForEach-Object { Start-Sleep -Milliseconds 250; Write-Host "." -ForegroundColor $C.Magenta -NoNewline }
    Write-Host ""
}

function Show-SectionHeader {
    param([string]$Baslik, [string]$Renk = "Cyan")
    Write-Host ""
    Write-Host "  ╔══════════════════════════════════════════════════╗" -ForegroundColor $Renk
    Write-Host "  ║  " -ForegroundColor $Renk -NoNewline
    Write-Host "$Baslik" -NoNewline -ForegroundColor $C.Beyaz -BackgroundColor DarkBlue
    $pad = " " * [math]::Max(0, (47 - $Baslik.Length))
    Write-Host "$pad║" -ForegroundColor $Renk
    Write-Host "  ╚══════════════════════════════════════════════════╝" -ForegroundColor $Renk
    Write-Host ""
}

function Show-ResultBox {
    param([bool]$Basarili)
    Write-Host ""
    if ($Basarili) {
        Write-Host "  ╔══════════════════════════════════════════════════╗" -ForegroundColor $C.Yesil
        Write-Host "  ║                                                  ║" -ForegroundColor $C.Yesil
        Write-Host "  ║        ✔  IŞLEM BAŞARIYLA TAMAMLANDI!            ║" -ForegroundColor $C.Yesil
        Write-Host "  ║                                                  ║" -ForegroundColor $C.Yesil
        Write-Host "  ╚══════════════════════════════════════════════════╝" -ForegroundColor $C.Yesil
    } else {
        Write-Host "  ╔══════════════════════════════════════════════════╗" -ForegroundColor $C.Kirmizi
        Write-Host "  ║                                                  ║" -ForegroundColor $C.Kirmizi
        Write-Host "  ║        ✘  IŞLEM TAMAMLANAMADI!                   ║" -ForegroundColor $C.Kirmizi
        Write-Host "  ║        Lütfen hataları kontrol edin.             ║" -ForegroundColor $C.Kirmizi
        Write-Host "  ║                                                  ║" -ForegroundColor $C.Kirmizi
        Write-Host "  ╚══════════════════════════════════════════════════╝" -ForegroundColor $C.Kirmizi
    }
    Write-Host ""
}

function Show-SummaryBox {
    param([string]$GrupAdi, [string]$BilgisayarAdi, [string]$KullaniciAdi, [bool]$WUKapat = $true)
    $wuMetin = if ($WUKapat) { "Kapatilacak" } else { "Degistirilmeyecek" }
    $wuRenk  = if ($WUKapat) { $C.Kirmizi } else { $C.Gri }

    Write-Host "  ╔══════════════════════════════════════════════════╗" -ForegroundColor $C.Sari
    Write-Host "  ║           YAPILACAK İŞLEMLER                     ║" -ForegroundColor $C.Sari
    Write-Host "  ╠══════════════════════════════════════════════════╣" -ForegroundColor $C.Sari

    $items = @(
        @{ Ikon="🏷 "; Etiket="Grup adı      "; Deger=$GrupAdi },
        @{ Ikon="🖥 "; Etiket="Bilgisayar adı"; Deger=$BilgisayarAdi },
        @{ Ikon="👤 "; Etiket="Kullanıcı     "; Deger=$KullaniciAdi },
        @{ Ikon="🔐 "; Etiket="Yetki seviyesi"; Deger="Standart Kullanici (Users)" }
    )
    foreach ($item in $items) {
        Write-Host "  ║  " -ForegroundColor $C.Sari -NoNewline
        Write-Host "$($item.Ikon) $($item.Etiket) :  " -ForegroundColor $C.Gri -NoNewline
        $pad = " " * [math]::Max(0, (20 - $item.Deger.Length))
        Write-Host "$($item.Deger)$pad" -ForegroundColor $C.Yesil -NoNewline
        Write-Host "  ║" -ForegroundColor $C.Sari
    }

    Write-Host "  ║  " -ForegroundColor $C.Sari -NoNewline
    Write-Host "🔒 Windows Update  :  " -ForegroundColor $C.Gri -NoNewline
    $pad = " " * [math]::Max(0, (20 - $wuMetin.Length))
    Write-Host "$wuMetin$pad" -ForegroundColor $wuRenk -NoNewline
    Write-Host "  ║" -ForegroundColor $C.Sari
    Write-Host "  ╚══════════════════════════════════════════════════╝" -ForegroundColor $C.Sari
    Write-Host ""
}

# ============================================================
#  YARDIMCI LOJİK FONKSİYONLAR
# ============================================================

function Get-ValidatedInput {
    param([string]$Prompt, [int]$Min, [int]$Max)
    while ($true) {
        Write-Host "  ❯ " -ForegroundColor $C.Baslik -NoNewline
        $input = Read-Host $Prompt
        if ([string]::IsNullOrWhiteSpace($input)) {
            Write-Status "Boş bırakılamaz!" "hata"; continue
        }
        $number = 0
        if (-not [int]::TryParse($input, [ref]$number)) {
            Write-Status "Sadece sayı giriniz!" "hata"; continue
        }
        if ($number -lt $Min -or $number -gt $Max) {
            Write-Status "$Min ile $Max arasında bir sayı giriniz!" "hata"; continue
        }
        return $number
    }
}

function Format-TwoDigit {
    param([int]$Number)
    return $Number.ToString("00")
}

function Test-LocalGroupExists {
    param([string]$GroupName)
    try { Get-LocalGroup -Name $GroupName -ErrorAction Stop | Out-Null; return $true }
    catch { return $false }
}

function Test-LocalUserExists {
    param([string]$UserName)
    try { Get-LocalUser -Name $UserName -ErrorAction Stop | Out-Null; return $true }
    catch { return $false }
}

function Test-IsConfigured {
    # Bilgisayar adı LAB-XX-BILXX formatında mı?
    return $env:COMPUTERNAME -match '^LAB-\d{2}-BIL\d{2}$'
}

function Get-ExistingConfig {
    $config = @{ BilgisayarAdi = $env:COMPUTERNAME; Kullanici = ""; WUDurum = "" }

    # Mevcut Ogrenci kullanıcısını bul
    $ogrenci = Get-LocalUser | Where-Object { $_.Name -match '^Ogrenci\d{2}$' } | Select-Object -First 1
    if ($ogrenci) { $config.Kullanici = $ogrenci.Name }

    $config.WUDurum = Get-WindowsUpdateStatus
    return $config
}

function Get-StudentUsers {
    $systemUsers = @('Administrator','Guest','DefaultAccount','WDAGUtilityAccount')
    try {
        return Get-LocalUser | Where-Object {
            $_.Name -match '^Ogrenci\d{2}$' -and $_.Name -notin $systemUsers
        } | Sort-Object Name
    } catch {
        Write-Status "Kullanıcılar listelenemedi: $_" "hata"
        return @()
    }
}

function Get-ComputerInfo {
    $info = @{}
    try {
        $info.ComputerName = $env:COMPUTERNAME
        $adapter = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' -and $_.PhysicalMediaType -ne 'Unspecified' } | Select-Object -First 1
        $info.MACAddress    = if ($adapter) { $adapter.MacAddress } else { "Bulunamadi" }
        $info.SerialNumber  = try { (Get-WmiObject Win32_BIOS -EA Stop).SerialNumber } catch { "Bulunamadi" }
        $info.IPAddress     = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -notlike "*Loopback*" -and $_.IPAddress -notlike "169.254.*" } | Select-Object -First 1).IPAddress
        if (-not $info.IPAddress) { $info.IPAddress = "Bulunamadi" }
        $info.WindowsVersion  = (Get-CimInstance Win32_OperatingSystem).Caption
        $info.CollectionDate  = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        return $info
    } catch {
        Write-Status "Bilgisayar bilgileri toplanamadı: $_" "hata"
        return $null
    }
}

# ============================================================
#  WINDOWS UPDATE FONKSİYONLARI
# ============================================================

function Get-WindowsUpdateStatus {
    try {
        $svc = Get-Service -Name wuauserv -ErrorAction SilentlyContinue
        if ($svc -and $svc.StartType -eq 'Disabled') { return "Kapali" }

        $regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
        if (Test-Path $regPath) {
            $val = Get-ItemProperty -Path $regPath -Name "NoAutoUpdate" -ErrorAction SilentlyContinue
            if ($val -and $val.NoAutoUpdate -eq 1) { return "Kapali" }
        }
        return "Acik"
    } catch { return "Bilinmiyor" }
}

function Disable-WindowsUpdate {
    Show-SectionHeader "WINDOWS UPDATE YÖNETIMI"

    $mevcutDurum = Get-WindowsUpdateStatus
    Write-Host "  Mevcut durum: " -NoNewline -ForegroundColor $C.Beyaz
    if ($mevcutDurum -eq "Kapali") {
        Write-Host "🔒 KAPALI" -ForegroundColor $C.Yesil
        Write-Host ""
        Write-Status "Windows Update zaten kapalı." "uyari"
        return $true
    } else {
        Write-Host "🔓 AÇIK" -ForegroundColor $C.Kirmizi
    }

    Write-Host ""
    Show-Loading "Windows Update kapatılıyor"

    try {
        # wuauserv servisini durdur ve devre dışı bırak
        Stop-Service -Name wuauserv -Force -EA SilentlyContinue
        Set-Service  -Name wuauserv -StartupType Disabled -EA Stop
        Write-Status "wuauserv servisi devre dışı bırakıldı." "ok"

        # UsoSvc (Update Orchestrator) kapat
        Stop-Service -Name UsoSvc -Force -EA SilentlyContinue
        Set-Service  -Name UsoSvc -StartupType Disabled -EA SilentlyContinue
        Write-Status "UsoSvc servisi devre dışı bırakıldı." "ok"

        # WaaSMedicSvc (Update Medic) registry üzerinden kapat
        $medicKey = "HKLM:\SYSTEM\CurrentControlSet\Services\WaaSMedicSvc"
        if (Test-Path $medicKey) {
            Set-ItemProperty -Path $medicKey -Name "Start" -Value 4 -EA SilentlyContinue
            Write-Status "WaaSMedicSvc devre dışı bırakıldı." "ok"
        }

        # Grup politikası registry anahtarı
        $wuKey = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
        if (-not (Test-Path $wuKey)) { New-Item -Path $wuKey -Force | Out-Null }
        Set-ItemProperty -Path $wuKey -Name "NoAutoUpdate"              -Value 1 -Type DWord
        Set-ItemProperty -Path $wuKey -Name "AUOptions"                 -Value 1 -Type DWord
        Set-ItemProperty -Path $wuKey -Name "NoAutoRebootWithLoggedOnUsers" -Value 1 -Type DWord
        Write-Status "Grup politikası ayarları uygulandı." "ok"

        Write-Host ""
        Write-Status "Windows Update tamamen kapatıldı." "ok"
        return $true
    } catch {
        Write-Status "Windows Update kapatılamadı: $($_.Exception.Message)" "hata"
        return $false
    }
}

# ============================================================
#  ANA İŞLEM FONKSİYONLARI
# ============================================================

function New-LabGroup {
    param([string]$GroupName)
    if (Test-LocalGroupExists -GroupName $GroupName) {
        Write-Status "'$GroupName' grubu zaten mevcut." "uyari"
        return $true
    }
    try {
        New-LocalGroup -Name $GroupName -Description "Lab $GroupName bilgisayarlari grubu" -EA Stop | Out-Null
        Write-Status "'$GroupName' grubu oluşturuldu." "ok"
        return $true
    } catch {
        Write-Status "Grup oluşturulamadı: $_" "hata"
        return $false
    }
}

function New-StudentUser {
    param([string]$UserName)
    if (Test-LocalUserExists -UserName $UserName) {
        Write-Status "'$UserName' kullanıcısı zaten mevcut." "uyari"
        return $true
    }
    try {
        New-LocalUser -Name $UserName -NoPassword -FullName "Ogrenci $UserName" `
            -Description "Lab ogrenci hesabi" -EA Stop | Out-Null
        Write-Status "'$UserName' kullanıcısı şifresiz oluşturuldu." "ok"
        return $true
    } catch {
        Write-Status "Kullanıcı oluşturulamadı: $_" "hata"
        return $false
    }
}

function Add-UserToGroup {
    param([string]$UserName, [string]$GroupName)
    try {
        $members = Get-LocalGroupMember -Group $GroupName -EA SilentlyContinue
        if ($members.Name -contains "$env:COMPUTERNAME\$UserName") {
            Write-Status "'$UserName' zaten '$GroupName' grubunda." "uyari"
            return $true
        }
        Add-LocalGroupMember -Group $GroupName -Member $UserName -EA Stop
        Write-Status "'$UserName' kullanıcısı '$GroupName' grubuna eklendi." "ok"
        return $true
    } catch {
        Write-Status "Kullanıcı gruba eklenemedi: $_" "hata"
        return $false
    }
}

function Set-ComputerNameSafely {
    param([string]$NewName)
    if ($env:COMPUTERNAME -eq $NewName) {
        Write-Status "Bilgisayar adı zaten '$NewName'." "uyari"
        return $true
    }
    try {
        Rename-Computer -NewName $NewName -Force -EA Stop | Out-Null
        Write-Status "Bilgisayar adı '$NewName' olarak değiştirildi. (Yeniden başlatmada aktif)" "ok"
        return $true
    } catch {
        Write-Status "Bilgisayar adı değiştirilemedi: $_" "hata"
        return $false
    }
}

function Remove-StudentUser {
    param([string]$UserName)
    if ($UserName -notmatch '^Ogrenci\d{2}$') {
        Write-Status "Güvenlik: Sadece 'OgrenciXX' formatındaki kullanıcılar silinebilir!" "hata"
        return $false
    }
    if (-not (Test-LocalUserExists -UserName $UserName)) {
        Write-Status "'$UserName' kullanıcısı bulunamadı!" "hata"
        return $false
    }

    $profilePath = "C:\Users\$UserName"
    Write-Host ""
    Write-Host "  ┌─────────────────────────────────────────────────┐" -ForegroundColor $C.Sari
    Write-Host "  │  " -ForegroundColor $C.Sari -NoNewline
    Write-Host "SİLİNECEK BİLGİLER" -ForegroundColor $C.Beyaz
    Write-Host "  ├─────────────────────────────────────────────────┤" -ForegroundColor $C.Sari
    Write-Host "  │  Kullanıcı adı  : " -ForegroundColor $C.Beyaz -NoNewline
    Write-Host $UserName -ForegroundColor $C.Baslik
    Write-Host "  │  Profil klasörü : " -ForegroundColor $C.Beyaz -NoNewline
    Write-Host $profilePath -ForegroundColor $C.Baslik
    Write-Host "  └─────────────────────────────────────────────────┘" -ForegroundColor $C.Sari
    Write-Host ""
    Write-Status "Bu işlem GERİ ALINAMAZ! Tüm dosyalar silinecek!" "uyari"
    Write-Host ""

    Write-Host "  ❯ " -ForegroundColor $C.Baslik -NoNewline
    $onay = Read-Host "Silme işlemini onaylıyor musunuz? (E/H)"
    if ($onay -notmatch '^[Ee]$') {
        Write-Status "İşlem iptal edildi." "uyari"
        return $false
    }

    try {
        Remove-LocalUser -Name $UserName -EA Stop
        Write-Status "'$UserName' kullanıcısı silindi." "ok"
        if (Test-Path $profilePath) {
            Show-Loading "Profil klasörü siliniyor"
            Remove-Item -Path $profilePath -Recurse -Force -EA Stop
            Write-Status "Profil klasörü silindi." "ok"
        }
        return $true
    } catch {
        Write-Status "Silme işlemi başarısız: $_" "hata"
        return $false
    }
}

function Invoke-Configuration {
    param(
        [string]$GroupName,
        [string]$ComputerName,
        [string]$UserName,
        [bool]$WUKapat = $true
    )

    $success = $true

    Show-Loading "Lab grubu oluşturuluyor"
    if (-not (New-LabGroup -GroupName $GroupName))           { $success = $false }

    Show-Loading "Öğrenci kullanıcısı oluşturuluyor"
    if (-not (New-StudentUser -UserName $UserName))          { $success = $false }

    if ($success) {
        Show-Loading "Kullanıcı Lab grubuna ekleniyor"
        if (-not (Add-UserToGroup -UserName $UserName -GroupName $GroupName)) { $success = $false }

        # Users grubu (S-1-5-32-545) — Admin DEĞİL
        Show-Loading "Kullanıcı standart Users grubuna ekleniyor"
        if (-not (Add-UserToGroup -UserName $UserName -GroupName "Users")) { $success = $false }
    }

    Show-Loading "Bilgisayar adı ayarlanıyor"
    if (-not (Set-ComputerNameSafely -NewName $ComputerName)) { $success = $false }

    if ($WUKapat) {
        Show-Loading "Windows Update kapatılıyor"
        if (-not (Disable-WindowsUpdate)) { $success = $false }
    }

    return $success
}

function Request-Restart {
    param([string]$ComputerName)
    if ($env:COMPUTERNAME -ne $ComputerName) {
        Write-Host ""
        Write-Status "Bilgisayar adının geçerli olması için yeniden başlatma gerekiyor!" "uyari"
        Write-Host ""
        Write-Host "  ❯ " -ForegroundColor $C.Baslik -NoNewline
        $restart = Read-Host "Şimdi yeniden başlatmak istiyor musunuz? (E/H)"
        if ($restart -match '^[Ee]$') {
            shutdown /r /t 10 /c "Lab yapilandirma sonrasi yeniden baslatma"
        } else {
            Write-Status "Lütfen daha sonra sistemi yeniden başlatın." "bilgi"
        }
    }
}

# ============================================================
#  MENÜ SEÇENEKLERİ
# ============================================================

function Start-LabConfiguration {
    Show-SectionHeader "YENİ ÖĞRENCİ BİLGİSAYARI YAPILANDIRMA"

    # Mevcut kurulum kontrolü
    if (Test-IsConfigured) {
        $config = Get-ExistingConfig
        Write-Host "  ╔══════════════════════════════════════════════════╗" -ForegroundColor $C.Sari
        Write-Host "  ║       ⚠  MEVCUT KURULUM TESPİT EDİLDİ!          ║" -ForegroundColor $C.Sari
        Write-Host "  ╠══════════════════════════════════════════════════╣" -ForegroundColor $C.Sari
        Write-Host "  ║  🖥  Bilgisayar adı  :  " -ForegroundColor $C.Sari -NoNewline
        $pad = " " * [math]::Max(0, (22 - $config.BilgisayarAdi.Length))
        Write-Host "$($config.BilgisayarAdi)$pad" -ForegroundColor $C.Yesil -NoNewline
        Write-Host "  ║" -ForegroundColor $C.Sari
        Write-Host "  ║  👤  Kullanıcı       :  " -ForegroundColor $C.Sari -NoNewline
        $ku = if ($config.Kullanici) { $config.Kullanici } else { "Bulunamadi" }
        $pad = " " * [math]::Max(0, (22 - $ku.Length))
        Write-Host "$ku$pad" -ForegroundColor $C.Yesil -NoNewline
        Write-Host "  ║" -ForegroundColor $C.Sari
        Write-Host "  ║  🔒  Windows Update  :  " -ForegroundColor $C.Sari -NoNewline
        $wuRenk = if ($config.WUDurum -eq "Kapali") { $C.Yesil } else { $C.Kirmizi }
        $pad = " " * [math]::Max(0, (22 - $config.WUDurum.Length))
        Write-Host "$($config.WUDurum)$pad" -ForegroundColor $wuRenk -NoNewline
        Write-Host "  ║" -ForegroundColor $C.Sari
        Write-Host "  ╠══════════════════════════════════════════════════╣" -ForegroundColor $C.Sari
        Write-Host "  ║  [1]  Yeniden yapılandır                         ║" -ForegroundColor $C.Beyaz
        Write-Host "  ║  [2]  İptal et ve çık                            ║" -ForegroundColor $C.Beyaz
        Write-Host "  ╚══════════════════════════════════════════════════╝" -ForegroundColor $C.Sari
        Write-Host ""
        Write-Host "  ❯ " -ForegroundColor $C.Baslik -NoNewline
        $secim = Read-Host "Seçiminiz"
        if ($secim -ne "1") {
            Write-Status "İşlem iptal edildi." "uyari"
            return
        }
    }

    Show-StepHeader 1 2 "Lab Numarası"
    Write-Host "  Örnek: " -ForegroundColor $C.Gri -NoNewline
    Write-Host "1 → Lab-01   2 → Lab-02   6 → Lab-06" -ForegroundColor $C.Sari
    Write-Host ""
    $labNo = Get-ValidatedInput -Prompt "Lab numarasını girin (1-6)" -Min 1 -Max 6
    $labNoF = Format-TwoDigit $labNo
    Write-Status "Lab adı: LAB-$labNoF" "ok"

    Show-StepHeader 2 2 "Bilgisayar Numarası"
    Write-Host "  Örnek: " -ForegroundColor $C.Gri -NoNewline
    Write-Host "1 → Bil01   10 → Bil10   24 → Bil24" -ForegroundColor $C.Sari
    Write-Host ""
    $bilNo = Get-ValidatedInput -Prompt "Bilgisayar numarasını girin (1-99)" -Min 1 -Max 99
    $bilNoF = Format-TwoDigit $bilNo

    $groupName    = "LAB-$labNoF"
    $computerName = "LAB-$labNoF-BIL$bilNoF"
    $userName     = "Ogrenci$bilNoF"

    Write-Status "Bilgisayar adı: $computerName" "ok"
    Write-Host ""

    Show-SummaryBox -GrupAdi $groupName -BilgisayarAdi $computerName -KullaniciAdi $userName -WUKapat $true

    Write-Host "  ❯ " -ForegroundColor $C.Baslik -NoNewline
    $onay = Read-Host "Devam etmek istiyor musunuz? (E/H)"
    if ($onay -notmatch '^[Ee]$') {
        Write-Status "İşlem iptal edildi." "uyari"
        return
    }

    Write-Host ""
    $success = Invoke-Configuration -GroupName $groupName -ComputerName $computerName -UserName $userName -WUKapat $true
    Show-ResultBox -Basarili $success
    if ($success) { Request-Restart -ComputerName $computerName }
}

function Start-UserRemoval {
    Show-SectionHeader "KULLANICI SİLME" "Red"

    $studentUsers = Get-StudentUsers
    if ($studentUsers.Count -eq 0) {
        Write-Status "Silinebilecek öğrenci kullanıcısı bulunamadı." "uyari"
        return
    }

    Write-Host "  ┌──────────────────────────────────────────────────┐" -ForegroundColor $C.Sari
    Write-Host "  │  SİLİNEBİLİR KULLANICILAR                        │" -ForegroundColor $C.Sari
    Write-Host "  └──────────────────────────────────────────────────┘" -ForegroundColor $C.Sari
    Write-Host ""

    $index = 1
    $userList = @()
    foreach ($user in $studentUsers) {
        Write-Host "  " -NoNewline
        Write-Host "[$index]" -NoNewline -ForegroundColor $C.Baslik
        Write-Host "  $($user.Name)" -ForegroundColor $C.Beyaz
        $userList += $user.Name
        $index++
    }
    Write-Host ""
    Write-Host "  " -NoNewline
    Write-Host "[0]" -NoNewline -ForegroundColor $C.Kirmizi
    Write-Host "  İptal" -ForegroundColor $C.Gri
    Write-Host ""

    $choice = Get-ValidatedInput -Prompt "Silinecek kullanıcıyı seçin (0-$($studentUsers.Count))" -Min 0 -Max $studentUsers.Count
    if ($choice -eq 0) { Write-Status "İşlem iptal edildi." "uyari"; return }

    $userName = $userList[$choice - 1]
    $success  = Remove-StudentUser -UserName $userName
    Show-ResultBox -Basarili $success
}

function Export-ComputerInfo {
    param([string]$FilePath = "")
    Show-SectionHeader "BİLGİSAYAR BİLGİLERİNİ TOPLAMA"

    $info = Get-ComputerInfo
    if ($null -eq $info) { Write-Status "Bilgisayar bilgileri toplanamadı!" "hata"; return $false }

    if ([string]::IsNullOrWhiteSpace($FilePath)) {

        $macFile  = $info.MACAddress -replace ':', '-'
        $FilePath = Join-Path $PSScriptRoot "bilgisayar-$macFile.csv"
    }

    Write-Host "  📁 Dosya: " -ForegroundColor $C.Baslik -NoNewline
    Write-Host $FilePath -ForegroundColor $C.Sari
    Write-Host ""

    $record = [PSCustomObject]@{
        MACAddress      = $info.MACAddress
        SerialNumber    = $info.SerialNumber
        ComputerName    = $info.ComputerName
        IPAddress       = $info.IPAddress
        WindowsVersion  = $info.WindowsVersion
        CollectionDate  = $info.CollectionDate
        LabNumber       = ""
        ComputerNumber  = ""
        Status          = "Beklemede"
    }

    $record | Export-Csv -Path $FilePath -Encoding UTF8 -NoTypeInformation

    Write-Host "  ┌─────────────────────────────────────────────────┐" -ForegroundColor $C.Yesil
    Write-Host "  │  TOPLANAN BİLGİLER                               │" -ForegroundColor $C.Yesil
    Write-Host "  ├─────────────────────────────────────────────────┤" -ForegroundColor $C.Yesil
    foreach ($kv in @(
        @{K="MAC Adresi    "; V=$info.MACAddress},
        @{K="Seri No       "; V=$info.SerialNumber},
        @{K="Bilgisayar Adı"; V=$info.ComputerName},
        @{K="IP Adresi     "; V=$info.IPAddress},
        @{K="Windows       "; V=$info.WindowsVersion}
    )) {
        Write-Host "  │  $($kv.K) : " -ForegroundColor $C.Beyaz -NoNewline
        Write-Host $kv.V -ForegroundColor $C.Baslik
    }
    Write-Host "  └─────────────────────────────────────────────────┘" -ForegroundColor $C.Yesil
    Write-Host ""
    Write-Status "Bilgiler kaydedildi: $FilePath" "ok"
    Write-Host ""
    Write-Host "  📝 Sonraki adımlar:" -ForegroundColor $C.Sari
    Write-Host "     1. Tüm bilgisayarlardan CSV dosyalarını toplayın" -ForegroundColor $C.Beyaz
    Write-Host "     2. Tüm CSV'leri birleştirin (bilgisayar-listesi.csv)" -ForegroundColor $C.Beyaz
    Write-Host "     3. LabNumber ve ComputerNumber sütunlarını doldurun" -ForegroundColor $C.Beyaz
    Write-Host "     4. Dosyayı her bilgisayarın masaüstüne kopyalayın" -ForegroundColor $C.Beyaz
    Write-Host "     5. Her bilgisayarda Seçenek 4 veya 5'i kullanın" -ForegroundColor $C.Beyaz
    return $true
}

function Import-AndConfigureFromCSV {
    param([string]$FilePath = "")
    Show-SectionHeader "CSV'DEN OTOMATİK YAPILANDIRMA"

    if ([string]::IsNullOrWhiteSpace($FilePath)) {
        $FilePath = Join-Path ($PSScriptRoot) "bilgisayar-listesi.csv"
    }

    Write-Host "  📁 CSV: " -ForegroundColor $C.Baslik -NoNewline
    Write-Host $FilePath -ForegroundColor $C.Sari
    Write-Host ""

    if (-not (Test-Path $FilePath)) {
        Write-Status "CSV dosyası bulunamadı: $FilePath" "hata"
        return $false
    }

    try { $computers = Import-Csv -Path $FilePath -Encoding UTF8 }
    catch { Write-Status "CSV okunamadı: $_" "hata"; return $false }

    $currentInfo = Get-ComputerInfo
    if ($null -eq $currentInfo) { return $false }

    $current = $computers | Where-Object { $_.MACAddress -eq $currentInfo.MACAddress }
    if (-not $current) {
        Write-Status "Bu bilgisayar CSV'de bulunamadı! MAC: $($currentInfo.MACAddress)" "hata"
        return $false
    }

    if ([string]::IsNullOrWhiteSpace($current.LabNumber) -or [string]::IsNullOrWhiteSpace($current.ComputerNumber)) {
        Write-Status "Bu bilgisayar için Lab ve Bilgisayar numarası atanmamış!" "uyari"
        return $false
    }

    $labNo = 0; $bilNo = 0
    if (-not ([int]::TryParse($current.LabNumber, [ref]$labNo)) -or $labNo -lt 1 -or $labNo -gt 6) {
        Write-Status "Geçersiz Lab numarası: $($current.LabNumber)" "hata"; return $false
    }
    if (-not ([int]::TryParse($current.ComputerNumber, [ref]$bilNo)) -or $bilNo -lt 1 -or $bilNo -gt 99) {
        Write-Status "Geçersiz Bilgisayar numarası: $($current.ComputerNumber)" "hata"; return $false
    }

    $labNoF  = Format-TwoDigit $labNo
    $bilNoF  = Format-TwoDigit $bilNo
    $group   = "LAB-$labNoF"
    $pcName  = "LAB-$labNoF-BIL$bilNoF"
    $user    = "Ogrenci$bilNoF"

    Show-SummaryBox -GrupAdi $group -BilgisayarAdi $pcName -KullaniciAdi $user -WUKapat $true

    Write-Host "  ❯ " -ForegroundColor $C.Baslik -NoNewline
    $onay = Read-Host "Devam etmek istiyor musunuz? (E/H)"
    if ($onay -notmatch '^[Ee]$') { Write-Status "İşlem iptal edildi." "uyari"; return $false }

    Write-Host ""
    $success = Invoke-Configuration -GroupName $group -ComputerName $pcName -UserName $user -WUKapat $true

    if ($success) {
        try {
            $computers | Where-Object { $_.MACAddress -eq $currentInfo.MACAddress } |
                    ForEach-Object { $_.Status = "Tamamlandi" }
            $computers | Export-Csv -Path $FilePath -Encoding UTF8 -NoTypeInformation
        } catch { Write-Status "CSV durumu güncellenemedi." "uyari" }
    }

    Show-ResultBox -Basarili $success
    if ($success) { Request-Restart -ComputerName $pcName }
    return $success
}

function Start-QuickAutoConfigure {
    param([string]$FilePath = "")
    Show-SectionHeader "HIZLI OTOMATİK YAPILANDIRMA"

    if ([string]::IsNullOrWhiteSpace($FilePath)) {
        $FilePath = Join-Path ($PSScriptRoot) "bilgisayar-listesi.csv"
    }

    Write-Host "  🔍 CSV dosyası kontrol ediliyor..." -ForegroundColor $C.Baslik
    Write-Host ""

    if (-not (Test-Path $FilePath)) {
        Write-Status "CSV dosyası bulunamadı: $FilePath" "hata"
        Write-Status "Önce Seçenek 3 ile bilgisayar bilgilerini toplayın." "bilgi"
        return $false
    }

    try { $computers = Import-Csv -Path $FilePath -Encoding UTF8 }
    catch { Write-Status "CSV okunamadı: $_" "hata"; return $false }

    $currentInfo = Get-ComputerInfo
    if ($null -eq $currentInfo) { return $false }

    $current = $computers | Where-Object { $_.MACAddress -eq $currentInfo.MACAddress }
    if (-not $current) {
        Write-Status "Bu bilgisayar CSV'de bulunamadı! MAC: $($currentInfo.MACAddress)" "hata"
        return $false
    }

    if ([string]::IsNullOrWhiteSpace($current.LabNumber) -or [string]::IsNullOrWhiteSpace($current.ComputerNumber)) {
        Write-Status "Lab ve Bilgisayar numarası atanmamış! CSV'yi doldurun." "uyari"
        return $false
    }

    $labNo = 0; $bilNo = 0
    if (-not ([int]::TryParse($current.LabNumber, [ref]$labNo)) -or $labNo -lt 1 -or $labNo -gt 6) {
        Write-Status "Geçersiz Lab numarası." "hata"; return $false
    }
    if (-not ([int]::TryParse($current.ComputerNumber, [ref]$bilNo)) -or $bilNo -lt 1 -or $bilNo -gt 99) {
        Write-Status "Geçersiz Bilgisayar numarası." "hata"; return $false
    }

    $labNoF = Format-TwoDigit $labNo
    $bilNoF = Format-TwoDigit $bilNo
    $group  = "LAB-$labNoF"
    $pcName = "LAB-$labNoF-BIL$bilNoF"
    $user   = "Ogrenci$bilNoF"

    Write-Status "Bilgisayar CSV'de tanımlı!" "ok"
    Write-Host ""

    Show-SummaryBox -GrupAdi $group -BilgisayarAdi $pcName -KullaniciAdi $user -WUKapat $true
    Write-Host "  🚀 Otomatik yapılandırma başlatılıyor..." -ForegroundColor $C.Yesil
    Write-Host ""

    $success = Invoke-Configuration -GroupName $group -ComputerName $pcName -UserName $user -WUKapat $true

    if ($success) {
        try {
            $computers | Where-Object { $_.MACAddress -eq $currentInfo.MACAddress } |
                    ForEach-Object { $_.Status = "Tamamlandi" }
            $computers | Export-Csv -Path $FilePath -Encoding UTF8 -NoTypeInformation
        } catch { Write-Status "CSV durumu güncellenemedi." "uyari" }
    }

    Show-ResultBox -Basarili $success
    if ($success) { Request-Restart -ComputerName $pcName }
    return $success
}

# ============================================================
#  ANA PROGRAM
# ============================================================

function Start-Main {
    # Admin kontrolü
    if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
        exit
    }

    while ($true) {
        Show-Menu
        Write-Host "  ❯ " -ForegroundColor $C.Baslik -NoNewline
        $choice = Read-Host "Seçiminiz"

        switch ($choice) {
            "1" { Start-LabConfiguration;           Write-Host ""; Read-Host "  Devam etmek için Enter'a basın" }
            "2" { Start-UserRemoval;                Write-Host ""; Read-Host "  Devam etmek için Enter'a basın" }
            "3" { Export-ComputerInfo;              Write-Host ""; Read-Host "  Devam etmek için Enter'a basın" }
            "4" { Import-AndConfigureFromCSV;       Write-Host ""; Read-Host "  Devam etmek için Enter'a basın" }
            "5" { Start-QuickAutoConfigure;         Write-Host ""; Read-Host "  Devam etmek için Enter'a basın" }
            "6" { Disable-WindowsUpdate;            Write-Host ""; Read-Host "  Devam etmek için Enter'a basın" }
            "0" { Write-Status "Çıkış yapılıyor..." "bilgi"; Start-Sleep -Milliseconds 800; exit 0 }
            default {
                Write-Status "Geçersiz seçim! Lütfen 0-6 arasında bir sayı girin." "hata"
                Start-Sleep -Seconds 2
            }
        }
    }
}

Start-Main
