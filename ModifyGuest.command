#!/bin/sh

# NOTE: If you run into problems with being asked for the password
# for some keychain thing, run the following command:
#   sudo rm -r /System/Library/User Template/English.lproj/Library/Keychains/*

#TODO - Make restore/backup utility that allows multiple backups
#TODO - Select languages other than English

# Set the colors you can use
black='\033[0;30m'
white='\033[0;37m'
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
blue='\033[0;34m'
magenta='\033[0;35m'
cyan='\033[0;36m'

# Resets the style
reset=`tput sgr0`

# Color-echo. Improved. [Thanks @joaocunha]
# arg $1 = message
# arg $2 = Color
cecho() {
  echo "${2}${1}${reset}"
  return
}



echo ""
cecho "###############################################" $red
cecho "#${reset}    This script will walk you through        ${red}#" $red
cecho "#${reset}    modifying the default Guest account.     ${red}#" $red
cecho "#${reset}                                             ${red}#" $red
cecho "#${reset}  If this is your first time running this,   ${red}#" $red
cecho "#${reset}   a backup will be made automatically.      ${red}#" $red
cecho "#${reset}     Would you like to continue? (y/n)       ${red}#" $red
cecho "###############################################" $red

read -r response
if [[ ! $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    exit
fi


echo ""
cecho "###############################################" $red
cecho "#${green}                    Step 1                   ${red}#" $red
cecho "#${reset}       Make sure the guest account and       ${red}#" $red
cecho "#${reset}       fast user switching are enabled.      ${red}#" $red
cecho "#${reset}                                             ${red}#" $red
cecho "#${reset} (System Preferences    ->                   ${red}#" $red
cecho "#${reset}     Users & Groups        ->                ${red}#" $red
cecho "#${reset}        Login Options         ->             ${red}#" $red
cecho "#${reset}           Show fast user switching menu as) ${red}#" $red
cecho "#${reset}                                             ${red}#" $red
cecho "#${reset}          Press RETURN to continue.          ${red}#" $red
cecho "###############################################" $red
read


# Ask for the administrator password upfront and run a keep-alive
# to update existing `sudo` time stamp until script has finished.
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

if sudo [ ! -d /System/Library/User\ Template/English.lproj ]; then
    cecho "Something went wrong. Are you sure you ran this script as root?" $yellow
    cecho "  Error: File not found: \"/System/Library/User\ Template/English.lproj\"" $red
else

# It looks like we have root, so we will start our main script from here.

    # Create a backup
    now=`date +"%Y_%m_%d_%H_%M_%S"`
    cecho "A backup has been created in \"/System/Library/User\ Template/English.lproj.backup_$now\"" $magenta
    sudo cp -R /System/Library/User\ Template/English.lproj /System/Library/User\ Template/English.lproj.backup_$now

    echo "Would you like to open the backup folder? (Y/n)"
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
        open /System/Library/User\ Template/English.lproj
    fi

    echo ""
    cecho "###############################################" $red
    cecho "#${green}                    Step 2                   ${red}#" $red
    cecho "#${reset}         Switch to the Guest account.        ${red}#" $red
    cecho "#${reset}    (Do not log out of your main account)    ${red}#" $red
    cecho "#${reset}                                             ${red}#" $red
    cecho "#${green}                    Step 3                   ${red}#" $red
    cecho "#${reset}    Set up the Guest account exactly how     ${red}#" $red
    cecho "#${reset}   you want it. Here are some suggestions:   ${red}#" $red
    cecho "#${reset}       - Wallpaper                           ${red}#" $red
    cecho "#${reset}       - Mouse / Trackpad settings           ${red}#" $red
    cecho "#${reset}       - Dock                                ${red}#" $red
    cecho "#${reset}       - Launch apps with first time         ${red}#" $red
    cecho "#${reset}               startup sequence (Chrome)     ${red}#" $red
    cecho "#${reset}                                             ${red}#" $red
    cecho "#${green}                    Step 4                   ${red}#" $red
    cecho "#${reset}        Switch back to this account.         ${red}#" $red
    cecho "#${reset}    (Do not log out of the Guest account)    ${red}#" $red
    cecho "#${reset}                                             ${red}#" $red
    cecho "#${reset}     Once you have completed these steps,    ${red}#" $red
    cecho "#${reset}     come back to this window and press      ${red}#" $red
    cecho "#${reset}         RETURN to finish the script.        ${red}#" $red
    cecho "###############################################" $red
    read

    # Deletes old user template
    sudo rm -R /System/Library/User\ Template/English.lproj/
    # Copies new user template
    sudo cp -R /Users/Guest/ /System/Library/User\ Template/English.lproj/

    if sudo [ -f /System/Library/User\ Template/English.lproj/Library/Keychains/login.keychain ]; then
        # Removes login keychain (needed or else keychain will prompt you for the guest password every login)
        sudo rm /System/Library/User\ Template/English.lproj/Library/Keychains/login.keychain
    fi

    cecho "Success!" $magenta
    cecho "Author - uPaymeiFixit" $magenta
fi
