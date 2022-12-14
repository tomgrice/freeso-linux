# freeso-linux
A standalone installer for FreeSO (https://www.freeso.org), a re-implementation of The Sims Online, for Linux users.

## Overview
This is a (currently) simple bash script which installs FreeSO, and the dependencies required to extract the FreeSO game files (unzip/cabextract) and run the game (mono).

The aim of the project is to allow FreeSO to be installed easily on Linux-based systems. Previously, common methods of playing FreeSO on Linux have involved running the game under Wine, or installing the game using a Lutris script, which can be inconvenient and cumbersome for users and difficult for contributors to maintain. This script installs the game with minimal dependencies and overheads, whilst also respecting and avoiding redistribution of copywrited works.

FreeSO is an open-source implementation of the 2002 Massively Multiplayer community game, The Sims Online, developed by [riperiperi](https://github.com/riperiperi) in C# with MonoGame (XNA).

You can find out more about FreeSO on the game website: https://www.freeso.org or the official GitHub repo: https://github.com/riperiperi/FreeSO.


## Usage

To install FreeSO using freeso-linux, use one of the following methods.
You must run the script as a local user (i.e, not root), however you will be asked for your sudo password to allow dependencies to be installed. 

## Compatibility
This script should work on any recent Ubuntu, RHEL/Fedora, Arch (Manjaro, EndeavourOS) or openSUSE based distributions, however it has been tested as working on these systems:
* Ubuntu 22.04.01 LTS
* Ubuntu 22.10
* Pop_OS! 22.04 (Jammy)
* EndeavourOS Artemis Nova 22.9 (Arch based)
* Fedora 36
* openSUSE Tumbleweed (16/10/2022)

## Usage
### Quick Start (one-liner)
Open your Terminal and run the command:
```
wget -qO freeso-linux.sh https://raw.githubusercontent.com/tomgrice/freeso-linux/main/freeso-linux.sh && bash freeso-linux.sh
```

### Manual Install
1) Download 'freeso-linux.sh' from this repository or the latest release package.
2) Allow the script to be executed: `chmod +x freeso-linux.sh` 
3) Run the installer: `./freeso-linux.sh` or `bash freeso-linux.sh`
4) Run the game in 2D mode: `mono ~/freeso/FreeSO.exe` or 3D mode: `mono ~/freeso/FreeSO.exe -3d`

### Screenshot
![freeso-linux running on Ubuntu Budgie 22.04.1 LTS](https://user-images.githubusercontent.com/14261788/195988756-e32d648f-0c02-48c6-afb9-d963fa1aa228.png)

## Planned Features
- [x] Install dependencies.
- [x] Download required game files and extract.
- [x] User-specified install location.
- [x] Application launcher/icon in system menu.
- [x] Add support for multiple Linux distributions/package managers (e.g Arch/AUR, Fedora/RPM).
- [ ] Improve script styling.
- [ ] ARM chip/Raspberry Pi support (arm64/armhf)
- [ ] User to specify installation of optional packages (i.e RemeshPackage).
- [ ] Automatic updating of optional components (i.e. RemeshPackage).
- [x] Slim down dependencies (specify required mono-* packages).
- [ ] Uninstall option.
- [ ] Graphical UI (based on node.js/Svelte/Tauri).

## Credits
[riperiperi](https://github.com/riperiperi): Developer of [FreeSO](https://github.com/riperiperi/FreeSO).

[Sim](https://github.com/ItsSim): Developer of [fsolauncher](https://github.com/ItsSim/fsolauncher), which contributing to inspired me to start this project.
