@echo off
cd /d "%~dp0"

echo === Vintage Story Mod-Creator ===
echo Projektordner: %~dp0
echo.

:: Prüfe ob Node.js vorhanden ist
where node >nul 2>&1
if %errorLevel% NEQ 0 (
    echo FEHLER: Node.js nicht gefunden!
    echo Bitte Setup.bat als Administrator ausführen oder Node.js manuell installieren:
    echo https://nodejs.org/de/download/
    pause
    exit /b 1
)

:: Installiere Abhängigkeiten falls node_modules fehlt
if not exist "node_modules" (
    echo node_modules nicht gefunden - installiere Abhängigkeiten...
    call npm install
    if %errorLevel% NEQ 0 (
        echo FEHLER: npm install fehlgeschlagen!
        echo Stelle sicher dass Node.js korrekt installiert ist.
        pause
        exit /b 1
    )
    echo Abhängigkeiten erfolgreich installiert.
    echo.
)

:: startup.log löschen damit nur der neue Start drin steht
if exist "startup.log" del "startup.log"

echo Starte Editor...
npm start
set EXIT_CODE=%errorLevel%

echo.
if %EXIT_CODE% NEQ 0 (
    echo Editor wurde mit Fehlercode %EXIT_CODE% beendet.
    if exist "startup.log" (
        echo.
        echo === Fehlerprotokoll (startup.log) ===
        type startup.log
    )
) else (
    echo Editor wurde normal beendet.
)

pause
