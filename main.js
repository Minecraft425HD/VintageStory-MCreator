const { app, BrowserWindow, ipcMain, dialog, screen } = require('electron');
const path = require('path');
const fs = require('fs');

const logFile = path.join(__dirname, 'startup.log');

function log(msg) {
    const line = `[${new Date().toISOString()}] ${msg}\n`;
    try { fs.appendFileSync(logFile, line); } catch (_) {}
    console.log(msg);
}

process.on('uncaughtException', (err) => {
    log(`FATAL uncaughtException: ${err.message}\n${err.stack}`);
    try {
        dialog.showErrorBox('Kritischer Fehler', `${err.message}\n\nDetails in startup.log`);
    } catch (_) {}
});

process.on('unhandledRejection', (reason) => {
    log(`FATAL unhandledRejection: ${reason}`);
});

log('main.js gestartet');

let remoteMain;
try {
    remoteMain = require('@electron/remote/main');
    remoteMain.initialize();
    log('@electron/remote initialisiert');
} catch (err) {
    log(`FEHLER: @electron/remote konnte nicht geladen werden: ${err.message}`);
    log('Bitte "npm install" im Projektverzeichnis ausführen!');
    app.whenReady().then(() => {
        dialog.showErrorBox(
            'Fehlende Abhängigkeit',
            `@electron/remote nicht gefunden.\n\nBitte führe im Projektordner aus:\n  npm install\n\nDetails: ${err.message}`
        );
        app.quit();
    });
}

let startWindow;
let mainWindow;

function createStartWindow() {
    log('createStartWindow aufgerufen');
    const { width, height } = screen.getPrimaryDisplay().workAreaSize;
    startWindow = new BrowserWindow({
        width: width,
        height: height,
        webPreferences: {
            nodeIntegration: true,
            contextIsolation: false
        }
    });

    if (remoteMain) remoteMain.enable(startWindow.webContents);

    startWindow.webContents.on('did-fail-load', (event, errorCode, errorDesc) => {
        log(`start.html Ladefehler: ${errorCode} ${errorDesc}`);
        dialog.showErrorBox('Ladefehler', `start.html konnte nicht geladen werden:\n${errorDesc}\n\nFehlercode: ${errorCode}`);
    });

    startWindow.webContents.on('render-process-gone', (event, details) => {
        log(`Renderer-Prozess abgestürzt: ${JSON.stringify(details)}`);
    });

    startWindow.loadFile('start.html').then(() => {
        log('start.html erfolgreich geladen');
    }).catch(err => {
        log(`start.html Fehler: ${err.message}`);
    });

    startWindow.maximize();

    // F12 öffnet DevTools zur Fehlersuche
    startWindow.webContents.on('before-input-event', (event, input) => {
        if (input.key === 'F12') {
            startWindow.webContents.toggleDevTools();
        }
    });
}

function createMainWindow(config) {
    log('createMainWindow aufgerufen');
    const { width, height } = screen.getPrimaryDisplay().workAreaSize;
    mainWindow = new BrowserWindow({
        width: width,
        height: height,
        webPreferences: {
            nodeIntegration: true,
            contextIsolation: false
        }
    });

    if (remoteMain) remoteMain.enable(mainWindow.webContents);

    mainWindow.webContents.on('did-fail-load', (event, errorCode, errorDesc) => {
        log(`index.html Ladefehler: ${errorCode} ${errorDesc}`);
        dialog.showErrorBox('Ladefehler', `index.html konnte nicht geladen werden:\n${errorDesc}\n\nFehlercode: ${errorCode}`);
    });

    mainWindow.webContents.on('render-process-gone', (event, details) => {
        log(`Hauptfenster-Renderer abgestürzt: ${JSON.stringify(details)}`);
        dialog.showErrorBox('Absturz', `Der Editor ist abgestürzt.\nDetails: ${JSON.stringify(details)}\n\nSiehe startup.log für mehr Informationen.`);
    });

    mainWindow.loadFile('index.html').then(() => {
        log('index.html erfolgreich geladen');
    }).catch(err => {
        log(`index.html Fehler: ${err.message}`);
    });

    mainWindow.maximize();

    mainWindow.webContents.on('did-finish-load', () => {
        mainWindow.webContents.send('load-workspace', config);
    });

    // F12 öffnet DevTools zur Fehlersuche
    mainWindow.webContents.on('before-input-event', (event, input) => {
        if (input.key === 'F12') {
            mainWindow.webContents.toggleDevTools();
        }
    });

    startWindow.close();
}

app.whenReady().then(() => {
    log('App bereit');
    // startup.log zu Beginn neu anlegen
    try { fs.writeFileSync(logFile, `=== VS Mod-Creator Start ${new Date().toISOString()} ===\n`); } catch (_) {}
    createStartWindow();
});

app.on('window-all-closed', () => {
    log('Alle Fenster geschlossen');
    if (process.platform !== 'darwin') app.quit();
});

app.on('activate', () => {
    if (BrowserWindow.getAllWindows().length === 0) createStartWindow();
});

ipcMain.on('select-texture', (event) => {
    dialog.showOpenDialog({
        title: "Textur auswählen",
        filters: [{ name: 'Images', extensions: ['png'] }],
        properties: ['openFile']
    }).then(result => {
        if (!result.canceled && result.filePaths.length > 0) {
            event.reply('texture-selected', result.filePaths[0]);
        }
    }).catch(err => {
        event.reply('texture-error', err.message);
    });
});

ipcMain.on('select-workspace-file', (event) => {
    dialog.showOpenDialog({
        title: "Workspace-Datei laden",
        filters: [{ name: 'JSON Files', extensions: ['json'] }],
        properties: ['openFile']
    }).then(result => {
        if (!result.canceled && result.filePaths.length > 0) {
            event.reply('workspace-file-selected', result.filePaths[0]);
        }
    }).catch(err => {
        log(`select-workspace-file Fehler: ${err.message}`);
    });
});

ipcMain.on('open-main-window', (event, config) => {
    log(`open-main-window empfangen, Mod: ${config && config.modName}`);
    createMainWindow(config);
});
