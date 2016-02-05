# Create a backup
now=`date +"%Y_%m_%d_%H_%M_%S"`
cecho "A backup has been created in \"/System/Library/User\ Template/English.lproj.backup_$now\"" $magenta
sudo cp -R /System/Library/User\ Template/English.lproj /System/Library/User\ Template/English.lproj.backup_$now

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
sudo cp -R "$DIR/English.lproj" /System/Library/User\ Template/
