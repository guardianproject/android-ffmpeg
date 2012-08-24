
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

# embedding metadata into a matroska video
/data/local/ffmpeg -y -i test.mp4 \
    -attach attach.txt -metadata:s:2 mimetype=text/plain \
    -acodec copy -vcodec copy testattach.mkv

# video redact only
./ffmpeg/ffmpeg -y -i test.mp4 \
    -filter:v 'redact=ffmpeg/redact_unsort.txt' \
    -acodec copy \
    output-test-vf_redact.mp4

/data/local/ffmpeg -t 10 -i test.mp4 -filter:v 'redact=redact_unsort.txt' -acodec copy -y output-test-vf_redact.mp4

/data/local/ffmpeg -t 5 -i test.mp4 -filter:a 'aredact=aredact_unsort.txt'  -b:a 32k -strict experimental -vcodec copy -y output-test-af_redact.mp4

/data/local/ffmpeg -t 10 -i test.mp4 -vf redact=redact_unsort.txt  -af aredact=aredact_unsort.txt -acodec copy -y output-test-redact.mp4

# audio redact only, it strips the video out
./ffmpeg/ffmpeg \
    -f lavfi -i 'amovie=test.mp4,aredact=aredact_unsort.txt' -b:a 32k -strict experimental \
    -acodec aac -vcodec copy \
    -y output-test-af_aredact.mp4

/data/local/ffmpeg -f lavfi -i 'amovie=test.mp4,aredact=aredact_unsort.txt' -b:a 32k -strict experimental -acodec aac -vcodec copy -y output-test-af_aredact.mp4

# redact audio and video
./ffmpeg/ffmpeg \
    -f lavfi -i 'amovie=test.mp4,aredact=ffmpeg/aredact_unsort.txt' \
    -f lavfi -i 'movie=test.mp4,redact=ffmpeg/redact_unsort.txt' \
    -acodec aac -b:a 32k -strict experimental \
    -vcodec libx264 \
    -y output-test-redact.mp4

/data/local/ffmpeg -t 5 \
-f lavfi -i 'redact=redact_unsort.txt[out0]; aredact=aredact_unsort.txt[out1]' \
    -acodec aac -b:a 32k -strict experimental \
    -vcodec libx264 \
    -y output-test-redact.mp4

./ffmpeg -f lavfi -i 'amovie=test.mp4,aredact=aredact_unsort.txt' \
    -f lavfi -i 'movie=test.mp4,redact=redact_unsort.txt' \
    -acodec copy -b:a 32k -strict experimental \
    -vcodec copy \
    -y output-test-redact.mp4

/data/local/ffmpeg -i test.mp4 \
    -af aredact=aredact_unsort.txt \
    -vf redact=redact_unsort.txt,aresample=16000 \
    -acodec aac  -b:a 32k -strict experimental \
    -vcodec libx264 \
    -y output-test-redact.mp4

/data/local/ffmpeg -t 10 -i test.mp4 -af aredact=aredact_unsort.txt -vf redact=redact_unsort.txt -acodec copy -vcodec copy -y output-test-redact.mp4

/data/local/ffmpeg -t 10 -i test.mp4 -af aredact=aredact_unsort.txt -acodec copy -vcodec copy -y output-test-redact.mp4


./ffmpeg -f lavfi -i "movie=midr-mjpeg.mov,redact=redact_unsort.txt" -f lavfi -i "amovie=midr-mjpeg.mov,aredact=aredact_unsort.txt" -acodec copy -vcodec copy -y /tmp/output.mov

./ffmpeg -f lavfi -i "movie=../testfiles/sscvideoproto_nexuss_high_quality_2_3_3.mp4,redact=redact_unsort.txt" -f lavfi -i "amovie=../testfiles/sscvideoproto_nexuss_high_quality_2_3_3.mp4,aredact=aredact_unsort.txt" -acodec copy -vcodec libx264 -b:v 1000k -an -f mp4 -y /tmp/output.mp4
