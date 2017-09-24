cd /home/homeassistant/.homeassistant/scripts/salida/entrada/
COUNTER=0
FECHA=$(date +%Y%m%d%H%M)
mkdir $FECHA
cd $FECHA
curl -X GET -H "x-ha-access: terces" -H "Content-Type: application/json" http://virualdo.noip.me/api/states/binary_sensor.motion_sensor_158d0000e7c149 | grep '"off"' &> /dev/null
if [ $? != 1 ]
  curl -X GET -H "x-ha-access: terces" -H "Content-Type: application/json" http://virualdo.noip.me/api/states/binary_sensor.motion_sensor_158d0000fc1838 | grep '"off"' &> /dev/null
fi

#while [  $COUNTER -lt 100 ]; do
while [ $? != 0 ]; do
  curl http://192.168.1.137/image.jpg -o entrada-$(printf %03d $COUNTER).jpg
  sleep 0.5
  let COUNTER=COUNTER+1 
  curl -X GET -H "x-ha-access: terces" -H "Content-Type: application/json" http://virualdo.noip.me/api/states/binary_sensor.motion_sensor_158d0000e7c149 | grep '"off"' &> /dev/null
  if [ $? != 1 ]
    curl -X GET -H "x-ha-access: terces" -H "Content-Type: application/json" http://virualdo.noip.me/api/states/binary_sensor.motion_sensor_158d0000fc1838 | grep '"off"' &> /dev/null
  fi
done
ffmpeg -framerate 5 -i entrada-%03d.jpg -c:v libx264 -pix_fmt yuv420p entrada$FECHA.mp4

cp entrada$FECHA.mp4 /home/homeassistant/.homeassistant/www/entrada.mp4

rm *.jpg

mv entrada$FECHA.mp4 /home/homeassistant/.homeassistant/scripts/dropbox/sync/entrada$FECHA.mp4
cd ..
rm -r $FECHA
python /home/homeassistant/.homeassistant/scripts/dropbox/dropbox.py

rm /home/homeassistant/.homeassistant/scripts/dropbox/sync/entrada$FECHA.mp4