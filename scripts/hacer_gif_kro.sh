cd /home/homeassistant/.homeassistant/scripts/salida/kro/
COUNTER=0
FECHA=$(date +%Y%m%d%H%M%S)
while [  $COUNTER -lt 40 ]; do
  curl !secret camk_url -o kro$(date +%Y%m%d%H%M%S).jpg
  sleep 0.5
  let COUNTER=COUNTER+1 
done
ffmpeg -framerate 5 -pattern_type glob -i '*.jpg' -c:v libx264 -pix_fmt yuv420p kro$FECHA.mp4

# SI TIENE ARGUMENTO UN 1 GENERA GIF
if [ ${1:-0} -eq 1 ]
then
  ffmpeg -y -i kro$FECHA.mp4 -vf fps=5,scale=640:-1:flags=lanczos,palettegen palette.png
  ffmpeg -y -i kro$FECHA.mp4 -i palette.png -filter_complex "fps=5,scale=640:-1:flags=lanczos[x];[x][1:v]paletteuse" /home/homeassistant/.homeassistant/www/kro.gif
fi

rm *.jpg
rm *.png
mv kro$FECHA.mp4 /home/homeassistant/.homeassistant/scripts/dropbox/sync/kro$FECHA.mp4
python /home/homeassistant/.homeassistant/scripts/dropbox/dropbox.py
