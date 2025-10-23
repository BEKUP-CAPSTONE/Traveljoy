# Traveljoy: Making travel a joy

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)
![Gemini](https://img.shields.io/badge/Gemini_API-8E75B2?style=for-the-badge&logo=google&logoColor=white)

**Traveljoy** adalah aplikasi mobile lintas platform yang dirancang untuk merevolusi cara wisatawan menjelajahi destinasi di Indonesia.

Proyek ini merupakan Capstone Project untuk program **BEKUP Create: Upskilling Bootcamp 2025** (ID Tim: B25-PG009), dengan tema "Inovasi Teknologi Untuk Digitalisasi Wisata Nusantara".

## 1. Latar Belakang & Masalah

Sektor pariwisata di Indonesia merupakan sektor penting, namun digitalisasinya masih terbatas. Sebagian besar aplikasi wisata yang ada saat ini hanya berfungsi sebagai katalog destinasi yang statis.

Wisatawan (terutama generasi muda) menginginkan pengalaman yang cepat, personal, dan interaktif, namun mereka masih harus menyusun jadwal secara manual. Ada kesenjangan antara kebutuhan akan layanan instan dan solusi digital yang ada.

**Traveljoy** hadir sebagai solusi untuk mengatasi masalah ini. Aplikasi ini bukan sekadar katalog, melainkan "asisten perjalanan digital yang cerdas, interaktif, dan menyenangkan" yang memanfaatkan kekuatan Generative AI (Gemini API) dan backend modern (Supabase).

## 2. Fitur Utama

Traveljoy dirancang untuk memberikan pengalaman wisata digital yang lengkap:

* **Rekomendasi & Itinerary Berbasis AI**: Menghasilkan rencana perjalanan dan narasi yang personal. Pengguna dapat memasukkan preferensi seperti durasi, gaya wisata, dan minat, dan Gemini API akan menyusun itinerary yang unik.
* **Eksplorasi Destinasi**: Menampilkan galeri destinasi wisata di seluruh Indonesia, dengan data yang bersumber dari Wonderful Indonesia.
* **Bookmark & Koleksi**: Pengguna dapat menyimpan destinasi atau itinerary favorit mereka untuk diakses kembali nanti.
* **Autentikasi Pengguna**: Sistem login dan manajemen pengguna yang aman menggunakan Supabase Auth.
* **Notifikasi Harian**: Fitur notifikasi untuk meningkatkan keterlibatan (engagement) pengguna.

## 3. Teknologi yang Digunakan

Proyek ini dibangun dengan fokus pada pengembangan frontend dan backend, menggunakan teknologi berikut:

| Kategori | Teknologi | Deskripsi |
| :--- | :--- | :--- |
| **Bahasa** | Dart | Bahasa pemrograman utama untuk Flutter. |
| **Framework** | Flutter | Membangun antarmuka aplikasi mobile lintas platform yang interaktif dan responsif. |
| **State Management** | Provider | Mengelola state dan alur data di dalam aplikasi Flutter. |
| **Backend & Database** | Supabase | Menyediakan layanan Autentikasi, Database (PostgreSQL), dan Storage (Bucket). |
| **Generative AI** | Gemini API (Google AI) | Menghasilkan itinerary dan narasi perjalanan yang personal berdasarkan input pengguna. |
| **Desain UI/UX** | Figma | Merancang desain awal (wireframes dan mockup) aplikasi. |
| **Kolaborasi** | GitHub & Google Suite | Menggunakan GitHub untuk version control serta Google Calendar & Meet untuk sinkronisasi tim. |
| **API Testing** | Postman | Membantu proses pengujian dan verifikasi API antara frontend dan backend. |

## 4. Tim Pengembang (B25-PG009)

Proyek ini dikerjakan oleh 4 anggota tim dengan pembagian tugas yang terstruktur:

### Frontend Developer
* **(BC25B001) - Khaizul Aftar**
  * Bertanggung jawab atas halaman Home, Detail Destinasi, dan Form Preferensi.
* **(BC25B005) - Taufiq Nurrohman**
  * Bertanggung jawab atas komponen reusable, navigasi (Provider), fitur Bookmark, dan Notifikasi.

### Backend Developer
* **(BC25B009) - Dimas Aswito**
  * Bertanggung jawab atas setup Supabase (Auth, Database), API internal, dan sistem penyimpanan Bookmark.
* **(BC25B002) - Muhammad Salman Alfarisy**
  * Bertanggung jawab atas arsitektur backend AI, integrasi Gemini API, dan penyempurnaan request itinerary.

---
*Proyek ini dibuat dalam jangka waktu 5 minggu sebagai bagian dari BEKUP Create 2025, bekerja sama dengan EKRAF dan Dicoding*.