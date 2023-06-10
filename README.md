# VOB-to-MP4-converter
## Overview
I have programmed this file to convert a single film or a whole folder of .VOB video files to a .mp4 file. It's main usecase is, when you have a folder of 
videofiles that have been copied by DVDShrink or the linux commandline tool dvdbackup. In that case, you will end up with a lot of files usually up to ten if you 
only copied the main feature of the film or up to 100 if you have mirrored the whole disc. My script converts only the uncompressed main feature of the movie to a 
.mp4 format and copies every audio and every subtitle track. The .mp4 file will be in the folder of the movie with the name of the folder plus a .mp4.

## Prequisites
For this script to work, you need to have the following file structure in the folder, in which the movies are, that need to be converted:  
Root_Folder_with_the_movies_that_will_be_converted  
    |- Movie1  
    |   |- VIDEO_TS  
    |   |   |- VIDEO_TS.IFO  
    |   |   |- VIDEO_TS.BUP  
    |   |   |- VIS_01.IFO  
    |   |   |- VIS_01_0.VOB  
    |   |   |- ...  
    |   |- AUDIO_TS (optional, the script doesn't care, if it's there)  
    |- Movie2  
    |   |- VIDEO_TS  
    |   |   |- ...  
    |   |- AUDIO_TS (optional)  
    |- ...  
  
And you need ffmpeg installed (you probably already have) and have a little knowlege about ffmpeg (About the mp4-encoder).  

## Using it
To run this script, you need to specify the following parameters:  
`[CONVERSION_DIRECTORY]`: This is the path to the folder with the movies  
`[ENCODER]`: This is the encoder for later .mp4 file. The suggestions are libx264 or libx265, but you can use any other encoder, that produces a .mp4 file.
You can run `ffmpeg -codecs` to show all the availiable codecs. Mostly you will just need libx264 and libx265.
  
Example:  
The folder structure is the following:  
Videos  
    |- The Magic Script Part1  
    |   |- VIDEO_TS  
    |   |   |- ...  
    |- The Drying Color on the wall  
    |   |- VIDEO_TS  
    |   |   |- ...  
    |   |- AUDIO_TS  
    |- The last conversion  
    |   |- VIDEO_TS  
    |   |   |- ...  
In this example, I'm converting with libx264, since it is a little bit faster than h265, but it also produces larger files.  
`bash converter.sh ./Videos libx264`  
(Now this will take a while, usually around a half or a third of the duration of the movie, so around 40-60 minutes)  
  
The output folder structure:  
Videos  
    |- The Magic Script Part1  
    |   |- VIDEO_TS  
    |   |   |- ...  
    |   |- The Magic Script Part1.mp4  
    |- The Drying Color on the wall  
    |   |- VIDEO_TS  
    |   |   |- ...  
    |   |- AUDIO_TS  
    |   |- The Drying Color on the wall.mp4  
    |- The last conversion  
    |   |- VIDEO_TS  
    |   |   |- ...  
    |   |- The last conversion.mp4  
  
### IMPORTANT
The bash file only checks if there are arguments specified, NOT IF THEY ARE CORRECT! If you specify a wrong path, the script will fail with an error message from bash.  
Also note, that I have implemented a short check, if the film has already been converted, but I wouldn't rely on it tooooo much on it. I'm pretty sure, that there are cases, in which this check will fail, so USE WITH CAUTION.  
It might also be a good idea, to save the raw movie somewhere as a backup, in case something goes wrong. I CAN'T GUARANTEE YOU, THAT THIS WILL WORK WITHOUT ANY DATA LOSS, SO USE AT OWN RISK!  

## Making changes
Feel free to make any changes to this script to make it suit your needs. I have included more comments than needed to ensure you understand the script more easily.
