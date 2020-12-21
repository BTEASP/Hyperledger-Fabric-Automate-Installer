#!/bin/bash

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

	container_count=`docker ps | grep "hyperledger" | wc -l`
	if [[ container_count -eq 0 ]]; then 
		echo "No running Docker container"
	else 
		echo "--------------------------- Stopping Running Docker Containers ---------------------------"
		docker stop $(docker ps -a -q)
		echo "--------------------------- Stopped Running Docker Containers ---------------------------"
	fi
}

# Removes all Docker containers related to "hyperledger"
# Checks the container count
# Removes all produced files, artifact, and config files
function clear_network() {
	container_count=`docker images | grep "hyperledger" | wc -l`

	if [[ container_count -eq 0 ]]; then 
		echo "Not exist Docker container"
	else
		echo "--------------------------- Removing Docker Containers ---------------------------"
		docker stop $(docker ps -a -q)
		docker rm $(docker ps -a -q)
		echo "--------------------------- Removed Docker Containers ---------------------------"
	fi
	
	if [[ -f "${PWD}/docker-compose.yml" ]]; then
		rm docker-compose.yml
		echo "docker-compose.yml is removed" 
	fi

	if [ -f "${PWD}/crypto-config.yaml" ]; then
		rm crypto-config.yaml
		echo "crypto-config.yaml is removed"
	fi

	if [ -f "${PWD}/configtx.yaml" ]; then
		rm configtx.yaml
		echo "configtx.yaml is removed"
	fi

	 
	if [[ -f "${PWD}/launch.sh" ]]; then 
		rm launch.sh
		echo "launch.sh is removed"
	fi 

	if [ -d "${PWD}/crypto-config/" ]; then 
		rm -rf crypto-config/
		echo "crypto-config/ directory is removed"
	fi 

	if [ -d "${PWD}/channel-artifacts/" ]; then 
		rm -rf channel-artifacts/
		echo "channel-artifacts/ directory is removed"
	fi
}

# After switching to sudo mode, network config files are created and running with this function
function start_network() {
	python3 gen.py
	sudo chmod 755 launch.sh
	./launch.sh
}

# Restarts the network
# Checks the files and folders before the running network
function up_network() {
	if [ ! -d "${PWD}/channel-artifacts/" ]; then 
		echo "ERROR: 'channel-artifacts/' folder not exists"
		echo "You should clear all produced files and folders, then run network again."
		echo "You can clear all produced files and folders by using './network.sh clear'"
		echo "See './network.sh --help'"
		exit
	elif [ ! -d "${PWD}/crypto-config/" ]; then
		echo "ERROR: 'crypto-config/' folder not exists"
		echo "You should clear all produced files and folders, then run network again."
		echo "You can clear all produced files and folders by using './network.sh clear'"
		echo "See './network.sh --help'"
		exit
	elif [ ! -f "${PWD}/crypto-config.yaml" ]; then
		echo "ERROR: 'crypto-config.yaml' file not exists"
		echo "You should clear all produced files and folders, then run network again."
		echo "You can clear all produced files and folder by using './network.sh clear'"
		echo "See './network.sh --help'"
		exit
	elif [ ! -f "${PWD}/docker-compose.yml" ]; then
		echo "ERROR: 'docker-compose.yml' file not exists"
		echo "You should clear all produced files and folders, then run network again."
		echo "You can clear all produced files and folder by using './network.sh clear'"
		echo "See './network.sh --help'"
		exit
	elif [ ! -f "${PWD}/launch.sh" ]; then
		echo "ERROR: 'launch.sh' file not exists"
		echo "You should clear all produced files and folders, then run network again."
		echo "You can clear all produced files and folder by using './network.sh clear'"
		echo "See './network.sh --help'"
		exit
	elif [ ! -f "${PWD}/configtxgen" ]; then
		echo "ERROR: 'configtxgen' file not exists"
		echo "You should update the repository, then run network again."
		echo "You can update the repository by using './network.sh --update'"
		echo "See './network.sh --help'"
		exit
	elif [ ! -f "${PWD}/cryptogen" ]; then
		echo "ERROR: 'cryptogen' file not exists"
		echo "You should update the repository, then run network again."
		echo "You can update the repository by using './network.sh --update'"
		echo "See './network.sh --help'"
		exit
	elif [ ! -f "${PWD}/docker-compose-base.yml" ]; then
		echo "ERROR: 'docker-compose-base.yml' file not exists"
		echo "You should update the repository, then run network again."
		echo "You can update the repository by using './network.sh --update'"
		echo "See './network.sh --help'"
		exit
	# elif [ ! -f "${PWD}/gen.py" ]; then
	#	echo "ERROR: 'gen.py' file not exists"
	#	echo "You should update the repository, then run network again."
	#	echo "You can update the repository by using './network.sh --update'"
	#	echo "See './network.sh --help'"
	else
		sudo chmod 755 launch.sh
		./launch.sh
	fi

	echo "Done."
}

# CLI interface
while [[ $# -ge 1 ]]; do
	case "$1" in

		pre)
			change_dir_and_run_script
			shift
			;;
		start)
			start_network
			shift
			;;
		down)
			down_network
			shift
			;;
		clear)
			clear_network
			shift
			;;
		up)
			up_network
			shift
			;;
		-h | --help)
			echo "network.sh - prepares the environment and starts the network for you"
			echo " "
			echo "	pre 	prepares the environment for running network"
			echo "	start	starts the network"
			echo "	down	stops the Docker containers and downs the network"
			echo "	clear	clear all Docker containers and produced files, artifacts"
			echo "	up	restarts your last network in a short way. None of the files or folders should be removed to restart successfully."
			echo "Examples: "
			echo "	./network.sh pre"
			echo "	./network.sh start"
			echo "	./network.sh down"
			echo "	./network.sh clear"
			echo "	./network.sh up"
			echo "network.sh [options]"
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
		*)
			echo "./network.sh: '$1' is not a network.sh command"
			echo "See './network.sh --help'"
			shift
			;;
	esac
done
