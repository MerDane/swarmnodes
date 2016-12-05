#!/bin/bash
#Temprature meansurements on each node
nodes=("swarm-master" "swarm-worker1" "swarm-worker2")
echo "Temperature on each node"
echo "Type G : Get each node's Temp. or R : Download the Git repon. or D : Pull Docker images in each node"
read choose
case "$choose" in
	"G" )
		for node in "${nodes[@]}"
		do
			if [ "$node" = "swarm-master" ]; then
				echo "swarm-master:"
				echo $(vcgencmd measure_temp)
				read -p "Press [Enter] key to continue."
			else
				echo " $node : "
				echo $(ssh "$node" vcgencmd measure_temp)
				read -p "Press [Enter] key to continue."
			fi
		done
	;;
        "R" )
                while read line; do
                        for node in "${nodes[@]}"
                        do
                                if [ "$node" != "swarm-master" ]; then
                                        echo "$(ssh "$node" ./gitclone.sh "$line" )"
                                else
                                        echo "$(git clone "$line")"
                                fi
                        done

                done ;;
	"D" )
		while read line; do
			for node in "${nodes[@]}"
			do
		       		if [ "$node" != "swarm-master" ]; then
					echo "$(ssh "$node" docker pull "$line" )"
				else
					echo "$(docker pull "$line")"
				fi
			done

		done ;;
esac
