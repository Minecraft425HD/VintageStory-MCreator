@echo off
setlocal EnableDelayedExpansion

echo === Vintage Story Mod-Creator Installation ===
echo.

:: Check if running as admin
net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo error: Please run this file as administrator!
    echo Right click on install.bat -> "As an administrator"
    pause
    exit /b 1
)

:: Step 1: Change PowerShell execution policy
echo Step 1: Set to PowerShell policy RemoteSigned...
powershell -Command "Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force"
powershell -Command "Get-ExecutionPolicy" > temp.txt
set /p POLICY=<temp.txt
del temp.txt
echo Current policy: %POLICY%
if "%POLICY%" NEQ "RemoteSigned" (
    echo Error: Policy could not be chanded!
    pause
    exit /b 1
)
echo Successfully set.

:: Step 2: Install Node.js and .NET SDK (via Winget)
echo Step 2: Install Node.js and .NET SDK...
winget install -e --id OpenJS.NodeJS.LTS --silent
winget install -e --id Microsoft.DotNet.SDK.5 --silent
winget install -e --id Microsoft.DotNet.SDK.6 --silent
winget install -e --id Microsoft.DotNet.SDK.7 --silent
winget install -e --id Microsoft.DotNet.SDK.8 --silent
winget install -e --id Microsoft.DotNet.SDK.9 --silent
echo Test installation...
where node >nul 2>&1
if %errorLevel% NEQ 0 (
    echo error: Node.js could not be installed!
    pause
    exit /b 1
)
where dotnet >nul 2>&1
if %errorLevel% NEQ 0 (
    echo error: .NET SDK could not be installed!
    pause
    exit /b 1
)
echo Node.js and .NET SDK Successfully installed.

:: Step 3: Create project directory
echo Step 3: Create project directory...
set "PROJECT_DIR=%USERPROFILE%\Desktop\VIntagestory MCreator"
if exist "%PROJECT_DIR%" (
    echo Directory already exists, skip...
) else (
    mkdir "%PROJECT_DIR%"
)
cd /d "%PROJECT_DIR%"

:: Step 4: Initialize project and install dependences
echo Step 4: Initialize project and install dependences...
echo { "name": "vs-mod-creator", "version": "1.0.0", "main": "main.js", "scripts": { "start": "electron ." }, "dependencies": { "@electron/remote": "^2.1.2", "adm-zip": "^0.5.10", "blockly": "^10.4.3", "electron": "^27.0.0" } } > package.json
call npm install
echo Dependences installed.

:: Step 5: Copy main.js, index.html and lib
echo Step 5: Copy main.js, index.html and lib...
set "SOURCE_DIR=%~dp0"
if not exist "%SOURCE_DIR%main.js" (
    echo error: main.js Not found in the download folder!
    pause
    exit /b 1
)
if not exist "%SOURCE_DIR%index.html" (
    echo error: index.html Not found in the download folder!
    pause
    exit /b 1
)
if not exist "%SOURCE_DIR%lib" (
    echo error: Lib folder not found in the download folder!
    pause
    exit /b 1
)
copy "%SOURCE_DIR%main.js" "%PROJECT_DIR%\main.js"
copy "%SOURCE_DIR%index.html" "%PROJECT_DIR%\index.html"
xcopy "%SOURCE_DIR%lib" "%PROJECT_DIR%\lib" /E /I /Y
echo Files and lib folders successfully copied.

:: Step 6: Ready
echo.
echo === Installation completed! ===
echo The tool was installed in %PROJECT_DIR%.
echo To start it:
echo 1. Open CMD into the Modcreator folder and navigate:
echo    cd %PROJECT_DIR%
echo 2. Start the Tool:
echo    npm start
echo 3. Test the mod in Vintage Story:
echo    Copy mymod2.zip to %%appdata%%\VintagestoryData\Mods
pause
