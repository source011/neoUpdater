#!/bin/bash
#========== V A R S ===============
RED='\033[0;31m'
NC='\033[0m' # No Color
NEOFOLDER="/home/USER/neo" # No trailing slash!
#==================================
if [ "$EUID" -ne 0 ]
  then echo ">>> DID YOU FORGET SUDO? ;)"
  exit
fi
if [ ! -d $NEOFOLDER ]; then
printf " \n"
echo ">>> NEO FOLDER NOT SET CORRECTLY! PLEASE CHANGE FOLDER IN THE SCRIPT ;)"
printf " \n"
exit
fi
printf " \n"
printf "${RED}==========${NC} Intel(R) Graphics Compute Runtime Updater Script ${RED}==========${NC}\n"
printf "${RED}                    ${NC} -created by source011- ${RED}${NC}\n"
printf " \n"
printf "                  Checking latest version ...\n"
printf " \n"
LATESTVERSIONINTEL=$(curl -s -L https://github.com/intel/compute-runtime/releases | grep '<a href="/intel/compute-runtime/releases/tag/' | head -n 1 | egrep -o "([0-9]{1,}\.)+[0-9]{1,}" | tail -1)
printf "                 Latest version is: $LATESTVERSIONINTEL \n"
CURRENTVERSIONINTEL=$(dpkg -s intel-opencl | grep '^Version:' | awk '{ print $NF }')
printf "              Installed version is: $CURRENTVERSIONINTEL \n"
printf " \n"
if [ "$LATESTVERSIONINTEL" \> "$CURRENTVERSIONINTEL" ];
then
printf "              Downloading latest Intel version ...\n"
PACKAGESINTEL=$(curl -s -L https://github.com/intel/compute-runtime/releases | grep "https://github.com/intel/compute-runtime/releases/download/$LATESTVERSIONINTEL" | grep ".deb" | tail -4 | awk '{ print $NF }')
wget -q $PACKAGESINTEL -P $NEOFOLDER
PACKAGESIGC=$(curl -s -L https://github.com/intel/compute-runtime/releases | grep "https://github.com/intel/intel-graphics-compiler/releases/download/igc" | grep ".deb" | head -2 | awk '{ print $NF }')
wget -q $PACKAGESIGC -P $NEOFOLDER
printf " \n"
dpkg -i $NEOFOLDER/*.deb &>/dev/null;
printf " \n"
rm -f $NEOFOLDER/*.deb
printf "              Updated Intel from $CURRENTVERSIONINTEL to $LATESTVERSIONINTEL!"
printf " \n"
TIMESTAMP=`date +%Y-%m-%d_%H:%M:%S`
printf "[$TIMESTAMP] Updated Intel from $CURRENTVERSIONINTEL to $LATESTVERSIONINTEL!\n" >> $NEOFOLDER/neoUpdater.log
else
printf "          Latest version is installed, nothing to do ..."
TIMESTAMP=`date +%Y-%m-%d_%H:%M:%S`
printf "[$TIMESTAMP] nothing todo...\n" >> $NEOFOLDER/neoUpdater.log
printf " \n"
fi;
printf " \n"
printf "${RED}==========${NC} Intel(R) Graphics Compute Runtime Updater Script ${RED}==========${NC}\n"
printf " \n"
