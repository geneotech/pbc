#!/bin/sh
servlist=$(vim --serverlist)

if [[ ! -z $servlist ]]
then
    vim --remote-tab-silent $@
	$(i3-msg "[title=VIM] focus")
else
	cd $WORKSPACE
	$($TERMINAL -e zsh -c "vim --servername VIM $@")
fi