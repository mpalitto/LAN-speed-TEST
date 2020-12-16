#!/bin/bash

myID=$$
echo my pid: $$


function exitSpeedTest() {
  kill -KILL $websocketdID
  sleep 1
  echo Killing $myID  
  pkill -P $myID
  ps -o pid= -o cmd= -C tail | grep iperf3  | while read pid line; do kill -KILL $pid; done
}

if nc -zvw3 192.168.1.125 5201 2>&1 | grep -q 'succeeded'; then
	echo server is on... connecting...
else
	echo check server is on... exiting
	exit
fi

rm /home/natapi/iperf3.out
iperf3 -c 192.168.1.125 -ub 1G -R -t 2000 --logfile /home/natapi/iperf3.out &
iperf2pid=$!


#tail -f /home/natapi/iperf3.out | unbuffer -p awk '{if(substr($7,1,1)=="-") exit; print $7}' &
echo '#!/bin/bash' > .speedTest.sh
echo "parentID=$$" >> .speedTest.sh
echo 'myPID=$$' >> .speedTest.sh
#echo 'tail -f /home/natapi/iperf3.out | unbuffer -p awk '"'"'{if(substr($7,1,1)=="-") exit; print $7}'"'"' > /proc/$myPID/fd/1 &' >> .speedTest.sh
echo 'tail -f /home/natapi/iperf3.out | unbuffer -p awk '"'"'{if(substr($7,1,1)=="-") exit; print $7}'"'"' &' >> .speedTest.sh
echo "tailID=$!" >> .speedTest.sh
echo 'echo IDs: $parentID $myPID $tailID > /proc/$parentID/fd/1' >> .speedTest.sh
echo 'while read l; do echo "rec: $l" > /proc/$parentID/fd/1; if [ "$l" == "kill" ]; then kill -TERM $parentID; break; fi; done' >> .speedTest.sh
chmod +x .speedTest.sh
sleep 5
websocketd --port=1234 ./.speedTest.sh &
websocketdID=$!
echo websocketdID: $websocketdID

trap exitSpeedTest SIGINT
trap exitSpeedTest EXIT

chromium-browser /home/natapi/speedTest.html

sleep 9999
#while read line; do
	#echo "pid: $line"
#done
