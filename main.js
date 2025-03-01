const { app, BrowserWindow, ipcMain } = require('electron');
const path = require('path');

function createWindow() {
    const win = new BrowserWindow({
        width: 1000,
        height: 700,
        webPreferences: {
            nodeIntegration: true,
            contextIsolation: false
        }
    });
    win.loadFile('index.html');
    win.webContents.openDevTools(); // Zum Debuggen
}

app.whenReady().then(() => {
    createWindow();
    app.on('activate', () => {
        if (BrowserWindow.getAllWindows().length === 0) createWindow();
    });
});

app.on('window-all-closed', () => {
    if (process.platform !== 'darwin') app.quit();
});

// IPC-Handler für Dateiauswahl
ipcMain.on('select-texture', (event) => {
    const { dialog } = require('electron');
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