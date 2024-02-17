#!/bin/bash

# Tentukan lokasi repositori lokal dan URL repositori remote
REPO_DIR="/mnt/c/Users/User/Documents/repo"
REMOTE_REPO_URL="https://oauth2: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@github.com/USU-Official/onedata-frontend"
BRANCH="main"
# Pergi ke direktori repositori lokal
cd "$REPO_DIR"

# Periksa apakah direktori tersebut ada dan merupakan repositori git
if [ -d ".git" ]; then
  echo "Repositori ditemukan. Memeriksa perubahan..."

  # Ambil perubahan terbaru dari repositori remote tanpa merge atau rebase
  git fetch

  # Bandingkan HEAD lokal dengan HEAD remote
  LOCAL=$(git rev-parse @)
  REMOTE=$(git rev-parse @{u})
  echo $LOCAL

  if [ $LOCAL != $REMOTE ]; then
    echo "Terdapat perubahan. Melakukan clone ulang..."

    # Kembali ke direktori sebelumnya dan hapus repositori lama
    cd ..
    rm -rf "$REPO_DIR"

    # Clone repositori dari awal
    git clone "$REMOTE_REPO_URL" "$REPO_DIR" -b "$BRANCH"
    echo "Clone berhasil dilakukan."
    cd $REPO_DIR
    docker build --no-cache -t 172.30.68.223:5000/prod-fe-usu:$LOCAL . 
    docker push 172.30.68.223:5000/prod-fe-usu:$LOCAL
    docker service update 172.30.68.223:5000/prod-fe-usu:$LOCAL --image onedata-fe
  else
    echo "Tidak ada perubahan."
  fi
else
  echo "Direktori tidak ditemukan atau bukan repositori git. Melakukan clone..."

  # Clone repositori jika direktori tidak ada atau bukan repositori git
   git clone "$REMOTE_REPO_URL" "$REPO_DIR" -b "$BRANCH"
  echo "Clone berhasil dilakukan."
fi
