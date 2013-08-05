#!/bin/bash
# Copyright 2013 Aishou <kaito.linux@gmail.com>
# 
#  This file is part of OSJAIS.
# 
#  OSJAIS is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
# 
#  OSJAIS is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  GNU General Public License for more details.
# 
#  You should have received a copy of the GNU General Public License
#  along with OSJAIS. If not, see <http://www.gnu.org/licenses/>.
# 
 
version="0.0.1"

echo "OpenSuse Sun Java Automated Installation Script Version $version"
echo "by Aishou <kaito.linux@gmail.com>"
echo ""
 
 
# check if user is root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root." 
   exit 1
fi


cd /opt

echo "1. Check if folders exist... if not create them..."
# check if folder(s) exist
if [ ! -d "java" ]; then
  mkdir java
fi

if [ ! -d "java/64" ]; then
  mkdir -p  java/64
fi

cd java/64

# check if newest Version already installed
if [ -d "jre1.7.0_25" ]; then
echo ""
echo "Error: You have already installed the newest Version of Sun Java.. Exit."
exit 1
fi


# get newest java Version
echo "2. Get newest Sun Java..."
wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F" "http://download.oracle.com/otn-pub/java/jdk/7u25-b15/jre-7u25-linux-x64.tar.gz" 2>/dev/null
export RC=$?
# check if download works as expected
if ! [ "$RC" = "0" ]; then
echo ""
echo "Error: Something goes wrong with the download.. Check your connection... Exit."
exit 1  
fi




# Extract the file
echo "3. Extract tar.gz file..."
tar xzf jre-7u25-linux-x64.tar.gz 2>&1

# Update System Information
echo "4. Let the System get known of this alternative..."
update-alternatives --install "/usr/bin/java" "java" "/opt/java/64/jre1.7.0_25/bin/java" 1

# set in manual mode as default
echo "5. Set new Sun Java as Deafult in manual mode..."
update-alternatives --set java /opt/java/64/jre1.7.0_25/bin/java 

# clean up
echo "6. Cleaning up..."
rm -R jre-7u25-linux-x64.tar.gz
echo "Done."
exit 0