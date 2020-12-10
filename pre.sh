#!/bin/bash

# TODO Change the directories
# TODO fix the --update situation
# TODO update the GitHub link

is_update_repository=false

# Clones the repository
# If you do not want to clone repository, you won't call this function
function clone_repository() {
	# TODO check the repo in directory.
	echo "---------------------- Started to cloning source code ----------------------"
	git clone  https://github.com/Nihcep/Hyperledger-Fabric-Automate-Installer.git
	if [ $? -eq 0 ]; then
		echo "---------------------- Source code is cloned -------------------------------";
	else
		echo "Repository could not cloned successfuly.";
		exit $?;
	fi
}

# Installs the neccessary binaries to current directory
# Calls the curl command
function install_binaries() {
	echo "---------------------- Binaries are installing -----------------------------"
	curl -sSL https://bit.ly/2ysbOFE | bash -s

	# Check if the binaries are installed successfuly or not
	if [ $? -eq 0 ]; then
		echo "Binaries are installed successfuly";
	else
		echo "Binaries could not installed successfuly";
		exit 1;
	fi
}

# Removes the fabric-sample directory
# Changes the mode for removing .git/ directory
# Firstly, removes ./git and then, removes fabric-samples/ directories
function rm_fabric_samples_dir() {
	echo "---------------------- fabric-samples/ directory is removing ---------------"
	chmod -R 777 ${PWD}/fabric-samples/.git/
	rm -rf ${PWD}/fabric-samples/.git/
	rm -r ${PWD}/fabric-samples/
	echo "---------------------- fabric-samples/ directory is removed ----------------"
}

# Updates the source code
function update_repository() {
	echo "---------------------- Repository is updating ------------------------------"
	cd ${PWD}/Hyperledger-Fabric-Automate-Installer/
	git pull origin master
	cd ..
	echo "----------------------------------------------------------------------------"
}

# Copies the neccessary files from fabric-samples/bin to source code directory
# configtxgen and cryptogen files are copied 
function copy_binaries() {

	# Copy of the neccessary files from fabric-samples/bin directory
	echo "---------------------- Copying files --------------------------"
	cp ${PWD}/fabric-samples/bin/configtxgen ${PWD}/fabric-samples/bin/cryptogen ${PWD}/Hyperledger-Fabric-Automate-Installer/
	if [ $? -eq 0 ]; then 
		echo "---------------------- Files copied ---------------------------"
	else
		echo "Binaries could not copied successfuly";
		exit $?;
	fi		
}

# Changes the directory and runs the script
function change_dir_and_run_script() {
	# Change directory
	cd ${PWD}/Hyperledger-Fabric-Automate-Installer/
	sudo chmod 755 *
	sudo ./env.sh
}


# CLI interface
while [[ $# -ge 1 ]]; do
	case "$1" in
		-h | --help)
			echo "pre - prepares the environment for you"
			echo " "
			echo "pre [options]"
			echo " "
			echo "options:"
			echo "-h, --help		show  brief help"
			echo "-u, --update		updates the repository"
			exit 0
			;;
		-u)
			is_update_repository=true
			shift
			;;
	esac
done

if [ -d "${PWD}/Hyperledger-Fabric-Automate-Installer/" ]; then
	if $is_update_repository;  then
		update_repository
	fi
else
	clone_repository
fi

if [ -d "${PWD}/fabric-samples/" ]; then
	rm_fabric_samples_dir
	install_binaries
else
	install_binaries
fi

copy_binaries
rm_fabric_samples_dir
change_dir_and_run_script

