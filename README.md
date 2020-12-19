# Hyperledger-Fabric-Automate-Installer

## RUN

There are 2 different shell script files. The `pre.sh` file provides the commands that before running `gen.py` file. When your directory changes to the root directory, you can run `pre_sudo.sh` command. If you are running `pre.sh` at the first time, you need to change the mode of the script file with `chmod +x`. It basically changes the permission that it makes the file executable.

Example:

```
$ chmod +x pre.sh
$ ./pre.sh
$ ./pre_sudo.sh
``` 
## `pre.sh` Option

You can update the repository by using `-u` or `--update` flags. You can run like this:

`$ ./pre.sh -u`

or 

`$ ./pre.sh --update`

Hyperledger fabric tools

Linked tutorial : https://medium.com/@pechin.leo/hyperledger-fabric-automatic-deployement-770f0c785031

<Readme in progress> 
