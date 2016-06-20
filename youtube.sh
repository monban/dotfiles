INRES="1920x1080" 
OUTRES="1920x1080" 
FPS="15" 
THREADS="0" 
CBR="1500k" 
QUALITY="veryfast" 
AUDIO_RATE="44100"
URI=rtmp://a.rtmp.youtube.com/live2/$YOUTUBE_LIVE_KEY

xrandr --fb $INRES
ffmpeg \
	-loglevel fatal \
	-filter_complex "[0][1]overlay=main_w-overlay_w-32:main_h-overlay_h-32" \
	-threads $THREADS \
	-thread_queue_size 512 -s $INRES -r $FPS -f x11grab -i :0.0 \
	-thread_queue_size 512 -input_format yuv420p -framerate $FPS -video_size 320x240 -f v4l2 -i /dev/video0 \
	-thread_queue_size 512 -f alsa -ac 1 -ar $AUDIO_RATE -i default:CARD=Intel \
	-c:a libfdk_aac -b:a 128k -af "highpass=f=100, lowpass=f=3000" \
	-g 60 -s $OUTRES -f flv -pix_fmt yuv420p -c:v libx264 -preset $QUALITY -maxrate $CBR -bufsize $CBR \
	"$URI"
xrandr --auto
