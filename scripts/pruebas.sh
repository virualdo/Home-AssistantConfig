curl -X GET -H "x-ha-access: terces" -H "Content-Type: application/json" http://virualdo.noip.me/api/states/binary_sensor.motion_sensor_158d0000e7c149?api_password=terces | grep '"off"' &> /dev/null
if [ $? == 0 ]; then
   echo "NO"
else
   echo "SI"
fi

