#!/bin/zsh

# check that argument 1 and 2 are not zero length using zsh syntax
if [[ -z "$1" || -z "$2" ]]; then
  echo "Usage: $0 <input_image> <output_image>"
  exit 1
fi

w=640
h=480

magick "${1}" \
-crop ${w}x${h}+0+0 +repage \
\( -clone 0 -clone 0 -append \) \
\( -clone 1 -clone 1 +append \) \
\( +clone -crop ${w}x${h}+$((w/2))+$((h/2)) -alpha opaque +repage \) \
\( -size ${w}x${h} -define gradient:radii=$(( w * 0.95 )),$(( h * 0.85 )) -define gradient:center=$((w/2)),$((h/2)) radial-gradient:black-white \) \
\( -clone 3 -clone 4 -compose CopyOpacity -composite \)  \
\( -clone 0 -alpha opaque -clone 5 -compose atop -flatten \) \
-delete 0-5 "${2}"