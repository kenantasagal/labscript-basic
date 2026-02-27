# 🖥 LAB Bilgisayar Yapılandırma Aracı

**Emel-Özgür Subaşıay Ticaret Mesleki ve Teknik Anadolu Lisesi**  
Edirne Merkez · Versiyon 3.0

---

## 📋 Genel Bakış

Windows 10/11 okul laboratuvarlarında bilgisayarları standart bir formatta yapılandıran PowerShell aracıdır. Image yüklendikten sonra her bilgisayarda çalıştırılır.

### Ne Yapar?

- Bilgisayara lab ve sıraya göre standart isim verir (`LAB-01-BIL03` gibi)
- Şifresiz öğrenci kullanıcısı oluşturur (`Ogrenci03` gibi)
- Öğrenciyi **standart kullanıcı** olarak ayarlar (program kuramaz, sistemi bozamaz)
- Windows Update'i tamamen kapatır (ağ trafiğini korur)
- Daha önce yapılandırılmış bilgisayarı otomatik olarak tespit eder
- CSV tabanlı toplu yapılandırmayı destekler

---

## 📁 Dosyalar

| Dosya | Açıklama |
|-------|----------|
| `lab-kurulum-v3.ps1` | Ana PowerShell scripti |
| `lab-kurulum-v3.bat` | Çift tıkla çalıştırma kısayolu |
| `README.md` | Bu doküman |

---

## 🚀 Kullanım

### Başlatma

`lab-kurulum-v3.bat` dosyasına **çift tıkla** — yönetici yetkisi otomatik istenir.

### Menü Seçenekleri

```
[1]  Yeni öğrenci bilgisayarı yapılandır
[2]  Kullanıcı sil (dosyalarıyla birlikte)
[3]  Bilgisayar bilgilerini topla (CSV)
[4]  CSV'den otomatik yapılandırma
[5]  Hızlı otomatik yapılandırma (CSV kontrol)
[6]  Windows Update durumu / kapat
[0]  Çıkış
```

---

## 📖 Seçenekler Detaylı

### [1] Yeni Öğrenci Bilgisayarı Yapılandır

Tek bilgisayarı manuel olarak yapılandırır.

1. `lab-kurulum-v3.bat` dosyasına çift tıkla
2. Menüden `1` seçeneğini seç
3. Lab numarasını gir (1-6)
4. Bilgisayar numarasını gir (1-99)
5. Özeti kontrol et ve onayla
6. İşlem tamamlandıktan sonra yeniden başlat

**Örnek:**

| Lab | Bilgisayar No | Bilgisayar Adı | Kullanıcı |
|-----|---------------|----------------|-----------|
| 1 | 1 | LAB-01-BIL01 | Ogrenci01 |
| 1 | 24 | LAB-01-BIL24 | Ogrenci24 |
| 4 | 10 | LAB-04-BIL10 | Ogrenci10 |

> ⚠️ Bilgisayar daha önce yapılandırılmışsa script bunu tespit eder ve mevcut ayarları gösterir.

---

### [2] Kullanıcı Sil

`OgrenciXX` formatındaki kullanıcıları profil klasörüyle birlikte siler.

> ⚠️ Bu işlem geri alınamaz. Onay istenir.

---

### [3] Bilgisayar Bilgilerini Topla (CSV)

Bilgisayarın MAC adresi, seri numarası, IP adresi ve Windows sürümü bilgilerini scriptin bulunduğu klasöre (USB) CSV olarak kaydeder.

**Toplu yapılandırma için iş akışı:**

```
Her bilgisayarda [3] çalıştır
        ↓
Tüm CSV dosyalarını bir klasörde topla
        ↓
CSV'leri tek dosyada birleştir → "bilgisayar-listesi.csv"
        ↓
LabNumber ve ComputerNumber sütunlarını doldur
        ↓
Dosyayı USB'deki script klasörüne koy
        ↓
Her bilgisayarda [4] veya [5] çalıştır
```

---

### [4] CSV'den Otomatik Yapılandırma

Masaüstündeki `bilgisayar-listesi.csv` dosyasını okur, bilgisayarı MAC adresiyle eşleştirir ve yapılandırır. Onay sorar.

---

### [5] Hızlı Otomatik Yapılandırma

Seçenek 4 ile aynı mantıkta çalışır fakat onay sormadan direkt yapılandırır. Toplu dağıtım için idealdir.

---

### [6] Windows Update Yönetimi

Windows Update servisini ve ilgili tüm bileşenleri tamamen kapatır.

**Kapatılan servisler:**
- `wuauserv` — Windows Update
- `UsoSvc` — Update Orchestrator
- `WaaSMedicSvc` — Update Medic (registry)

> ℹ️ Windows Update durumu ana menüde anlık olarak gösterilir.

---

## 🏫 Lab Yapısı

| Lab | Bölüm | Bilgisayar Adı Formatı |
|-----|-------|------------------------|
| Lab1 | Adalet | LAB-01-BIL01 ... LAB-01-BIL24 |
| Lab2 | Bilgisayar | LAB-02-BIL01 ... LAB-02-BIL24 |
| Lab3 | Muhasebe | LAB-03-BIL01 ... LAB-03-BIL24 |
| Lab4 | Bilgisayar (Win10) | LAB-04-BIL01 ... LAB-04-BIL24 |
| Lab5 | Büro Yönetimi | LAB-05-BIL01 ... LAB-05-BIL24 |
| Lab6 | Bilgisayar | LAB-06-BIL01 ... LAB-06-BIL24 |

---

## 👤 Kullanıcı Yetki Yapısı

| Hesap | Tür | Açıklama |
|-------|-----|----------|
| `Teknisyen` | Yönetici | BT sorumlusu — kurulum sırasında oluşturulur |
| `OgrenciXX` | Standart Kullanıcı | Öğrenci hesabı — program kuramaz |

> ℹ️ Öğrenci hesabı `Users` grubundadır. `Administrators` grubuna **eklenmez**.

---

## ⚙️ Gereksinimler

- Windows 10 / Windows 11
- PowerShell 5.1 veya üzeri
- Yönetici (Administrator) yetkisi — script otomatik olarak ister

---

## 🔧 Sorun Giderme

**Script açılmıyor:**  
PowerShell'i sağ tıklayıp "Yönetici olarak çalıştır" ile açın, ardından:
```powershell
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser
```

**Kullanıcı oluşturulamıyor:**  
Kullanıcı zaten mevcut olabilir. Script bunu tespit eder ve uyarır.

**Bilgisayar adı değişmedi:**  
Yeniden başlatma gereklidir. Script yeniden başlatma teklif eder.

**CSV'de bilgisayar bulunamıyor:**  
Önce Seçenek 3 ile bilgisayarın bilgilerini toplayın ve CSV'ye ekleyin.

**Windows Update tekrar açıldı:**  
Büyük Windows güncellemesi WaaSMedicSvc'yi sıfırlamış olabilir. Seçenek 6'yı tekrar çalıştırın.

---

## 📝 Notlar

- Script her çalıştırıldığında mevcut yapılandırmayı kontrol eder, çakışma olmaz
- CSV tabanlı yapılandırma FOG image dağıtımıyla birlikte kullanılabilir
- Tüm işlemler loglanmaz, gerekirse PowerShell transcript özelliği eklenebilir

---

*Emel-Özgür Subaşıay MTAL — BT Birimi · 2026*
