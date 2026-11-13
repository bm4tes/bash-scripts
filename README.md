# Bash CLI Games (`flip4` & `masterMind`)

Zwei interaktive Terminal-Spiele in reinem Bash – entwickelt aus Spaß an der Kommandozeile, ANSI-Terminal-Grafik und modularer Shell-Programmierung.

## Enthalten

### 1. Flip4 (`./flip4.sh`)

Eine Erweiterung von *Vier Gewinnt* für 2 bis 4 Spieler im Terminal:

* **Twist:** Statt einen Stein einzuwerfen, kann ein Spieler das gesamte Spielfeld vertikal umdrehen (`f`).
* **Spielstände:** Speichern (`s`) und Laden von Partien als `.saveGame`-Datei.
* **Initialsierung:**
    * Interaktiv Menu
    * **CLI-Optionen:** Direkter Start per Kommandozeilenparameter möglich:

        ```bash
        ./flip4.sh -p Alice -p Bob -c red -c yellow -r true
        ```

    * `-p <Name>`: Spieler hinzufügen (2–4 Spieler)
    * `-c <Farbe>`: Farbe zuweisen (`red`, `yellow`, `blue`, `green`)
    * `-w <Breite>` / `-h <Höhe>`: Spielfeldgröße anpassen (Standard: 8x6)
    * `-g <Anzahl>`: Benötigte Steine zum Gewinnen (Standard: 4)
    * `-r true`: Zugreihenfolge zufällig mischen


### 2. Mastermind (`./masterMind.sh`)

Der Klassiker zum Codeknacken im Terminal:

* Wahlweise eigener Geheimcode (2-Spieler-Modus) oder zufällig generierter Code (`r`) mit frei wählbarer Länge.
* Direkte Auswertung nach jedem Zug (● richtige Farbe & Position, ○ richtige Farbe).

### Bibliotheken (`./lib/`)

Modulare Hilfsfunktionen für eigene Bash-Skripte (u. a. ANSI-Farben, Array-Operationen, String-Verarbeitung, Eingabevalidierung, Abhängigkeits-Checks und Zeitstempel).

## Starten

```bash
git clone [https://github.com/bm4tes/bash-scripts.git](https://github.com/bm4tes/bash-scripts.git)
cd bash-scripts
chmod +x games/*.sh

./games/flip4.sh
# oder
./games/masterMind.sh
```

**Voraussetzungen:** Bash 4+, Standard-GNU-Coreutils (`tr`, `sort`, `uniq`, `rev`, `shuf`, `sed`, `awk`, `bc`).
