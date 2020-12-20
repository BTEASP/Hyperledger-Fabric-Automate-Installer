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
	# cd ${PWD}/Hyperledger-Fabric-Automate-Installer/
	git pull origin master
	# cd ..
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
	# cd ${PWD}/Hyperledger-Fabric-Automate-Installer/
	sudo chmod 755 *
	sudo ./env.sh
}

# Stops all running Docker containers
# Checks the running container count
function down_network() {
	container_count=`docker ps -a  -q | grep imagename | wc -l`
	
	if [[ container_count -eq 0 ]]; then 
		echo "No running Docker container"
	else 
		echo "--------------------------- Stopping Running Docker Containers ---------------------------"
		docker stop $(docker ps -a -q)
		echo "--------------------------- Stopped Running Docker Containers ---------------------------"
	fi
}

# Removes all Docker containers
# Checks the running container count
function remove_network() {
	container_count=`docker ps -a  -q | grep imagename | wc -l`

	if [[ container_count -eq 0 ]]; then 
		echo "Not exist Docker container"
	else
		echo "--------------------------- Removing Docker Containers ---------------------------"
		docker stop $(docker ps -a -q)
		docker rm $(docker ps -a -q)
		echo "--------------------------- Removed Docker Containers ---------------------------"
	fi
}

is_down=false
# CLI interface
while [[ $# -ge 1 ]]; do
	case "$1" in

		up)
			echo "up"
			change_dir_and_run_script
			shift
			;;
		down)
			down_network
			shift
			;;
		remove)
			remove_network
			shift
			;;
		-h | --help)
			echo "pre - prepares the environment for you"
			echo " "
			echo "Example: "
			echo "	./network.sh up"
			echo "pre [options]"
			echo " "
			echo "options:"
			echo "-h, --help		show  brief help"
			echo "-u, --update		updates the repository"
			exit 0
			;;
		-u | --update)
			is_update_repository=true
			update_repository
			change_dir_and_run_script
			shift
			;;
	esac
done
# echo $is_down
# if $is_down; then
#	echo "is_down"
#	down_network
#	is_down=false
#	echo "-------" $is_down
# fi
# if $is_update_repository; then
#	update_repository
# fi

# if [ -d "${PWD}/Hyperledger-Fabric-Automate-Installer/" ]; then
#	if $is_update_repository;  then
#		update_repository
#		echo "Updating..."
#	fi
# fi

# if [ -d "${PWD}/fabric-samples/" ]; then
#	rm_fabric_samples_dir
#	install_binaries
# else
#	install_binaries
# fi

# copy_binaries
# rm_fabric_samples_dir

# change_dir_and_run_script
