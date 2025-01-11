for pid in $(ps -ef | grep "some search" | awk '{print $2}'); do kill -9 $pid; done

for pid in $(ps -ef | awk '/some search/ {print $2}'); do kill -9 $pid; done



Use of killall

killall vi

This will kill all command named 'vi'

You might also add a signal as well, e.g SIGKILL

killall -9 vi
