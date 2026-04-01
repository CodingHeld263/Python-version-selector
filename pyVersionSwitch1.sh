#!/bin/bash
 
set -e  # Skript bei Fehler sofort beenden
 
echo "================================================"
echo "  Python Multi-Version Setup"
echo "================================================"
 
# System aktualisieren
echo ""
echo "[1/5] System aktualisieren..."
sudo apt update
sudo apt install -y software-properties-common
 
# deadsnakes PPA hinzufügen
echo ""
echo "[2/5] deadsnakes PPA hinzufügen..."
sudo add-apt-repository -y ppa:deadsnakes/ppa
sudo apt update
sudo apt upgrade -y
 
# Python-Versionen installieren
echo ""
echo "[3/5] Python-Versionen installieren..."
VERSIONS=(3.10 3.11 3.12 3.13 3.14)
 
for VERSION in "${VERSIONS[@]}"; do
    echo "  -> Installiere python${VERSION}..."
    sudo apt install -y "python${VERSION}" || echo "  [WARNUNG] python${VERSION} konnte nicht installiert werden, wird übersprungen."
done
 
# update-alternatives registrieren
echo ""
echo "[4/5] update-alternatives konfigurieren..."
PRIORITY=1
for VERSION in "${VERSIONS[@]}"; do
    BIN="/usr/bin/python${VERSION}"
    if [ -f "$BIN" ]; then
        sudo update-alternatives --install /usr/bin/python3 python3 "$BIN" "$PRIORITY"
        echo "  -> python${VERSION} registriert (Priorität ${PRIORITY})"
        ((PRIORITY++))
    else
        echo "  [WARNUNG] $BIN nicht gefunden, wird übersprungen."
    fi
done
 
# Default-Version interaktiv auswählen
echo ""
echo "[5/5] Standard-Version auswählen:"
sudo update-alternatives --config python3
 
echo ""
echo "================================================"
echo "  Fertig! Aktive Version:"
python3 --version
echo "================================================"