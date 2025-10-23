# Traveljoy: Making travel a joy

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)
![Gemini](https://img.shields.io/badge/Gemini_API-8E75B2?style=for-the-badge&logo=google&logoColor=white)

[cite_start]**Traveljoy** adalah aplikasi mobile lintas platform yang dirancang untuk merevolusi cara wisatawan menjelajahi destinasi di Indonesia[cite: 57, 91].

[cite_start]Proyek ini merupakan Capstone Project untuk program **BEKUP Create: Upskilling Bootcamp 2025** (ID Tim: B25-PG009) [cite: 3, 4][cite_start], dengan tema "Inovasi Teknologi Untuk Digitalisasi Wisata Nusantara"[cite: 5].

## 1. Latar Belakang & Masalah

[cite_start]Sektor pariwisata di Indonesia merupakan sektor penting [cite: 13][cite_start], namun digitalisasinya masih terbatas[cite: 13]. [cite_start]Sebagian besar aplikasi wisata yang ada saat ini hanya berfungsi sebagai katalog destinasi yang statis[cite: 14, 51].

[cite_start]Wisatawan (terutama generasi muda) menginginkan pengalaman yang cepat, personal, dan interaktif [cite: 51][cite_start], namun mereka masih harus menyusun jadwal secara manual[cite: 15]. [cite_start]Ada kesenjangan antara kebutuhan akan layanan instan dan solusi digital yang ada[cite: 15].

**Traveljoy** hadir sebagai solusi untuk mengatasi masalah ini. [cite_start]Aplikasi ini bukan sekadar katalog, melainkan "asisten perjalanan digital yang cerdas, interaktif, dan menyenangkan" [cite: 55] [cite_start]yang memanfaatkan kekuatan Generative AI (Gemini API) [cite: 30, 52] [cite_start]dan backend modern (Supabase)[cite: 30].

## 2. Fitur Utama

Traveljoy dirancang untuk memberikan pengalaman wisata digital yang lengkap:

* [cite_start]**Rekomendasi & Itinerary Berbasis AI**: Menghasilkan rencana perjalanan dan narasi yang personal[cite: 48]. [cite_start]Pengguna dapat memasukkan preferensi seperti durasi, gaya wisata, dan minat [cite: 47, 66][cite_start], dan Gemini API akan menyusun itinerary yang unik[cite: 87, 143].
* [cite_start]**Eksplorasi Destinasi**: Menampilkan galeri destinasi wisata di seluruh Indonesia [cite: 64][cite_start], dengan data yang bersumber dari Wonderful Indonesia[cite: 145, 146].
* [cite_start]**Bookmark & Koleksi**: Pengguna dapat menyimpan destinasi atau itinerary favorit mereka untuk diakses kembali nanti[cite: 72, 82, 92].
* [cite_start]**Autentikasi Pengguna**: Sistem login dan manajemen pengguna yang aman menggunakan Supabase Auth[cite: 76, 140].
* [cite_start]**Notifikasi Harian**: Fitur notifikasi untuk meningkatkan keterlibatan (engagement) pengguna[cite: 73, 92].

## 3. Teknologi yang Digunakan

[cite_start]Proyek ini dibangun dengan fokus pada pengembangan frontend dan backend[cite: 57], menggunakan teknologi berikut:

| Kategori | Teknologi | Deskripsi |
| :--- | :--- | :--- |
| **Bahasa** | Dart | [cite_start]Bahasa pemrograman utama untuk Flutter[cite: 126]. |
| **Framework** | Flutter | [cite_start]Membangun antarmuka aplikasi mobile lintas platform yang interaktif dan responsif[cite: 126, 132]. |
| **State Management** | Provider | [cite_start]Mengelola state dan alur data di dalam aplikasi Flutter[cite: 71, 132]. |
| **Backend & Database** | Supabase | [cite_start]Menyediakan layanan Autentikasi, Database (PostgreSQL), dan Storage (Bucket)[cite: 76, 140]. |
| **Generative AI** | Gemini API (Google AI) | [cite_start]Menghasilkan itinerary dan narasi perjalanan yang personal berdasarkan input pengguna[cite: 87, 143]. |
| **Desain UI/UX** | Figma | [cite_start]Merancang desain awal (wireframes dan mockup) aplikasi[cite: 105, 136]. |
| **Kolaborasi** | GitHub & Google Suite | [cite_start]Menggunakan GitHub untuk version control [cite: 149] [cite_start]serta Google Calendar & Meet untuk sinkronisasi tim[cite: 101, 147]. |
| **API Testing** | Postman | [cite_start]Membantu proses pengujian dan verifikasi API antara frontend dan backend[cite: 138]. |

## 4. Tim Pengembang (B25-PG009)

[cite_start]Proyek ini dikerjakan oleh 4 anggota tim dengan pembagian tugas yang terstruktur[cite: 58, 99]:

### Frontend Developer
* [cite_start]**(BC25B001) - Khaizul Aftar** [cite: 9]
    * [cite_start]Bertanggung jawab atas halaman Home, Detail Destinasi, dan Form Preferensi[cite: 64, 65, 66].
* [cite_start]**(BC25B005) - Taufiq Nurrohman** [cite: 10]
    * [cite_start]Bertanggung jawab atas komponen reusable, navigasi (Provider), fitur Bookmark, dan Notifikasi[cite: 70, 71, 72, 73].

### Backend Developer
* [cite_start]**(BC25B009) - Dimas Aswito** [cite: 11]
    * [cite_start]Bertanggung jawab atas setup Supabase (Auth, Database), API internal, dan sistem penyimpanan Bookmark[cite: 76, 77, 82].
* [cite_start]**(BC25B002) - Muhammad Salman Alfarisy** [cite: 8]
    * [cite_start]Bertanggung jawab atas arsitektur backend AI, integrasi Gemini API, dan penyempurnaan request itinerary[cite: 86, 87, 88].

---
[cite_start]*Proyek ini dibuat dalam jangka waktu 5 minggu [cite: 58] [cite_start]sebagai bagian dari BEKUP Create 2025, bekerja sama dengan BEKRAF dan Dicoding [cite: 1, 3, 19]*.