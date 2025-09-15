#!/bin/zsh

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
  echo "Usage: $0 <wall|ceiling|floor> <input_image> <output_image>"
  exit 1
fi

w=640
h=480
port_w=128
port_h=96

# posx1=$(( w + w / 2 - port_w / 2 ))
# posy1=$(( h + h / 2 - port_h / 2 ))

# posx2=$(( posx1 + port_w ))
# posy2=${posy1}

# posx3=${posx1}
# posy3=$(( posy1 + port_h ))

# posx4=${posx2}
# posy4=${posy3}


# create original corners
# ocorner1=${w},${h}
# ocorner2="$(( w * 2)),${h}"
# ocorner3="${w},$(( h * 2 ))"
# ocorner4="$(( w * 2 )),$(( h * 2 ))"

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
    pixel="black"
    # this is post crop so on 640x480
    vector="0,${h} 0,$(( (h + port_h) / 2 ))"

    magick $1 -monitor -alpha set -scale x${h} -crop ${w}x${h}+0+0 +repage \
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
    \( -clone 0 -alpha extract \) \
    \( -clone -2 -clone -1 -compose CopyOpacity -composite \) \
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

    # ncorner1=$(( (w - port_w) / 2 )),$(( (h + port_h) / 2 ))
    # ncorner2=$(( ( w * 3) - (w - port_w) / 2 )),$(( (h + port_h) / 2 ))
    # ncorner3=$ocorner3
    # ncorner4=$ocorner4

    # this is post crop so on 640x480
    transp="${w}x$(( h / 2 + port_h / 2 ))+0+$(( (h - port_h) / 2 ))"
    vector="0,0 0,$(( (h - port_h) / 2 ))"

    echo distort Perspective "${ocorner1},${ncorner1} ${ocorner2},${ncorner2} ${ocorner3},${ncorner3} ${ocorner4},${ncorner4}" \
  
    magick $1 -monitor -alpha set -scale x${h} -crop ${w}x${h}+0+0 +repage \
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
    \( -clone 0 -alpha extract \) \
    \( -clone -2 -clone -1 -compose CopyOpacity -composite \) \
    -delete 0--2 \
    $2

    ls -l $2
}

lwall() {

    ocorner1=0,0
    ocorner2=$(( w * 3)),0
    ocorner3="0,${h}"
    ocorner4="$(( w * 3 )),${h}"

    ncorner1=$(( (w - port_w) / 2 )),$(( (h + port_h) / 2 ))
    ncorner2=$(( ( w * 3) - (w - port_w) / 2 )),$(( (h + port_h) / 2 ))
    ncorner3=$ocorner3
    ncorner4=$ocorner4

    transp="${w}x$(( h / 2 + port_h / 2 ))+0+0"
    pixel="black"
    # this is post crop so on 640x480
    vector="0,${h} 0,$(( (h + port_h) / 2 ))"

    magick $1 -monitor -alpha set -scale x${h} -crop ${w}x${h}+0+0 +repage \
    -virtual-pixel transparent \
    -distort Perspective "${ocorner1},${ncorner1} ${ocorner2},${ncorner2} ${ocorner3},${ncorner3} ${ocorner4},${ncorner4}" \
    -crop 640x480+640+0 \
    +repage \
    -flatten \
    -alpha set \
    -region "${transp}" -channel A -evaluate min 0 +channel +region \
    -background black -alpha background \
    \( -size ${w}x${h} -define gradient:vector=${vector} gradient:white-gray25 -alpha set \) \
    \( -clone 1 -clone 0  -compose multiply -composite \) \
    \( -clone 0 -alpha extract \) \
    \( -clone -2 -clone -1 -compose CopyOpacity -composite \) \
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
  perspective="0,0,0,0 ${w},0,${corner1} 0,${h},0,${h} ${w},${h},${corner3}"
  transp="$(( w - posx1 ))x${h}+${posx1}+0"
  pixel="transparent"
  vector="0,0 ${posx1},0"
elif [[ "${1:l}" = "rwall" ]]; then
  perspective="0,0,${corner2} ${w},0,${w},0 0,${h},${corner4} ${w},${h},${w},${h}"
  transp="${posx2}x${h}+0+0"
  pixel="transparent"
  vector="${w},0 ${posx2},0"
else
  echo "Invalid first argument: $1"
  exit 1
fi


perspective="${ocorner1},${ncorner1} ${ocorner2},${ncorner2} ${ocorner3},${ncorner3} ${ocorner4},${ncorner4}"

if [ -f $3 ]; then
  echo "Do you want to replace ${3}? (y/N)"
  read answer
  if [[ ! "${answer:l}" =~ "y|yes" ]]; then
    echo "Aborting."
    exit 1
  fi
fi


magick $2 -monitor -alpha set -scale x${h} -crop ${w}x${h}+0+0 +repage \
\( -clone 0 -clone 0 -clone 0 +append \) \
-delete 0 \
\( -clone 0 \) \
\( -clone 0 \) \
-append \
+repage \
-flatten \
-virtual-pixel white \
-distort Perspective "$perspective" \
-crop 640x480+640+480 \
+repage \
-flatten \
-alpha set \
-region "${transp}" -channel A -evaluate min 0 +channel +region \
-background black -alpha background \
\( -size ${w}x${h} -define gradient:vector=${vector} gradient:white-gray25 -alpha set \) \
\( -clone 1 -clone 0  -compose multiply -composite \) \
\( -clone 0 -alpha extract \) \
\( -clone -2 -clone -1 -compose CopyOpacity -composite \) \
-delete 0--2 \
$3

ls -l $3

exit 0

magick $2 -monitor -alpha set -scale x${h} -crop ${w}x${h}+0+0 +repage \
\( -clone 0 -clone 0 -clone 0 +append \) \
-delete 0 \
\( -clone 0 \) \
\( -clone 0 \) \
-append \
+repage \
-flatten \
-virtual-pixel white \
-distort Perspective "$perspective" \
-crop ${w}x${h}+${w}+${h} +repage \
\( -size ${w}x${h} -define gradient:vector=${vector} gradient:white-black \) \
\( -clone 1 -clone 0  -compose multiply -composite \) \
-delete 0,1 \
-alpha set \
-region "${transp}" -channel A -evaluate min 0 +channel +region \
-background black -alpha background \
$3

ls -l $3
