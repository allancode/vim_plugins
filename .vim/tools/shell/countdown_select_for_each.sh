#! /bin/bash 
# 2015-03-28

OPTION_LIST_MSG='start
hai hao ma
wo hen hao
good morning
good afternoon
end
'

function get_text_msg(){
	cat << EOF
	${OPTION_LIST_MSG}
EOF
}

function show_array_list(){
	local LINE_NUMBER=$(get_text_msg | sed -n '$=')
	local cur_line=0
	for ((cur_line=1; cur_line<=${LINE_NUMBER}; cur_line++))
	do
		local one_line=$(get_text_msg |sed -n "${cur_line} p" |sed '/^[ \t]*$/d')
		echo $cur_line $one_line
		OPTION_LSTS[cur_line-1]=${one_line}
		echo \"${OPTION_LSTS[cur_line-1]}\"
	done
}


function countdown_select_for_each(){
	#################################
	local DEFAULT_OPTION=
	local TIME_SELECT_TIMEOUT=5
	local PROMTE_MESSAGE_HEADER="$1"
	local PROMTE_MESSAGE_TAIL=" in ${TIME_SELECT_TIMEOUT}s: "
	#################################
	#################################
	# local OPTION_LSTS=$(echo 'This_is_your_OPTIONS')
	local OPTION_LSTS=$(echo 'This_is_your_OPTIONS')
	#################################
	local PROMTE_MESSAGES=${PROMTE_MESSAGE_HEADER:="Please select"}${PROMTE_MESSAGE_TAIL}
	echo "Will use a default value if you choosed none in ${TIME_SELECT_TIMEOUT}s. "

	for ((countdown=${TIME_SELECT_TIMEOUT}-1; countdown>=1; countdown--)) 
	do
		trap 'exit 0' HUP
		sleep 1; echo -e "\r${PROMTE_MESSAGE_HEADER} in ${countdown}s: \c"
	done &
	local BG_PID=$!

	local TMOUT=${TIME_SELECT_TIMEOUT}
	local option=${DEFAULT_OPTION}
	PS3="${PROMTE_MESSAGES}"

	trap 'kill ${BG_PID}; echo; exit' INT

	## modify ${OPTION_LSTS} as your selections
	select option in ${OPTION_LSTS}
	do
		if [[ "${option}" != "" ]] ;then
			break
		else
			echo "Invalid option, try again."
		fi
	done

	(kill -HUP ${BG_PID} &>/dev/null)
	echo

	if [[ "${option}" != "" ]] ;then
		echo "You select: ${option}"
	else
		echo "You select none."
	fi
}

function test_func(){
	REPLY=
	countdown_select_for_each  "Please select your option"
	echo ${REPLY}

	case ${REPLY} in
	1)
		echo 1
		break;
		;;
	2)
		echo 2
		break
		;;
	*)
		echo "Invalid option."
		;;
	esac
}

test_func
