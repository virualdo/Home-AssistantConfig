cd /home/homeassistant/.homeassistant/scripts/salida/balcon/
COUNTER=0
FECHA=$(date +%Y%m%d%H%M)
mkdir $FECHA
cd $FECHA
curl -X GET -H "x-ha-access: terces" -H "Content-Type: application/json" http://virualdo.noip.me/api/states/binary_sensor.motion_sensor_158d0001103866 | grep '"off"' &> /dev/null

while [ $? != 0 ]; do
  curl http://192.168.1.128/image.jpg -o balcon$(date +%Y%m%d%H%M%S).jpg
  sleep 0.5
  let COUNTER=COUNTER+1 
  curl -X GET -H "x-ha-access: terces" -H "Content-Type: application/json" http://virualdo.noip.me/api/states/binary_sensor.motion_sensor_158d0001103866 | grep '"off"' &> /dev/null
done

ffmpeg -framerate 5 -i balcon-%03d.jpg -c:v libx264 -pix_fmt yuv420p balcon$FECHA.mp4

cp balcon$FECHA.mp4 /home/homeassistant/.homeassistant/www/balcon.mp4

rm *.jpg
#rm *.png
mv balcon$FECHA.mp4 /home/homeassistant/.homeassistant/scripts/dropbox/sync/balcon$FECHA.mp4
cd ..
rm -r $FECHA
python /home/homeassistant/.homeassistant/scripts/dropbox/dropbox.py

rm /home/homeassistant/.homeassistant/scripts/dropbox/sync/balcon$FECHA.mp4
