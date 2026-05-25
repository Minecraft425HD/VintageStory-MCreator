@echo off
cd /d "%~dp0"

:: Install dependencies if node_modules is missing
if not exist "node_modules" (
    echo Installing dependencies, please wait...
    call npm install
    if %errorLevel% NEQ 0 (
        echo error: npm install failed! Make sure Node.js is installed.
        pause
        exit /b 1
    )
)

npm start
pause
