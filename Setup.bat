@echo off
setlocal EnableDelayedExpansion

echo === Vintage Story Mod-Creator Installation ===
echo.

:: Check if running as admin
net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo error: Please run this file as administrator!
    echo Right click on Setup.bat -> "Run as administrator"
    pause
    exit /b 1
)

:: Step 1: Change PowerShell execution policy
echo Step 1: Set PowerShell policy to RemoteSigned...
powershell -Command "Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force"
echo Successfully set.

:: Step 2: Install Node.js and .NET SDK (via Winget)
echo Step 2: Install Node.js and .NET SDK...
winget install -e --id OpenJS.NodeJS.LTS --silent
winget install -e --id Microsoft.DotNet.SDK.7 --silent
echo Checking installations...
where node >nul 2>&1
if %errorLevel% NEQ 0 (
    echo error: Node.js could not be installed! Please install it manually from https://nodejs.org
    pause
    exit /b 1
)
where dotnet >nul 2>&1
if %errorLevel% NEQ 0 (
    echo warning: .NET SDK not found. Mod compilation will not work without it.
    echo Download from: https://dotnet.microsoft.com/download
)
echo Node.js and .NET SDK check complete.

:: Step 3: Create project directory
echo Step 3: Create project directory...
set "PROJECT_DIR=%USERPROFILE%\Desktop\VintageStoryMCreator"
if exist "%PROJECT_DIR%" (
    echo Directory already exists, updating files...
) else (
    mkdir "%PROJECT_DIR%"
)

:: Step 4: Copy project files
echo Step 4: Copying project files...
set "SOURCE_DIR=%~dp0"
if not exist "%SOURCE_DIR%main.js" (
    echo error: main.js not found in the source folder!
    pause
    exit /b 1
)
if not exist "%SOURCE_DIR%index.html" (
    echo error: index.html not found in the source folder!
    pause
    exit /b 1
)
if not exist "%SOURCE_DIR%package.json" (
    echo error: package.json not found in the source folder!
    pause
    exit /b 1
)
if not exist "%SOURCE_DIR%VS-MCreator.bat" (
    echo error: VS-MCreator.bat not found in the source folder!
    pause
    exit /b 1
)
if not exist "%SOURCE_DIR%start.html" (
    echo error: start.html not found in the source folder!
    pause
    exit /b 1
)
copy "%SOURCE_DIR%start.html" "%PROJECT_DIR%\start.html" >nul
copy "%SOURCE_DIR%VS-MCreator.bat" "%PROJECT_DIR%\VS-MCreator.bat" >nul
copy "%SOURCE_DIR%package.json" "%PROJECT_DIR%\package.json" >nul
copy "%SOURCE_DIR%main.js" "%PROJECT_DIR%\main.js" >nul
copy "%SOURCE_DIR%index.html" "%PROJECT_DIR%\index.html" >nul
echo Project files copied successfully.

:: Step 5: Install Node.js dependencies
echo Step 5: Installing Node.js dependencies (this may take a minute)...
cd /d "%PROJECT_DIR%"
call npm install
if %errorLevel% NEQ 0 (
    echo error: npm install failed!
    pause
    exit /b 1
)
echo Dependencies installed.

:: Step 6: Set VINTAGE_STORY environment variable
echo Step 6: Setting VINTAGE_STORY environment variable...
set "VINTAGE_STORY_PATH=%USERPROFILE%\AppData\Roaming\Vintagestory"
setx VINTAGE_STORY "%VINTAGE_STORY_PATH%" /M
if %errorLevel% NEQ 0 (
    echo warning: Could not set system environment variable (may need admin rights).
    setx VINTAGE_STORY "%VINTAGE_STORY_PATH%"
)
echo VINTAGE_STORY set to %VINTAGE_STORY_PATH%.

:: Step 7: Done
echo.
echo === Installation completed! ===
echo The tool was installed in %PROJECT_DIR%.
echo.
echo To start the editor:
echo   Double-click VS-MCreator.bat in %PROJECT_DIR%
echo.
echo To compile mods, make sure Vintage Story is installed at:
echo   %VINTAGE_STORY_PATH%
pause
