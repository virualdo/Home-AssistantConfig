/home/homeassistant/.homeassistant/miio/node_modules/.bin/miio --control 192.168.1.123 --method get_prop --params '["power"]' | grep '"off"' &> /dev/null
if [ $? == 0 ]; then
   exit -1
else
   exit 0
fi

