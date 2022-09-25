#/bin/bash

BEL_RINGS=5
TIME_ENDED_MSG="Time for a break!"

# detect termminal columns size
terminal_cols=$(stty size | awk '{print $2}')

read -p "Enter time in seconds: " total_seconds

remaining_time=$total_seconds
for ((i=1;i<=$total_seconds;i++)); do
	clear
	echo "Time left: " | figlet
	hours=$((remaining_time/3600))
	minutes=$((remaining_time/60))
	seconds=$((remaining_time%60))
	#hours=$([[ $hours -lt 10 ]] && echo "0${hours}" || echo "${hours}")
	minutes=$([[ $minutes -lt 10 ]] && echo "0${minutes}" || echo "${minutes}")
	seconds=$([[ $seconds -lt 10 ]] && echo "0${seconds}" || echo "${seconds}")
	#echo "${hours} : ${minutes} : ${seconds}" | figlet -f doh
	echo "${hours}:${minutes}:${seconds}" | figlet -w $terminal_cols -f doh
	((remaining_time--))
	sleep 1
done



clear
echo $TIME_ENDED_MSG | figlet

# ring the bel to indicate time's up
for ((i=1;i<=$BEL_RINGS;i++)); do
	tput bel
	sleep 1
done
