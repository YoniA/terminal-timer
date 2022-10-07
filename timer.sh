#!/bin/bash

BEL_RINGS=5
TIME_ENDED_MSG="Time for a break!"
WIDE_SCREEN_THRESHOLD=150

# detect termminal columns size
terminal_cols=$(stty size | awk '{print $2}')


get_time() {
	echo "Usage: Enter time to measure in the format hh:mm:ss"
	echo -e "Examples of legal inputs: 00:20:00, 01:30:00\n"
	read -p "Enter time: " raw_time

	raw_hours=$(echo $raw_time | awk -F: '{print $1}')
	raw_minutes=$(echo $raw_time | awk -F: '{print $2}')
	raw_seconds=$(echo $raw_time | awk -F: '{print $3}')

	validate_format "$raw_hours" "$raw_minutes" "$raw_seconds"
	total_seconds=$((raw_seconds + raw_minutes*60 + raw_hours*3600))
	start_timer "$total_seconds"
	notify_time_end
}


validate_format() {
	if [[ ! $1 =~ ^[0-9][0-9]$ || ! $2 =~ ^[0-5][0-9]$ || ! $3 =~ ^[0-5][0-9]$ ]]; then
		echo "illegal format."
		get_time
	fi
}


start_timer() {
	remaining_time=$1
	for (( i=1;i<=$total_seconds;i++ )); do
		clear
		echo "Time left: " | figlet
		hours=$((remaining_time / 3600))
		minutes=$((remaining_time / 60))
		minutes=$((minutes % 60))
		seconds=$((remaining_time % 60))

		# pad with zeroes when appropriate
		minutes=$([[ $minutes -lt 10 ]] && echo "0${minutes}" || echo "${minutes}")
		seconds=$([[ $seconds -lt 10 ]] && echo "0${seconds}" || echo "${seconds}")

		# if terminal window is wide enough - pad also hours with zero
		if [[ $terminal_cols -gt $WIDE_SCREEN_THRESHOLD ]]; then
			hours=$([[ $hours -lt 10 ]] && echo "0${hours}" || echo "${hours}")
		fi
		
		echo "${hours}:${minutes}:${seconds}" | figlet -w $terminal_cols -f doh
		((remaining_time--))
		sleep 1
	done
}



notify_time_end() {
	clear
	echo $TIME_ENDED_MSG | figlet

	# ring the bel to indicate time's up
	for ((i=1;i<=$BEL_RINGS;i++)); do
		tput bel
		sleep 1
	done
}


get_time
