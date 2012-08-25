
This is a new android-ffmpeg project since it seems there were so many
different ways of doing it, it was confusing.  So here is my clean, easily
changeable, static ffmpeg creator for Android.  The result is a single
'ffmpeg' that is statically linked, so its the only file you need.

setup
-----

 1. Install the Android NDK r8 or newer
 2. On Debian/Ubuntu, run: apt-get install yasm bash patch make gawk


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
    -filter:v redact=redact_unsort.txt \
    -acodec copy \
    output-test-vf_redact.mp4

# audio redact only
/data/local/ffmpeg -i test.mp4 -t 10 \
    -filter:a aredact=aredact_unsort.txt \
    -acodec aac  -b:a 32k -strict experimental \
    -y output-test-af_aredact.mp4

# redact audio and video
/data/local/ffmpeg -i test.mp4 \
    -af aredact=aredact_unsort.txt \
    -vf redact=redact_unsort.txt \
    -acodec aac  -b:a 32k -strict experimental \
    -vcodec libx264 \
    -y output-test-redact.mp4

# tweaking h264 output settings
./ffmpeg \
    -i sscvideoproto_nexuss_high_quality_2_3_3.mp4 \
    -acodec copy \
    -vcodec libx264 -b:v 1000k -an -f mp4 \
    -y /tmp/output.mp4

# drawtext test
./ffmpeg \
    -i test.mp4 \
    -fflags +genpts -t 600 -r 8 -s 640x480 \
    -vf drawtext="fontfile=DejaVuSans.ttf:x=70:y=455: \
text='\%H\:\%M\:\%S | \%a \%d/\%b/\%Y | S500ATV | camera 0': \
fontcolor=0xFFFFFFFF:fontsize=18: \
shadowcolor=0x000000EE:shadowx=1:shadowy=1" \
    -b:v 1500000 -r 8 \
    -acodec copy \
    -y video_file.mp4
