const { app, BrowserWindow, ipcMain, dialog, screen } = require('electron');
const path = require('path');
const remoteMain = require('@electron/remote/main');
remoteMain.initialize();

let startWindow;
let mainWindow;

function createStartWindow() {
    const { width, height } = screen.getPrimaryDisplay().workAreaSize; // Maximale Bildschirmgröße ohne Taskleiste
    startWindow = new BrowserWindow({
        width: width,
        height: height,
        webPreferences: {
            nodeIntegration: true,
            contextIsolation: false
        }
    });
    remoteMain.enable(startWindow.webContents);
    startWindow.loadFile('start.html');
    startWindow.maximize(); // Optional: Fenster sofort maximieren
}

function createMainWindow(config) {
    const { width, height } = screen.getPrimaryDisplay().workAreaSize;
    mainWindow = new BrowserWindow({
        width: width,
        height: height,
        webPreferences: {
            nodeIntegration: true,
            contextIsolation: false
        }
    });
    remoteMain.enable(mainWindow.webContents);
    mainWindow.loadFile('index.html');
    mainWindow.webContents.openDevTools();
    mainWindow.maximize(); // Optional: Fenster sofort maximieren

    mainWindow.webContents.on('did-finish-load', () => {
        mainWindow.webContents.send('load-workspace', config);
    });

    startWindow.close();
}

app.whenReady().then(() => {
    createStartWindow();
});

app.on('window-all-closed', () => {
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
        console.error(err);
    });
});

ipcMain.on('open-main-window', (event, config) => {
    createMainWindow(config);
});
