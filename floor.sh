#!/bin/zsh

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
  echo "Usage: $0 <wall|ceiling|floor> <input_image> <output_image>"
  exit 1
fi

w=640
h=480
port_w=128
port_h=96

floor() {
  ocorner1=0,0
  ocorner2=$(( w * 3)),0
  ocorner3="0,${h}"
  ocorner4="$(( w * 3 )),${h}"

  ncorner1=$(( (w - port_w) / 2 )),$(( (h + port_h) / 2 ))
  ncorner2=$(( ( w * 3) - (w - port_w) / 2 )),$(( (h + port_h) / 2 ))
  ncorner3=$ocorner3
  ncorner4=$ocorner4

  transp="${w}x$(( h / 2 + port_h / 2 ))+0+0"
  # this is post crop so on 640x480
  vector="0,${h} 0,$(( (h + port_h) / 2 ))"

  magick $1 -monitor -scale x${h} -crop ${w}x${h}+0+0 +repage -alpha opaque \
  \( -clone 0 -clone 0 -clone 0 +append \) \
  -delete 0 \
  +repage \
  -flatten \
  -virtual-pixel white \
  -distort Perspective "${ocorner1},${ncorner1} ${ocorner2},${ncorner2} ${ocorner3},${ncorner3} ${ocorner4},${ncorner4}" \
  -crop 640x480+640+0 \
  +repage \
  -flatten \
  -alpha set \
  -region "${transp}" -channel A -evaluate min 0 +channel +region \
  -background black -alpha background \
  \( -size ${w}x${h} -define gradient:vector=${vector} gradient:white-gray25 -alpha set \) \
  \( -clone 1 -clone 0  -compose multiply -composite \) \
  \( -clone -1 -clone 0 -compose CopyOpacity -composite \) \
  -delete 0--2 \
  $2
  
  ls -l $2
}

ceiling() {
  ocorner1=0,0
  ocorner2=$(( w * 3)),0
  ocorner3="0,${h}"
  ocorner4="$(( w * 3 )),${h}"

  ncorner1=$ocorner1
  ncorner2=$ocorner2
  ncorner3=$(( (w - port_w) / 2 )),$(( (h - port_h) / 2 ))
  ncorner4=$(( ( w * 3) - (w - port_w) / 2 )),$(( (h - port_h) / 2 ))

  # this is post crop so on 640x480
  transp="${w}x$(( h / 2 + port_h / 2 ))+0+$(( (h - port_h) / 2 ))"
  vector="0,0 0,$(( (h - port_h) / 2 ))"

  echo distort Perspective "${ocorner1},${ncorner1} ${ocorner2},${ncorner2} ${ocorner3},${ncorner3} ${ocorner4},${ncorner4}" \

  magick $1 -monitor -scale x${h} -crop ${w}x${h}+0+0 +repage -alpha opaque \
  \( -clone 0 -clone 0 -clone 0 +append \) \
  -delete 0 \
  +repage \
  -flatten \
  -virtual-pixel white \
  -distort Perspective "${ocorner1},${ncorner1} ${ocorner2},${ncorner2} ${ocorner3},${ncorner3} ${ocorner4},${ncorner4}" \
  -crop 640x480+640+0 \
  +repage \
  -flatten \
  -alpha set \
  -region "${transp}" -channel A -evaluate min 0 +channel +region \
  -background black -alpha background \
  \( -size ${w}x${h} -define gradient:vector=${vector} gradient:white-gray25 -alpha set \) \
  \( -clone 1 -clone 0 -compose multiply -composite \) \
  \( -clone -1 -clone 0 -compose CopyOpacity -composite \) \
  -delete 0--2 \
  $2

  ls -l $2
}

lwall() {
  ocorner1=0,0
  ocorner2="${w},0"
  ocorner3="0,${h}"
  ocorner4="${w},${h}"

  ncorner1=$ocorner1
  ncorner2=$(( (w - port_w) / 2 )),$(( (h - port_h) / 2 ))
  ncorner3=$ocorner3
  ncorner4=$(( (w - port_w) / 2 )),$(( (h + port_h) / 2 ))

  vector="0,0 $(( (w - port_w) / 2 )),0"
  transp="$(( w - (w - port_w) / 2 ))x${h}+$(( (w - port_w) / 2 ))+0"

  magick $1 -monitor -scale x${h} -crop ${w}x${h}+0+0 +repage -alpha opaque \
  -virtual-pixel transparent \
  -distort Perspective "${ocorner1},${ncorner1} ${ocorner2},${ncorner2} ${ocorner3},${ncorner3} ${ocorner4},${ncorner4}" \
  -region "${transp}" -channel A -evaluate min 0 +channel +region \
  -background black -alpha background \
  \( -size ${w}x${h} -define gradient:vector=${vector} gradient:white-gray25 -alpha opaque \) \
  \( -clone 0 -clone 1 -compose multiply -composite -alpha remove \) \
  \( -clone -1 -clone 0 -compose CopyOpacity -composite \) \
  -delete 0--2 \
  $2

  ls -l $2
}

if [[ "${1:l}" = "floor" ]]; then
  floor $2 $3
  exit 0
elif [[ "${1:l}" = "ceiling" ]]; then
  ceiling $2 $3
  exit 0
elif [[ "${1:l}" = "lwall" ]]; then
  lwall $2 $3
  exit 0
elif [[ "${1:l}" = "rwall" ]]; then
  echo "Not implemented yet: $1"
  exit 1
else
  echo "Invalid first argument: $1"
  exit 1
fi