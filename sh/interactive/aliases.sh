# Important variables
# Ruby setup
PATH="$(ruby -e 'print Gem.user_dir')/bin:$PATH"
PATH="/home/pbc/.gem/bin:$PATH"

export GEM_HOME=$HOME/.gem

vw () {
	echo "export OUTPUT_TERM=$(tty)" > /tmp/viewing_tty
}

vw

. ~/cfg/sh/build/vim_builders.sh
. ~/cfg/sh/open/workspace/current

# Program aliases
alias ls="exa"
alias serve="bundle exec jekyll serve"
alias ag='ag --hidden'
alias diskspace='sudo gdmap -f "/"'

# additional git aliases

# Restores the most recent version of a deleted file
grestore () {
	git checkout $(git rev-list -n 1 HEAD -- $1)^ -- $1
}

gexport () {
	git commit -m "Making a commit to export the changes"
	git diff-tree -r --no-commit-id --name-only --diff-filter=ACMRT HEAD | xargs tar -rf "/bup/$1-backup.tar"
	git reset --soft HEAD~
}

alias gch='git checkout'
alias gp='git push'
alias gc='git commit -m'
alias gall='git add --all'
alias gst='git status'
alias gca='git add --all && git commit -m'
alias gamd='git commit --amend -m'
alias glg='git log --stat'
alias gallexisted='git log --pretty=format: --name-only --diff-filter=A | sort -u'
alias gcleanup="git reset --hard; git clean -d -x -f "

# Building aliases
alias ucl="export CC=clang; export CXX=clang++;"
alias cmkd="cmake/build.sh Debug x64 clang clang++ '-DGENERATE_DEBUG_INFORMATION=0 -DBUILD_IN_CONSOLE_MODE=1'"
alias cmkdg="export BUILD_FOLDER_SUFFIX=g; cmake/build.sh Debug x64 clang clang++ '-DGENERATE_DEBUG_INFORMATION=1 -DBUILD_IN_CONSOLE_MODE=1' export BUILD_FOLDER_SUFFIX=;"
alias cmkdgcc="cmake/build.sh Debug x64 gcc g++ '-DBUILD_IN_CONSOLE_MODE=1'"
alias cmkr="cmake/build.sh Release x64 clang clang++ '-DBUILD_IN_CONSOLE_MODE=1'"
alias cmkru="export BUILD_FOLDER_SUFFIX=ultra; cmake/build.sh Release x64 clang clang++ '-DULTRA_OPTS=1 -DBUILD_IN_CONSOLE_MODE=1' export BUILD_FOLDER_SUFFIX=;"

cmkmin() {
	export BUILD_FOLDER_SUFFIX=minimal;
	cmake/build.sh $1 x64 clang clang++ '-DGENERATE_DEBUG_INFORMATION=0 -DBUILD_IN_CONSOLE_MODE=1 -DBUILD_PROPERTY_EDITOR=0 -DBUILD_ENET=0 -DBUILD_VERSION_FILE_GENERATOR=0'
	export BUILD_FOLDER_SUFFIX=;
}

cmkdmin() {
	cmkmin Debug
}

cmkrmin() {
	cmkmin Release
}

alias cmkc="pushd build/current; cmake $OLDPWD; popd"
alias cusr="rm -rf hypersomnia/cache/usr"
alias cgen="rm -rf hypersomnia/cache/gen"
alias catl="rm -rf hypersomnia/cache/gen/atlases"
alias cch="rm -rf hypersomnia/cache"
alias ced="rm -rf hypersomnia/cache/usr/editor"

# System maintenance tasks aliases
journalsize() {
	sudo journalctl --vacuum-size=$1
}

relinksh () {
	sudo ln -sfT $1 /usr/bin/sh
}

alias mkgrub='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias mkmkinit='sudo mkinitcpio -p linux'
alias mounty='mount | column -t'
alias rmpwd='sudo passwd -d '
alias chksh='readlink /usr/bin/sh'
alias journalgetsize='journalctl --disk-usage'
alias mody='lsmod | ag'

# Package management aliases
alias rmorphans="sudo pacman -Rns $(pacman -Qtdq) "
alias rmpkg="yaourt -Rsn "
alias prmpkg="sudo pacman -Rsn "
alias nogpg='yaourt --m-arg "--skippgpcheck"'
alias uppkgs='yaourt -Syu --aur '

# Filesystem task aliases
alias mkb='mkdir build && cd build'
alias clb='cd ../; rm -rf build; mkdir build; cd build'
alias ds='du -sh * | sort -rh'
alias dsh='du -sh .* | sort -rh'
alias fixspaces='for f in *\ *; do mv "$f" "${f// /_}"; done'
alias filecnt='sudo find . -xdev -type f | cut -d "/" -f 2 | sort | uniq -c | sort -n'
alias whenlm="stat -c '%y' "
alias mkexe='sudo chmod +x '
alias gitmkexe='git update-index --chmod=+x '
alias wszystkim='sudo chmod 777 -R .'

# Common tasks aliases
alias start_weston='source ~/cfg/sh/interactive/start_weston.sh'
alias coto='yaourt -Qi'
alias zajeb='pkill -f --signal=SIGKILL '
alias nuke='pkill -f '
alias ptsy='ls /dev/pts'
alias procki='ps aux | ag '
alias rbt='sudo reboot'
alias mycha='. ~/.xinitrc'
alias interrupt='pkill -f --signal 2 '
alias int='interrupt '
alias spac='sudo shutdown -h now'
alias im="interrupt ninja"
alias xtr='. ~/cfg/sh/interactive/extract.plugin.zsh; extract '
alias pls='sudo $(fc -ln -1)'

# Forgotten aliases
alias relx='xrdb ~/.Xresources'
alias upx='sudo xrdb ~/.Xresources'

# Navigation aliases

fd () {
	export FZF_DEFAULT_OPTS=''

	NEWLOC=$(fzf)

	if [ ! -z $NEWLOC ]
	then
		cd $(dirname $NEWLOC)
	fi
}

fr () {
	export FZF_DEFAULT_OPTS=''

	NEWLOC=$(fzf)

	if [ ! -z $NEWLOC ]
	then
		rifle $NEWLOC
	fi
}
