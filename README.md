# 🪣 BaKet (Batam Market) - Mobile

BaKet adalah sebuah bentuk revolusi belanja elektronik yang berasal dari Kota Batam, dengan tujuan memudahkan akses ke perangkat teknologi terkini dengan harga yang sangat terjangkau. Kami menghadirkan aplikasi ini sebagai tempat berbelanja yang elegan dan mudah digunakan, dengan memastikan pengalaman belanja yang lancar dan transparan dan ulasan produk yang jujur dan terpercaya.

Lebih dari sekadar *e-commerce* biasa, BaKet juga memiliki komunitas yang mendukung pertumbuhan usaha lokal Batam, dengan menyediakan platform bagi penjual untuk menjangkau pasar yang lebih luas. Dengan BaKet, Anda dapat menikmati layanan purna jual yang handal, dengan tampilan yang mengedepankan pengalaman *user*, dan belanja teknologi berkualitas tinggi dengan harga yang membuat setiap rupiah Anda berharga. 

Bergabunglah dengan kami di BaKet dan rasakan kemudahan belanja elektronik yang menginspirasi gaya hidup digital Anda! 🤩

## 💁‍♂️ The People Behind Baket 💁‍♀️

- Daniel Liman (2306220753)
- Kukuh Cikal Yuntama (2306228390)
- Nayla Farah Nida (2306213426)
- Raden Ahmad Yasin Mahendra (2306215154)
- Valentino Kim Fernando (2306275771)

## 📑 Daftar Modul

### 🔐 Authentication 
Dikerjakan oleh: **Kukuh Cikal Yuntama**

Modul ini akan memiliki fitur:
- Halaman Registrasi
- Halaman Login
- Tombol Logout

    
### 📱 Product Catalogue
    
Dikerjakan oleh: **Valentino Kim Fernando, Nayla Farah Nida**

Modul ini akan memiliki fitur:
- Daftar Semua Produk
- Halaman Request Produk Baru
- Opsi Filter/Sort Product
- Search Product
- Review Product

### 🛒 Cart & Checkout
    
Dikerjakan oleh: **Valentino Kim Fernando, Nayla Farah Nida**

Modul ini akan memiliki fitur:
- Pemesanan produk
- Pemrosesan pesanan (*checkout*, status pemesanan, dll)
- Melihat keranjang (*cart*)
    
### 📝 Wishlist
    
Dikerjakan oleh: **Kukuh Cikal Yuntama**

Modul ini akan memiliki fitur:
- Menambahkan produk ke *wishlist*
- Menghapus produk dari *wishlist*
- Melihat daftar *wishlist*

### ✍️ Artikel/Blog
    
Dikerjakan oleh: **Raden Ahmad Yasin Mahendra**

Halaman artikel atau blog akan memuat berbagai informasi seputar dunia teknologi informasi, rekomendasi tempat wisata sekitar, dan hal-hal lainnya yang berhubungan dengan Kota Batam.

### 💬 Forum/Affiliate
    
Dikerjakan oleh: **Daniel Liman**

Halaman Forum akan berisi tempat diskusi sekaligus promosi produk *gadget* yang berhubungan dengan produk yang ada di BaKet maupun tidak. Forum ini bersifat bebas dan bisa memiliki topik apapun, asalkan berhubungan dengan Kota Batam ataupun teknologi.

## 🎭 Role

| Role | Available Actions | Perlu Login |
| ---- | ----------------- | ----------- |
| **Admin** | Mengakses seluruh page termasuk admin page | ✅ |
| **User** | Membeli, Merequest Barang, Memasukkan ulasan, dan memberikan Rating | ✅ |
| **Guest** | Hanya bisa melihat Produk, Detail Produk, Artikel dan Forum (tidak dapat berinteraksi) | ❌ |

## 🔃 Alur Pengintegrasian dengan Web Service

Pada project aplikasi mobile ini, kami memakai data yang sama dengan data yang ada di [situs web](https://baket.vercel.app) kami. Alur dalam pengintegrasian dengan web kami adalah sebagai berikut.

1. Membuat model dalam bahasa `Dart` untuk data-data yang kami gunakan dalam aplikasi ini.

    Kami memanfaatkan [Quicktype](https://app.quicktype.io/) untuk mengkonversi data JSON yang dikembalikan oleh server Django yang merubahnya menjadi class model pada bahasa Dart di Flutter.

2. Membuat `django-app` baru untuk mengurus logic autentikasi khusus untuk pengguna mobile, yaitu untuk autentikasi login, logout maupun registrasi akun baru.

3. Mengatur aplikasi kami untuk melakukan autentikasi dan menerima cookies pada server Django kami.

    Kami memakai bantuan package `pbp-django-auth` yang dibuat oleh tim asdos dan package `Provider` yang menyimpan cookies untuk nantinya dipakai di setiap request yang akan dilakukan dari dalam aplikasi kami. Kami juga berencana untuk memakai package `SharedPreferences`untuk menyimpan data dari `CookieRequest` yang kami miliki sehingga bisa dipakai walaupun aplikasi ditutup.

4. Membuat endpoints baru untuk mengambil, mengubah maupun menghapus (proses CRUD) dari data yang kami miliki di server Django.

    Kami berencana untuk memakai implementasi Django REST API pada server Django kami di `views.py` masing-masing untuk membantu aplikasi Flutter kami menerima data yang lebih lengkap dan sesuai dengan kebutuhan aplikasi kami.

## 📝 Berita Acara

Berikut progress dari kelompok kami yang disusun pada [spreadsheet](https://docs.google.com/spreadsheets/d/158wbq0bBDEsZio5lZCaf8CGNx0smFYjvmxRDKNaVJLw/edit?usp=sharing) ini.

<iframe src="https://docs.google.com/spreadsheets/d/158wbq0bBDEsZio5lZCaf8CGNx0smFYjvmxRDKNaVJLw/edit?usp=sharing" width="100%" height="500px"></iframe>