��          �   %   �      `  !   a  !   �  #   �     �  ,   �          /  >   6  D   u  ;   �  �   �     �  %   �  #   �     
  $     "   2     U  ,   f  ,   �  %   �     �  )        .  c  ;     �	  �  �	  $   8  #   ]  &   �  "   �  .   �  "   �       G   $  U   l  E   �  �        �  $   �      �       %        ;     Y  $   k  )   �  -   �  &   �  )        9  w  I     �                                        	                                                                             
       %s: Argument expected after `%s'
 %s: Invalid --process value `%s'
 %s: Invalid process specifier `%s'
 %s: Subject not specified
 %s: Two arguments expected after `--detail'
 %s: Unexpected argument `%s'
 ACTION Authentication is needed to run `$(program)' as the super user Authentication is needed to run `$(program)' as user $(user.display) Authentication is required to run a program as another user Authentication is required to run the polkit example program Frobnicate (user=$(user), user.gecos=$(user.gecos), user.display=$(user.display), program=$(program), command_line=$(command_line)) BUS_NAME Close FD when the agent is registered Don't replace existing agent if any FD Only output information about ACTION Output detailed action information PID[,START_TIME] Register the agent for the owner of BUS_NAME Register the agent for the specified process Report bugs to: %s
%s home page: <%s> Run a program as another user Run the polkit example program Frobnicate Show version Usage:
  pkcheck [OPTION...]

Help Options:
  -h, --help                         Show help options

Application Options:
  -a, --action-id=ACTION             Check authorization to perform ACTION
  -u, --allow-user-interaction       Interact with the user if necessary
  -d, --details=KEY VALUE            Add (KEY, VALUE) to information about the action
  --enable-internal-agent            Use an internal authentication agent if necessary
  --list-temp                        List temporary authorizations for current session
  -p, --process=PID[,START_TIME,UID] Check authorization of specified process
  --revoke-temp                      Revoke all temporary authorizations for current session
  -s, --system-bus-name=BUS_NAME     Check authorization of owner of BUS_NAME
  --version                          Show version

Report bugs to: %s
%s home page: <%s>
 [--action-id ACTION] Project-Id-Version: polkit master
Report-Msgid-Bugs-To: https://gitlab.freedesktop.org/polkit/polkit/issues
PO-Revision-Date: 2020-03-31 20:21+0700
Last-Translator: Andika Triwidada <andika@gmail.com>
Language-Team: Indonesian <gnome-l10n-id@googlegroups.com>
Language: id
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Generator: Poedit 2.3
 %s: Argumen diharapkan setelah `%s'
 %s: kesalahan nilai --process `%s'
 %s: Kesalahan spesifikasi proses `%s'
 %s: Subyek tidak dispesifikasikan
 %s: Dua argumen diharapkan setelah `--detail'
 %s: argumen yang tak terduga `%s'
 ACTION Otentikasi dibutuhkan untuk menjalankan `$(program)' sebagai super user Otentikasi dibutuhkan untuk menjalankan `$(program)' sebagai pengguna $(user.display) Otentikasi diperlukan untuk menjalankan program sebagai pengguna lain Otentikasi dibutuhkan untuk menjalankan contoh program Frobnicate (user=$(user), user.gecos=$(user.gecos), user.display=$(user.display), program=$(program), command_line=$(command_line)) BUS_NAME Tutup FD ketika agen sudah terdaftar Jangan ganti agen yang sudah ada FD Hanya informasi keluaran tentang AKSI Informasi detil aksi keluaran PID,[,START_TIME] Daftarkan agen bagi pemilik BUS_NAME Daftarkan agen untuk proses yang spesifik Laporkan kutu ke: %s
halaman beranda %s: <%s> Jalankan program sebagai pengguna lain Jalankan contoh program polkit Frobnicate Tampilkan versi Penggunaan:
 pkcheck [PILIHAN...]

Bantuan Pilihan:
  -h, --help                         Show help options
Pilihan Aplikasi:
-a, --action-id=ACTION             Periksa otorisasi untuk melakukan ACTION
  -u, --allow-user-interaction       Berkomunikasi dengan pengguna jika dibutuhkan
  -d, --details=KEY VALUE            Tambahkan (KEY, VALUE) untuk informasi mengenai aksi
  --enable-internal-agent            Gunakan otentikasi agen internal jika dibutuhkan
  --list-temp                        Daftar otorisasi sementara untuk sesi ini
  -p, --process=PID[,START_TIME,UID] Periksa otorisasi untuk proses yang spesifik
  --revoke-temp                      Cabut semua otorisasi sementara untuk sesi saat ini
  -s, --system-bus-name=BUS_NAME     Periksa otorisasi bagi pemilik BUS_NAME
  --version                          Tampilkan versi

Laporkan kutu ke: %s
halaman beranda %s: <%s>
 [--action-id ACTION] 