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
    echo Error: Policy could not be changed!
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
set "PROJECT_DIR=%USERPROFILE%\Desktop\VintageStoryMCreator"
if exist "%PROJECT_DIR%" (
    echo Directory already exists, skip...
) else (
    mkdir "%PROJECT_DIR%"
)
cd /d "%PROJECT_DIR%"

:: Step 4: Copy main.js, index.html, package.json, VS-Mcreator.bat, start.html and lib
echo Step 4: Copy main.js, index.html, package.json, VS-Mcreator.bat, start.html and lib...
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
if not exist "%SOURCE_DIR%package.json" (
    echo error: package.json Not found in the download folder!
    pause
    exit /b 1
)
if not exist "%SOURCE_DIR%VS-Mcreator.bat" (
    echo error: VS-Mcreator.bat Not found in the download folder!
    pause
    exit /b 1
)
if not exist "%SOURCE_DIR%start.html" (
    echo error: start.html Not found in the download folder!
    pause
    exit /b 1
)
copy "%SOURCE_DIR%start.html" "%PROJECT_DIR%\start.html"
copy "%SOURCE_DIR%VS-Mcreator.bat" "%PROJECT_DIR%\VS-Mcreator.bat"
copy "%SOURCE_DIR%package.json" "%PROJECT_DIR%\package.json"
copy "%SOURCE_DIR%main.js" "%PROJECT_DIR%\main.js"
copy "%SOURCE_DIR%index.html" "%PROJECT_DIR%\index.html"
xcopy "%SOURCE_DIR%lib" "%PROJECT_DIR%\lib" /E /I /Y
echo Files and lib folders successfully copied.

:: Step 5: Initialize project and install dependencies
echo Step 5: Initialize project and install dependencies...
echo { "name": "vs-mod-creator", "version": "1.0.0", "main": "main.js", "scripts": { "start": "electron ." }, "dependencies": { "@electron/remote": "^2.1.2", "adm-zip": "^0.5.10", "blockly": "^10.4.3"[...]
call npm install
echo Dependencies installed.

:: Step 6: Set Environment Variable
echo Step 6: Set Environment Variable...
set "VINTAGE_STORY_PATH=%USERPROFILE%\AppData\Roaming\Vintagestory"
setx VINTAGE_STORY "%VINTAGE_STORY_PATH%" /M
if %errorLevel% NEQ 0 (
    echo error: Environment Variable could not be set!
    pause
    exit /b 1
)
echo Environment Variable VINTAGE_STORY set to %VINTAGE_STORY_PATH%.

:: Step 7: Ready
echo.
echo === Installation completed! ===
echo The tool was installed in %PROJECT_DIR%.
echo To start it:
echo 1. Go to VS Modcreator directory 
echo 2. Execute VS-Mcreator.bat
echo 3. Make your own VS mod and klick on compile
echo 4. Your mod.zip is saved into the Tools folder
echo 5. Test the mod in Vintage Story:
echo    Copy mymod2.zip to %%appdata%%\VintagestoryData\Mods
pause
