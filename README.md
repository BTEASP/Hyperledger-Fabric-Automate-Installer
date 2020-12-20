# Hyperledger-Fabric-Automate-Installer

## RUN

You need to run `network.sh` file to prepare and start to network. You need to start with `./network.sh pre`. Then, your directory changes to the root directory. You should run `./network.sh start` command to start network. You will enter your network's name, organization name, peer numbers, and orderer number. If you are running `network.sh` at the first time, you need to change the mode of the script file with `chmod +x`. It basically changes the permission that it makes the file executable.

Example:

```
$ chmod +x pre.sh
$ ./network.sh pre
$ ./network.sh start
``` 

Above commands start your network. If you want to down your network, you can run following command.

```
$ ./network.sh down
``` 

If you wwant to clear everything like Docker containers, files, folders, you can run following command.

```
$ ./network.sh clear
```

## `network.sh` Option

You can update the repository by using `-u` or `--update` flags. You can run like this:

`$ ./network.sh -u`

or 

`$ ./network.sh --update`

Hyperledger fabric tools

Linked tutorial : https://medium.com/@pechin.leo/hyperledger-fabric-automatic-deployement-770f0c785031

<Readme in progress> 
