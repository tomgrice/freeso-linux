#!/bin/bash

if [ "$EUID" -eq 0 ]
    then echo "Please run with local user, not sudo"
    exit
fi

TEMPDIR="$HOME/.freeso_temp"
GAMEDIR="$HOME/freeso"

echo "Temporary install file location: $TEMPDIR"
echo "Game file location: $GAMEDIR"

mkdir -p $TEMPDIR && cd $TEMPDIR
mkdir -p $GAMEDIR

echo -e "\nDetermining package manager..."
if which apt; then PACKAGEUPDATE="apt update -y"; PACKAGEINSTALL="apt install -y unzip cabextract curl mono-complete"; fi
if which pacman; then PACKAGEUPDATE="pacman -Syy"; PACKAGEINSTALL="pacman -S --noconfirm unzip cabextract curl mono"; fi
if which yum; then PACKAGEUPDATE="yum check-update -y"; PACKAGEINSTALL="yum install -y unzip cabextract curl mono-complete"; fi
if which dnf; then PACKAGEUPDATE="dnf check-update -y"; PACKAGEINSTALL="dnf install -y unzip cabextract curl mono-complete"; fi
if which zypper; then PACKAGEUPDATE="zypper refresh"; PACKAGEINSTALL="zypper install -y unzip cabextract curl mono-complete"; fi

echo -e "\nUpdating sources..."

sudo ${PACKAGEUPDATE}

echo -e "\nInstalling dependencies (unzip/cabextract/curl/mono)..."
sudo ${PACKAGEINSTALL}

clear -x

echo -e "FreeSO Installer for Linux\nhttps://github.com/tomgrice/freeso-linux"

echo -e "\nDownloading: TSO Game package"
curl -# -O https://beta.freeso.org/TSO.zip 

echo -e "\nDownloading: FreeSO latest client (GitHub)"
curl -# -o "client-latest.zip" -L $(grep -oP '(http)(.*)(client)(.*)(\.zip)' <<< "$(curl -s https://api.github.com/repos/riperiperi/FreeSO/releases/latest)")

echo -e "\nDownloading: macextras package"
curl -# -O https://freeso.org/stuff/macextras.zip

echo -e "\nDownloading: Remesh package"
curl -# -o "RemeshPackage.zip" https://beta.freeso.org/RemeshPackage.docx

echo -e "\nExtracting game archives"
unzip -q -o client-latest.zip -d "${GAMEDIR}"
unzip -q -o TSO.zip -d "${TEMPDIR}/tso"
unzip -q -o macextras.zip -d "${GAMEDIR}"
unzip -q -o RemeshPackage.zip -d "${GAMEDIR}/Content/MeshReplace"

cabextract -qq -d "${GAMEDIR}/game" "${TEMPDIR}/tso/Data1.cab"

echo -e "\nCleaning up temporary files"
rm -R "${TEMPDIR}"

echo -e "\nInstall complete!\nRun game using: 'mono ${GAMEDIR}/FreeSO.exe' - add -3d flag to launch in 3D mode."
