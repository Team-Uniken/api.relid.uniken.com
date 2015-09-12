#!/bin/bash



if [[ "$1" == "build" ]]; then

	git pull
	rake build

else 
	echo "\033[31;1m**** That is not a known command! \033[0m"
	echo "\033[31;1m**** Use \"tpp help\" to see more commands.  \033[0m"
fi

