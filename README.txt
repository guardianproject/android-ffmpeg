
This is a new android-ffmpeg project since it seems there were so many
different ways of doing it, it was confusing.  So here is my clean, easily
changeable, static ffmpeg creator for Android.  The result is a single
'ffmpeg' that is statically linked, so its the only file you need.

setup
-----

 1. Install the Android NDK r8 or newer
 2. On Debian/Ubuntu, run: apt-get install yasm bash patch make


building
--------

cd android-ffmpeg
git submodule init
git submodule update
NDK_BASE=/path/to/android-ndk ./configure_make_everything.sh

That should give you command line binary ffmpeg/ffmpeg, which is the only file
you should need.


customizing
-----------

If you want to change which coders, decoders, muxers, filters, etc that are
included, edit configure_ffmpeg.sh and add/substract what you want.


sources of inspiration
----------------------

https://github.com/mconf/android-ffmpeg
https://github.com/halfninja/android-ffmpeg-x264
https://github.com/guardianproject/SSCVideoProto
http://wiki.multimedia.cx/index.php?title=FFmpeg_filter_howto


testing
-------

./ffmpeg -f lavfi -i "movie=midr-mjpeg.mov,redact=redact_unsort.txt" -f lavfi -i "amovie=midr-mjpeg.mov,aredact=aredact_unsort.txt" -acodec copy -vcodec copy -y /tmp/output.mov

./ffmpeg -f lavfi -i "movie=../testfiles/sscvideoproto_nexuss_high_quality_2_3_3.mp4,redact=redact_unsort.txt" -f lavfi -i "amovie=../testfiles/sscvideoproto_nexuss_high_quality_2_3_3.mp4,aredact=aredact_unsort.txt" -acodec copy -vcodec libx264 -b:v 1000k -an -f mp4 -y /tmp/output.mp4
