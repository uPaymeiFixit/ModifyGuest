#!/bin/sh

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
cecho "#${white}    This script will walk you through        ${red}#" $red
cecho "#${white}    modifying the default Guest account.     ${red}#" $red
cecho "#${white}                                             ${red}#" $red
cecho "#${white}   If it is your first time doing this       ${red}#" $red
cecho "#${white}   a backup will be made automatically.      ${red}#" $red
cecho "#${white}     Would you like to continue? (y/n)       ${red}#" $red
cecho "###############################################" $red

read -r response
if [[ ! $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    exit
fi


echo ""
cecho "###############################################" $red
cecho "#${green}                    Step 1                   ${red}#" $red
cecho "#${white}       Make sure the guest account and       ${red}#" $red
cecho "#${white}       fast user switching are enabled.      ${red}#" $red
cecho "#${white}                                             ${red}#" $red
cecho "#${white} (System Preferences    ->                   ${red}#" $red
cecho "#${white}     Users & Groups        ->                ${red}#" $red
cecho "#${white}        Login Options         ->             ${red}#" $red
cecho "#${white}           Show fast user switching menu as) ${red}#" $red
cecho "#${white}                                             ${red}#" $red
cecho "#${white}          Press RETURN to continue.          ${red}#" $red
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

    # Check if a backup exists
    if sudo [ ! -d /System/Library/User\ Template/English.lproj.backup ]; then
        #echo ""
        #cecho "No backup was found, would you like to make one before you begin?  (y/n)" $cyan
        #read -r response
        #if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
            #Makes a backup
            cecho "A backup has been created in \"/System/Library/User\ Template/English.lproj.backup\"" $magenta
            sudo cp -R /System/Library/User\ Template/English.lproj /System/Library/User\ Template/English.lproj.backup
        #fi
    fi

    echo ""
    cecho "###############################################" $red
    cecho "#${green}                    Step 2                   ${red}#" $red
    cecho "#${white}         Switch to the Guest account.        ${red}#" $red
    cecho "#${white}    (Do not log out of yoru main account)    ${red}#" $red
    cecho "#${white}                                             ${red}#" $red
    cecho "#${green}                    Step 3                   ${red}#" $red
    cecho "#${white}    Set up the Guest account exactly how     ${red}#" $red
    cecho "#${white}   you want it. Here are some suggestions:   ${red}#" $red
    cecho "#${white}       - Wallpaper                           ${red}#" $red
    cecho "#${white}       - Mouse / Trackpad settings           ${red}#" $red
    cecho "#${white}       - Dock                                ${red}#" $red
    cecho "#${white}       - Launch apps with first time         ${red}#" $red
    cecho "#${white}               startup sequence (Chrome)     ${red}#" $red
    cecho "#${white}                                             ${red}#" $red
    cecho "#${green}                    Step 4                   ${red}#" $red
    cecho "#${white}        Switch back to this account.         ${red}#" $red
    cecho "#${white}    (Do not log out of the Guest account)    ${red}#" $red
    cecho "#${white}                                             ${red}#" $red
    cecho "#${white}     Once you have completed these steps,    ${red}#" $red
    cecho "#${white}     come back to this window and press      ${red}#" $red
    cecho "#${white}         RETURN to finish the script.        ${red}#" $red
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

