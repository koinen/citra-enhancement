# Image Enhancer

## Nama dan Deskripsi Singkat Program

**Image Enhancer v1.0** adalah aplikasi MATLAB berbasis App Designer untuk melakukan peningkatan kualitas citra digital. Program menyediakan beberapa metode pemrosesan citra, yaitu:

- transformasi intensitas, yang mendukung
    - negative
    - log transform
    - power-law/gamma
    - contrast stretching
- histogram equalization
- histogram matching menggunakan citra referensi
- spatial filtering, baik filter linear maupun filter median.

Program dapat digunakan untuk citra grayscale maupun citra RGB. Histogram, statistik citra, serta hasil enhancement ditampilkan melalui antarmuka aplikasi.

## Dependensi

Program memerlukan:

- MATLAB R2019b atau versi yang lebih baru
- **Image Processing Toolbox**, yang digunakan untuk validasi dan pembanding dengan hasil implementasi histogram sendiri 
- **App Designer**, yang tersedia sebagai bagian dari MATLAB untuk menjalankan antarmuka `app.mlapp`.

Tidak ada package MATLAB eksternal yang perlu diinstal. Kode utama berada di folder `src`, sedangkan contoh citra tersedia di folder `data`.

## Tata Cara Menjalankan Program

### Menjalankan melalui `main.m`

1. Buka proyek ini di MATLAB.
2. Ubah **Current Folder** ke folder `src` pada proyek.

   ```text
   .../citra-enhancement/src
   ```

3. Jalankan perintah berikut pada Command Window MATLAB:

   ```matlab
   main
   ```

   File `main.m` akan menambahkan folder `src/app` ke MATLAB path dan membuka aplikasi.

### Membuka App Designer secara langsung

Alternatifnya, buka file berikut melalui MATLAB:

```text
src/app/app.mlapp
```

Kemudian klik **Run** pada App Designer.

### Menggunakan aplikasi

1. Muat citra yang akan diproses melalui tombol **Load Image**.
2. Pilih strategi enhancement yang diinginkan.
3. Isi parameter metode jika tersedia.
4. Untuk histogram matching, muat juga citra referensi.
5. Klik **Enhance** untuk menjalankan pemrosesan.
6. Lanjutkan proses enhancement dengan teknik lainnya, atau jika ingin ulang, klik tombol **Start Over** pada pop-up result.

Format citra yang didukung oleh komponen pemrosesan adalah citra grayscale atau RGB bertipe `uint8` dengan rentang intensitas 0 sampai 255. Contoh data dapat ditemukan pada folder `data/Kasus 1` sampai `data/Kasus 4` dan `data/Histogram Citra`.

## Dibuat Oleh
- David Bakti Lodianto / 13520383
- Lutfi Hakim Yusra / 13523084