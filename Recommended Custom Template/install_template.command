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


# Create a backup
now=`date +"%Y_%m_%d_%H_%M_%S"`
cecho "A backup has been created in \"/System/Library/User\ Template/English.lproj.backup_$now\"" $magenta
sudo cp -R /System/Library/User\ Template/English.lproj /System/Library/User\ Template/English.lproj.backup_$now

sudo rm -rf /System/Library/User\ Template/English.lproj

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
sudo cp -R "$DIR/English.lproj" /System/Library/User\ Template/
