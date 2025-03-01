# VintageStory-MCreator
A VintageStory Mod Creator

At this time, you can only add new blocks to VintageStory. 
This is done completely automatically with the tool and you get a finished .zip file with the finished mod if you use the instructions correctly, 
which you only have to put in the mod folder in vintagestory.


Automatic Install:
_______________________________________________________________________________________________

-Download the project in ZIP format and decompress the file.
  >Run the setup.bat in admin mode
  >If install completed go to the new created directory on your desktop open it
  >If opened right klick in the folder and open in terminal
  >Type in to the terminal ´npm start´
  >Create your Mod :)



Manual Install:
_______________________________________________________________________________________________
**Step 1: Install Node.js**  
- **Download:** Go to nodejs.org and download the LTS version (e.g., 20.x.x as of March 2025).  
- **Installation:**  
  > Run the downloaded .msi file.  
  > Follow the installation wizard (default options are fine).  
  > Accept the license and click "Next" until the installation is complete.  
- **Verification:**  
  > Open a command prompt (Windows key + R, then type `cmd` and press Enter).  
  > Type: `node -v` and press Enter, then `npm -v` and press Enter.  
  > You should see version numbers (e.g., v20.x.x and v9.x.x). If not, repeat the installation.

**Step 2: Create Folder Structure**  
- **Create Folder:**  
  > Create a new folder on your desktop, e.g., `VIntagestory MCreator`.  
  > Path: `C:\Users\[user]\Desktop\VIntagestory MCreator`.

**Step 3: Initialize Project**  
  > **Open Command Prompt:**  
  > Press Windows key + R, type `cmd`, and press Enter.  
- **Navigate to Folder:**  
  > Type: `cd C:\Users\[user]\Desktop\VIntagestory MCreator` and press Enter.  
- **Initialize Node Project:**  
  > Type: `npm init -y` and press Enter.  
  > This creates a `package.json` file with default settings.

**Step 4: Install Dependencies**  
- **Install Electron and Other Packages:**  
  > In the command prompt (in the `VIntagestory MCreator` folder), type:  
  > `npm install electron adm-zip blockly --save`  
- **This installs:**  
  > `electron`: For the desktop app.  
  > `adm-zip`: For creating the ZIP file for the mod.  
  > `blockly`: For the visual programming interface.  
  > Wait for installation: This may take a few minutes. Afterward, you’ll see a `node_modules` folder and an updated `package.json`.

**Step 6: Start the Tool**  
- **Launch the App:**  
  > In the command prompt (in the `VIntagestory MCreator` folder), type:  
  > `npm start`  
- A window should open with the Blockly interface.

**Step 7: Create a Mod**  
- **Prepare Textures:**  
- Create three 16x16 pixel images in Paint:  
  > `top.png` (red),  
  > `side.png` (blue),  
  > `bottom.png` (green).  
  > Save them, e.g., on your desktop.  
- **Load Textures:**  
  > In the tool, click “Select Texture” and load `top.png`, `side.png`, and `bottom.png` one by one.  
- **Create Block:**  
  > Drag the “New Block” block into the workspace:  
  > Name: `myblock`.  
  > Texture Type: Select “Six-sided”.  
  > Top: Select `top.png`.  
  > Bottom: Select `bottom.png`.  
  > North, South, East, West: Select `side.png`.  
  > Hardness: Set to 10.  
  > Light Transmission: Set to 16.  
  > Collision: Select “Full”.  
  > Passable: Check the box.  
  > Drop: Select “Itself”.  
- **Generate Mod:**  
  > Click “Create and Compile Mod”.  
  > A `mymod2.zip` file will be created in the `VIntagestory MCreator` folder.

**Step 8: Load Mod in Vintage Story**  
- **Copy Mod:**  
  > Copy `mymod2.zip` from `C:\Users\[user]\Desktop\VIntagestory MCreator` to:  
  > `%appdata%/VintagestoryData/Mods`  
  > Press Windows key + R, type `%appdata%/VintagestoryData/Mods`, and paste the ZIP file there.  
- **Start Game:**  
  > Open Vintage Story (version 1.20.4).  
  > Create a creative world and search for `mymod2:myblock` in the inventory.  
- **Test:**  
  > Place the block and check the textures, passability, light, and drops.

**Troubleshooting**  
  > **Node.js not working:** Ensure `node -v` shows a version. If not, reinstall Node.js.  
  > **`npm start` fails:** Check if `main.js` and `index.html` are in the folder and dependencies are installed.  
  > **No ZIP file:** Look for errors in the command prompt and ensure there are no syntax errors in the code.

**Summary**  
  > Install Node.js.  
  > Create the `VIntagestory MCreator` folder.  
  > Initialize the project with `npm init -y`.  
  > Install dependencies with `npm install electron adm-zip blockly --save`.  
  > Create `main.js` and `index.html`.  
  > Start the tool with `npm start`.  
  > Create a mod and test it in Vintage Story.

--- 
