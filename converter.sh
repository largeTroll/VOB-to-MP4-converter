#!/bin/bash

# This file converts every film with a VIDEO_TS folder (created e.g. with dvdbackup
# or DVDShrink) to a mp4 format with the h264 or h265 encoder.
# Therefore, you have to call this converter with the following commands:
# $1: Path to the folders
# $2: Encoder (h264 or h265)

# REMEMBER: There is no checking for errors in the correct calls of this script.
# Use with caution!




starttime=$(date +"%x %X")
startduration=$(date +"%s")

# This is at least some kind of errorchecking
if [ -z $1 ]
then
	echo "You forgot to specify the directory to search for the movies"
fi
if [ -z $2 ]
then
	echo "You forgot to specify an encoder"
	echo "Please use like this:
	bash converter.sh [DIRECTORY TO SEARCH FOR THE FILES] [ENCODER]
	  Possible directories are: . ./this_is_the_directory_to_my_movies
	  Possible encoders are: libx264 or libx265 or any other encoder that produces a mp4 file in ffmpeg"
	exit -1
fi

IFS=$'\n'

cd $1
echo -e "Using directory: $(pwd)\n"

# Get the main directory, so I can jump there to have an overview over all the
# filmfolders
maindir=`pwd`

# Get a list of every folder with a VIDEO_TS subfolder
folderlist=`find . -type d -name VIDEO_TS`

numfilms=0

for i in ${folderlist}
do
	echo "Converting folder: ${i}"
	cd $i

	# Do a quick check, weather there has already been a conversion in the past (look if there is already a .mp4 file)
	if [ -z $(find .. -name "*.mp4") ]
	then
		# Give me the file which contains the main movie
		moviefilename=`find . -size +1000M -name "*1.VOB"`
		#echo $moviefilename
		# Get the basename of the main movie file
		basename=${moviefilename%%1.VOB}
		echo "Main movie seems to be called: ${basename}*.VOB"

		# Make a list of every file in the main movie
		conversionlist=`for movie in $(ls ${basename}*.VOB);
		do
			# The VTS_[TRACKNUMBER]_0.VOB file is the dvd menu
			if [ $movie != "${basename}0.VOB" ];
			then
				echo -n "${movie}|";
			fi;
		done;`
		# Important: remove the last '|'
		echo "Files to be converted: ${conversionlist%%|}"
		# This list is given to ffmpeg so that it can concanate the movie
		concatlist=${conversionlist%%|}



		# Get the Outputfilename:
		cwd=`pwd`
		path=${cwd%%/VIDEO_TS}
		# Nice feature, if you want to know, how the movie is actually called
		moviename=${path##*/}
		echo "The output film will be called: ${cwd}/${moviename}.mp4"
		#echo $moviename

		echo "Starting to convert movie! $(date +"%X")"
		# Concat the movie with ffmpeg
		$(ffmpeg -i "concat:${concatlist%%|}" -loglevel warning -vcodec ${2} -crf 18 -tune film -acodec libmp3lame -scodec copy -map 0:a -map 0:v -map 0:s? ${path}/${moviename}.mp4)
		echo -e "Finished converting movie! $(date +"%X")\n"


		# Clean the screen
		#clear
		# Increase the counter for the number of comverted films
		(( numfilms++ ))
	else
		echo -e "This film has already been converted: ${i}\n"
	fi

	cd $maindir
done

endtime=$(date +"%x %X")
endduration=$(date +"%s")

echo "Overview:"
echo "Process started: ${starttime}"
echo "Process ended: ${endtime}"
echo "Time needed: $((endduration-startduration))"
echo "Used encoder: ${2}"
echo
echo "The following movies have been converted (${numfilms}):"
for i in ${folderlist}
do
	path=${i%%/VIDEO_TS}
	echo ${path##*/}
done
