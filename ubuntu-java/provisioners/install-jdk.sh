#!/bin/bash

echo "================= START install-jdk.sh $(date +"%r") ================="
echo " "
echo "BEGIN installing JDK"

##############################################################################################
## JDK Installation
##############################################################################################
JDK_VERSION="jdk11"
JDK_LONGVERSION="11.0.1"
JDK_FILE="openjdk-${JDK_LONGVERSION}_linux-x64_bin"
JDK_FORCE=0

# Check if we have this JDK installed
if [ ! -d "/usr/lib/jvm/${JDK_VERSION}" ] || [ ${JDK_FORCE} -eq 1 ]; then

	# Don't download if we've already got it locally
	if [ ! -f "/vagrant/artifacts/${JDK_FILE}.tar.gz" ]; then
		echo "... Downloading JDK: ${JDK_VERSION}, standby ..."
		wget -O /vagrant/artifacts/${JDK_FILE}.tar.gz https://download.java.net/java/GA/${JDK_VERSION}/13/GPL/${JDK_FILE}.tar.gz &>> /vagrant/log/install.txt
	fi

	# Install JDK
	sudo gunzip -c /vagrant/artifacts/${JDK_FILE}.tar.gz > ${JDK_FILE}.tar
	sudo tar -xvf ${JDK_FILE}.tar &>> /vagrant/log/install.txt
    sudo rm -rf ${JDK_FILE}.tar &>> /vagrant/log/install.txt

	
	# Move to install directory
	echo "Moving JDK to installation directory at /usr/lib/jvm/jdk-${JDK_LONGVERSION}"
	sudo mkdir -p /usr/lib/jvm/jdk-${JDK_LONGVERSION}
	sudo mv jdk-${JDK_LONGVERSION}/* /usr/lib/jvm/jdk-${JDK_LONGVERSION}/
    sudo rm -rf jdk-${JDK_LONGVERSION}

	echo "Linking JDK to 'latest' JDK"
	cd /usr/lib/jvm
	sudo ln -s /usr/lib/jvm/jdk-${JDK_LONGVERSION}/ latest

	sudo update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jdk-${JDK_LONGVERSION}/bin/java" 1
	sudo update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/jvm/jdk-${JDK_LONGVERSION}/bin/javac" 1 
	#sudo update-alternatives --config java
	
	echo "Updated java locations successfully"
else
	echo "JDK is already installed, skipping"
fi

# Move in environment
sudo /bin/cp -f /vagrant/configs/environment /etc/environment

echo "END installing JDK."
echo " "
echo "================= FINISH install-jdk.sh $(date +"%r") ================="
echo " "