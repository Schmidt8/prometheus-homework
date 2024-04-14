#!/bin/bash
#https://grafana.com/docs/grafana/latest/setup-grafana/installation/redhat-rhel-fedora/
# Grafana telepítő script CentOS, RHEL, Fedora disztribúciókhoz

# Szükséges változók
GRAFANA_RPM_URL="https://dl.grafana.com/oss/release/grafana-10.4.1-1.x86_64.rpm"
GRAFANA_RPM_SHA256="59e61e6ad1eaa022c6739f1db892dbca996bc43424670151908cc8a31fb5fcdd"
TEMP_RPM_PATH="/tmp/grafana.rpm"

#Are we root?
if (( $EUID != 0 )); then
    echo "Please run it as root" | grep --color -E "\b(root|)\b|$"
    exit
fi

# SHA256 ellenőrzés
echo "SHA256 ellenőrzés a letöltött RPM fájlhoz..."
wget -O "$TEMP_RPM_PATH" "$GRAFANA_RPM_URL"
echo "${GRAFANA_RPM_SHA256} ${TEMP_RPM_PATH}" | sha256sum -c -
if [ $? -ne 0 ]; then
    echo "Hiba: Az SHA256 összeg nem egyezik!"
    exit 1
fi

# Grafana telepítése
echo "Grafana telepítése..."
sudo yum install -y "$TEMP_RPM_PATH"
if [ $? -ne 0 ]; then
    echo "Hiba a Grafana telepítése közben."
    exit 1
fi

# A letöltött RPM fájl törlése
rm "$TEMP_RPM_PATH"


# Systemd szolgáltatás beállítása
echo "A Grafana beállítása systemd szolgáltatásként..."
sudo systemctl daemon-reload
sudo systemctl enable grafana-server
sudo systemctl start grafana-server

# Ellenőrizzük, hogy a Grafana szolgáltatás fut-e
if systemctl is-active --quiet grafana-server; then
    echo "A Grafana sikeresen telepítve és elindítva. A Grafana elérhető a localhost:3000 címen (illetve 192.168.56.220) credentials: admin admin"
else
    echo "Hiba: A Grafana szolgáltatás nem indult el."
    exit 1
fi
