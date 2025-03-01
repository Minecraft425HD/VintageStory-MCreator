@echo off
setlocal EnableDelayedExpansion

echo === Vintage Story Mod-Creator Installation ===
echo.

:: Prüfe, ob als Admin ausgeführt
net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Fehler: Bitte fuehre diese Datei als Administrator aus!
    echo Rechtsklick auf install.bat -> "Als Administrator ausfuehren"
    pause
    exit /b 1
)

:: Schritt 1: PowerShell-Ausfuehrungsrichtlinie aendern
echo Schritt 1: Setze PowerShell-Richtlinie auf RemoteSigned...
powershell -Command "Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force"
powershell -Command "Get-ExecutionPolicy" > temp.txt
set /p POLICY=<temp.txt
del temp.txt
echo Aktuelle Richtlinie: %POLICY%
if "%POLICY%" NEQ "RemoteSigned" (
    echo Fehler: Richtlinie konnte nicht geaendert werden!
    pause
    exit /b 1
)
echo Erfolgreich gesetzt.

:: Schritt 2: Node.js und .NET SDK installieren (via Winget)
echo Schritt 2: Installiere Node.js und .NET SDK...
winget install -e --id OpenJS.NodeJS.LTS --silent
winget install -e --id Microsoft.DotNet.SDK.6 --silent
echo Pruefe Installation...
where node >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Fehler: Node.js konnte nicht installiert werden!
    pause
    exit /b 1
)
where dotnet >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Fehler: .NET SDK konnte nicht installiert werden!
    pause
    exit /b 1
)
echo Node.js und .NET SDK erfolgreich installiert.

:: Schritt 3: Projektverzeichnis erstellen
echo Schritt 3: Erstelle Projektverzeichnis...
set "PROJECT_DIR=%USERPROFILE%\Desktop\VIntagestory MCreator"
if exist "%PROJECT_DIR%" (
    echo Verzeichnis existiert bereits, ueberspringe...
) else (
    mkdir "%PROJECT_DIR%"
)
cd /d "%PROJECT_DIR%"

:: Schritt 4: Projekt initialisieren und Abhaengigkeiten installieren
echo Schritt 4: Initialisiere Projekt und installiere Abhaengigkeiten...
echo { "name": "vs-mod-creator", "version": "1.0.0", "main": "main.js", "scripts": { "start": "electron ." }, "dependencies": { "@electron/remote": "^2.1.2", "adm-zip": "^0.5.10", "blockly": "^10.4.3", "electron": "^27.0.0" } } > package.json
call npm install
echo Abhaengigkeiten installiert.

:: Schritt 5: main.js, index.html und lib kopieren
echo Schritt 5: Kopiere main.js, index.html und lib...
set "SOURCE_DIR=%~dp0"
if not exist "%SOURCE_DIR%main.js" (
    echo Fehler: main.js nicht im Download-Ordner gefunden!
    pause
    exit /b 1
)
if not exist "%SOURCE_DIR%index.html" (
    echo Fehler: index.html nicht im Download-Ordner gefunden!
    pause
    exit /b 1
)
if not exist "%SOURCE_DIR%lib" (
    echo Fehler: lib-Ordner nicht im Download-Ordner gefunden!
    pause
    exit /b 1
)
copy "%SOURCE_DIR%main.js" "%PROJECT_DIR%\main.js"
copy "%SOURCE_DIR%index.html" "%PROJECT_DIR%\index.html"
xcopy "%SOURCE_DIR%lib" "%PROJECT_DIR%\lib" /E /I /Y
echo Dateien und lib-Ordner erfolgreich kopiert.

:: Schritt 6: Fertig
echo.
echo === Installation abgeschlossen! ===
echo Das Tool wurde in %PROJECT_DIR% installiert.
echo Um es zu starten:
echo 1. Oeffne CMD und navigiere:
echo    cd %PROJECT_DIR%
echo 2. Starte das Tool:
echo    npm start
echo 3. Teste die Mod in Vintage Story:
echo    Kopiere mymod2.zip nach %%appdata%%\VintagestoryData\Mods
pause