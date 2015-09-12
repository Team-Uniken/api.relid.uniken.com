#!/bin/bash


#Add the following lines to your bash_profile
# relid(){
#	cd $HOME/path/to/folder
#	sh update.sh $1 $2 $3 $4
# }

#Edit the following lines to your instance
myloc="$HOME/sites/api.relid.uniken.com"
mymysqldump="/Applications/MAMP/Library/bin"
mymysql="/Applications/MAMP/Library/bin"


if [[ "$1" == "build" ]]; then

	git pull
	rake build

else 
	echo "\033[31;1m**** That is not a known command! \033[0m"
	echo "\033[31;1m**** Use \"tpp help\" to see more commands.  \033[0m"
fi



##
#	Production runs off of stable branch
#	Staging runs off of master branch
#	Local runs off of develop or some dev feature branch
#	Content lives in prodDB
#	Content is always pulled from prodDB to staging and to local
#	TODO - ask Sunil about testing options
#


