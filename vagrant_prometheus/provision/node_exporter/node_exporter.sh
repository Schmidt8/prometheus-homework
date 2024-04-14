#!/bin/bash

# Az operációs rendszer frissítése
#echo "Operációs rendszer frissítése..."
#sudo dnf update -y

# Python3 és pip telepítése, ha még nincs telepítve
echo "Python3 és pip telepítése..."
sudo dnf install -y python3 python3-pip

# A pip frissítése a legújabb verzióra
#echo "pip frissítése..."
#pip3 install --upgrade pip

# passlib könyvtár telepítése
echo "passlib könyvtár telepítése pip-pel..."
pip3 install passlib

echo "A szükséges csomagok telepítése sikeresen befejeződött."
