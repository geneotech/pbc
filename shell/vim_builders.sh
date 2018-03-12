. ~/.config/i3/workspace/current

export WORKSPACE_NAME=$(basename $WORKSPACE)
export WORKSPACE_EXE=$WORKSPACE/build/current/$WORKSPACE_NAME
. /tmp/viewing_tty

gdbcore() {
	if [ -f $WORKSPACE_EXE ]; then
		TARGET_EXECUTABLE=$WORKSPACE_EXE
	fi

	gdb $TARGET_EXECUTABLE $WORKSPACE/hypersomnia/core
}

hcore() {
	if [ -f $WORKSPACE_EXE ]; then
		TARGET_EXECUTABLE=$WORKSPACE_EXE
	fi

	#gdb -ex="set logging file bt.txt" -ex="set logging on" -ex="bt" -ex="q" $WORKSPACE_EXE $WORKSPACE/hypersomnia/core
	cd $WORKSPACE
	gdb -ex="bt" -ex="q" $TARGET_EXECUTABLE $WORKSPACE/hypersomnia/core
}

alias interrupt='pkill -f --signal 2 '

. ~/cfg/shell/log_paths.sh 

rmlogs() {
	rm -f $LASTERR_PATH
	rm -f $LASTERR_PATH_COLOR
	rm -f $RUN_RESULT_PATH
	rm -f $BT_PATH
}

stripcodes() {
	sed -i -r 's/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g' $1
	sed -i -r 's/\x1B\[0;1;3[1-2]m//g' $1
	sed -i 's/\r$//g' $1
	sed -i -e '1d' $1
}

# Handy building aliases
alias clnerr='stripcodes $LASTERR_PATH'

make_with_logs() {
	MAKE_TARGET=$1
	TARGET_DIR=$2

	rmlogs

	if [ "$MAKE_TARGET" = "run" ]; then
		echo "Run-type target." > $OUTPUT_TERM
		rm -f hypersomnia/core
	fi

	script -q -c "time make $MAKE_TARGET -j8 -C $TARGET_DIR" $LASTERR_PATH > $OUTPUT_TERM

	# Remove timing info line
	head -n -2 $LASTERR_PATH > $LASTERR_TEMP_PATH
	cp $LASTERR_TEMP_PATH $LASTERR_PATH

	if [ "$MAKE_TARGET" = "run" ]; then
		echo "Run-type target." > $OUTPUT_TERM
		if [ -f hypersomnia/core ]; then
			echo "Core found." > $OUTPUT_TERM
			hcore | tee $OUTPUT_TERM $BT_PATH
			perl ~/cfg/tools/bt2ll.pl < $BT_PATH > $LASTERR_TEMP_PATH
			cp $LASTERR_TEMP_PATH $BT_PATH
			$(i3-msg "[title=NVIM] focus")
		fi
	fi
}

make_current() {
	MAKE_TARGET=$1

	make_with_logs $MAKE_TARGET build/current
}

handle_last_errors() {
	# We need to be more specific about "error" string,
	# because it may turn out that the game itself has emitted some "error:" messages,
	# but we do not want NVIM to handle this.
	cp $LASTERR_PATH $LASTERR_PATH_COLOR
	clnerr

	ERRORS=$(ag ": error:" $LASTERR_PATH)
	
	if [ ! -z $ERRORS ]; then
		$(i3-msg "[title=NVIM] focus")
	else
		rmlogs
	fi
}

vim_target() {
	interrupt make
	cd $WORKSPACE
	make_current $1
	handle_last_errors
}

vim_build() {
	vim_target all
}

vim_run() {
	vim_target run
}
