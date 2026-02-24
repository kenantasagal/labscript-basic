# Lab Bilgisayar Kurulum Aracı

Windows 11 okul laboratuvarlarında bilgisayar adını otomatik olarak ayarlayan ve öğrenci kullanıcısı oluşturan terminal aracı.

## Ne Yapar?

- Atelye ve bilgisayar numarasına göre bilgisayar adını ayarlar (`Lab01-Bil03` gibi)
- Şifresiz öğrenci kullanıcısı oluşturur (`Ogrenci03` gibi)

## Kullanım

1. `lab-kurulum.bat` dosyasına çift tıkla
2. Atelye numarasını gir (örnek: `1` → `Lab01`)
3. Bilgisayar numarasını gir (örnek: `3` → `Bil03`)
4. Özeti onayla
5. İşlem tamamlandıktan sonra yeniden başlat

## Örnekler

| Atelye | Bilgisayar | Bilgisayar Adı | Kullanıcı |
|--------|------------|----------------|-----------|
| 1      | 1          | Lab01-Bil01    | Ogrenci01 |
| 1      | 3          | Lab01-Bil03    | Ogrenci03 |
| 2      | 10         | Lab02-Bil10    | Ogrenci10 |

## Gereksinimler

- Windows 10 / 11
- Yönetici (Administrator) yetkisi

## Dosyalar

| Dosya | Açıklama |
|-------|----------|
| `lab-kurulum.ps1` | Ana PowerShell scripti |
| `lab-kurulum.bat` | Çift tıkla çalıştırma kısayolu |
