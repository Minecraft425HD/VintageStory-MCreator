const { app, BrowserWindow, ipcMain, dialog } = require('electron');
const path = require('path');
const remoteMain = require('@electron/remote/main'); // Hinzufügen
remoteMain.initialize(); // Initialisierung

let startWindow;
let mainWindow;

function createStartWindow() {
    startWindow = new BrowserWindow({
        width: 700,
        height: 500,
        webPreferences: {
            nodeIntegration: true,
            contextIsolation: false
        }
    });
    remoteMain.enable(startWindow.webContents); // Aktiviere remote für dieses Fenster
    startWindow.loadFile('start.html');
}

function createMainWindow(filePath) {
    mainWindow = new BrowserWindow({
        width: 1000,
        height: 700,
        webPreferences: {
            nodeIntegration: true,
            contextIsolation: false
        }
    });
    remoteMain.enable(mainWindow.webContents); // Aktiviere remote für dieses Fenster
    mainWindow.loadFile('index.html');
    mainWindow.webContents.openDevTools();

    if (filePath) {
        mainWindow.webContents.on('did-finish-load', () => {
            mainWindow.webContents.send('load-workspace', filePath);
        });
    }

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

ipcMain.on('open-main-window', (event, filePath) => {
    createMainWindow(filePath);
});
