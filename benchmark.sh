#!/bin/bash

SPICE_APP="ngspice"
SPICE_COMMAND="$SPICE_APP -b "
SPICE_APP_PATH="$(which $SPICE_APP)"
PROF_APP="google-pprof"
PROF_COMMAND="$PROF_APP --callgrind"
EXT=cir
PROF_EXT=profile
PROF_RESULT_EXT=callgrind
SPICE_OUT_EXT=out
PROF_DIR=profiling_info
CIRS_DIR=circuits
SPICE_OUT_DIR=spice_out

if [ ! -d "$PROF_DIR" ]
then
	mkdir $PROF_DIR
else
	rm "$PROF_DIR/*.$PROF_EXT"
fi

if [ ! -d "$SPICE_OUT_DIR" ]
then
	mkdir $SPICE_OUT_DIR
else
	rm "$SPICE_OUT_DIR/*.$SPICE_OUT_EXT"
fi

for f in $(find "$CIRS_DIR" | grep .$EXT)
do 
	cir_file_name=$(basename $f) 
	profile_file_name=${cir_file_name/".$EXT"/".$PROF_EXT"}
	profile_result_file_name=${cir_file_name/".$EXT"/".$PROF_RESULT_EXT"}
	spice_out_file_name=${cir_file_name/".$EXT"/".$SPICE_OUT_EXT"}
	profile_file_path="./$PROF_DIR/$profile_file_name"
	profile_result_file_path="./$PROF_DIR/$profile_result_file_name"
	spice_out_file_path="./$SPICE_OUT_DIR/$spice_out_file_name"

	CPUPROFILE=$profile_file_path $SPICE_COMMAND "$f" > "$spice_out_file_path" 

	$PROF_COMMAND "$SPICE_APP_PATH" "$profile_file_path" > "$profile_result_file_path" 
	
	rm "$profile_file_path" 
done
