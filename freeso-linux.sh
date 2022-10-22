#!/bin/bash

if [ "$EUID" -eq 0 ]
    then printf "Please run with local user, not sudo\n"
    exit
fi

TEMPDIR="$HOME/.freeso_temp"
GAMEDIR="none"

while [ "$GAMEDIR" == "none" ]
do
    read -p "Directory to install FreeSO [${HOME}/freeso]: " GAMEDIR
    GAMEDIR=${GAMEDIR:-${HOME}/freeso}

    if [ -z "${GAMEDIR%%/*}" ] && pathchk -pP "$GAMEDIR"
    then
        mkdir -p $GAMEDIR

        if [ -d $GAMEDIR ]
        then
            printf "Installing to $GAMEDIR.\n"
            
        else
            printf "$GAMEDIR is not a valid directory.\n"
            GAMEDIR="none"
        fi
    else
        printf "$GAMEDIR is not a full absolute path (e.g. $HOME/freeso)\n"
        GAMEDIR="none"
    fi
done



printf "Temporary install file location: $TEMPDIR\n"
printf "Game file location: $GAMEDIR\n"

mkdir -p $TEMPDIR && cd $TEMPDIR
mkdir -p $GAMEDIR


PACKAGEUPDATE="none"
PACKAGEINSTALL="none"

printf "\nDetermining package manager...\n"
if which apt; then PACKAGEUPDATE="apt update -y"; PACKAGEINSTALL="apt install -y unzip cabextract curl mono-runtime mono-devel"; fi
if which pacman; then PACKAGEUPDATE="pacman -Syy"; PACKAGEINSTALL="pacman -S --noconfirm unzip cabextract curl mono"; fi
if which yum; then PACKAGEUPDATE="yum check-update -y"; PACKAGEINSTALL="yum install -y unzip cabextract curl mono-core mono-devel"; fi
if which dnf; then PACKAGEUPDATE="dnf check-update -y"; PACKAGEINSTALL="dnf install -y unzip cabextract curl mono-core mono-devel"; fi
if which zypper; then PACKAGEUPDATE="zypper refresh"; PACKAGEINSTALL="zypper install -y unzip cabextract curl mono-core mono-devel"; fi

if [ "$PACKAGEUPDATE" == "none" ]
then
    printf "\nPackage Manager/OS not supported."
    exit 1
fi

printf "\nUpdating sources...\n"

sudo ${PACKAGEUPDATE}

printf "\nInstalling dependencies (unzip/cabextract/curl/mono)...\n"
sudo ${PACKAGEINSTALL}

clear -x

printf "FreeSO Installer for Linux\nhttps://github.com/tomgrice/freeso-linux\n"

printf "\nDownloading: TSO Game package\n"
curl -# -O https://beta.freeso.org/TSO.zip 

printf "\nDownloading: FreeSO latest client (GitHub)\n"
curl -# -o "client-latest.zip" -L $(grep -oP '(http)(.*)(client)(.*)(\.zip)' <<< "$(curl -s https://api.github.com/repos/riperiperi/FreeSO/releases/latest)")

printf "\nDownloading: macextras package\n"
curl -# -O https://freeso.org/stuff/macextras.zip

printf "\nDownloading: Remesh package\n"
curl -# -o "RemeshPackage.zip" https://beta.freeso.org/RemeshPackage.docx

printf "\nExtracting game archives\n"
unzip -q -o client-latest.zip -d "${GAMEDIR}"
unzip -q -o TSO.zip -d "${TEMPDIR}/tso"
unzip -q -o macextras.zip -d "${GAMEDIR}"
unzip -q -o RemeshPackage.zip -d "${GAMEDIR}/Content/MeshReplace"

cabextract -qq -d "${GAMEDIR}/game" "${TEMPDIR}/tso/Data1.cab"

printf "\nDownloading game icon from GitHub\n"
curl -# -o ${GAMEDIR}/fso-icon.png https://cdn.statically.io/gh/tomgrice/freeso-linux/main/fso-icon.png

printf "\nCreating launcher icons\n"
mkdir -p ${HOME}/.local/share/applications

cat > "${HOME}/.local/share/applications/FreeSO.desktop" << EOL
[Desktop Entry]
Version=1.0
Type=Application
Name=FreeSO
Comment=Launch FreeSO (https://freeso.org)
Exec=mono ${GAMEDIR}/FreeSO.exe
Icon=${GAMEDIR}/fso-icon.png
Terminal=false
StartupNotify=false
Categories=Game
EOL

cat > "${HOME}/.local/share/applications/FreeSO (3D).desktop" << EOL
[Desktop Entry]
Version=1.0
Type=Application
Name=FreeSO (3D)
Comment=Launch FreeSO (https://freeso.org)
Exec=mono ${GAMEDIR}/FreeSO.exe -3d
Icon=${GAMEDIR}/fso-icon.png
Terminal=false
StartupNotify=false
Categories=Game
EOL

printf "\nCleaning up temporary files\n"
rm -R "${TEMPDIR}"

printf "\nInstall complete!\nRun game using: 'mono ${GAMEDIR}/FreeSO.exe' - add -3d flag to launch in 3D mode.\nOr alternatively, run the game from your system menu.\n"
