#! /bin/bash
# Author:			longbin <beangr@163.com>
# Created Date:		2014-06-24
# Release Version:	1.15.731
# Last Modified:	2015-07-31
# this script is available for ubuntu to configure embedded environment

#list the software need to be installed to the variable FILELIST
BASIC_TOOLS="axel vim vim-gnome vim-doc vim-scripts ctags cscope gawk curl rar unrar zip unzip ghex nautilus-open-terminal p7zip-full tree uml-utilities meld gimp dos2unix unix2dos tofrodos python-markdown subversion filezilla indent "

CODE_TOOLS="build-essential git-core gitk libtool cmake automake flex bison gperf graphviz gnupg mingw32 gettext libc6-dev libc++-dev lib32stdc++6 libncurses5-dev lib32bz2-1.0 lib32bz2-dev gcc g++ g++-multilib "

EMBED_TOOLS="ckermit minicom putty tftp-hpa tftpd-hpa uml-utilities nfs-kernel-server "

BUILD_ANDROID_U12="git gnupg flex bison gperf python-markdown build-essential zip curl ia32-libs libc6-dev libncurses5-dev:i386 xsltproc x11proto-core-dev libx11-dev:i386 libreadline6-dev:i386 libgl1-mesa-dev g++-multilib mingw32 tofrodos libxml2-utils zlib1g-dev:i386 "
#libgl1-mesa-dri:i386 libgl1-mesa-glx:i386

BUILD_ANDROID_U14_ESSENTIAL="git gperf python-markdown g++-multilib libxml2-utils "

BUILD_ANDROID_U14_TOOLS="git-core flex bison gperf gnupg build-essential zip curl zlib1g-dev libc6-dev lib32ncurses5-dev lib32z1 x11proto-core-dev libx11-dev libreadline-gplv2-dev lib32z-dev libgl1-mesa-dev g++-multilib mingw32 tofrodos python-markdown libxml2-utils xsltproc libxml-simple-perl"

AI_TOOLS="build-dep python python-numpy python-scipy python-setuptools matplotlib"
PROXY_TOOLS="ntlmaps"

## apt-cache search opencv
# OPEN_CV="$(apt-cache search opencv | awk '{print $1}')"
# OPEN_CV="libgtk2.0-dev pkg-config"
## g++ `pkg-config opencv --cflags --libs` my_example.cpp -o my_example

## bison and flex is the analyzer of programmer and spell
## textinfo is a tool to read manual like man
## automake is used to help create Makefile
## libtool helps to deal with the dependency of libraries
## cvs, cvsd and subversion are used to control version


## ubuntu 12.04 software installing list
U1204_FILELIST="${BASIC_TOOLS} ${CODE_TOOLS} ${EMBED_TOOLS} \
				${BUILD_ANDROID_U12}"
## ubuntu 14.04 software installing list
U1404_FILELIST="${BASIC_TOOLS} ${CODE_TOOLS} ${EMBED_TOOLS} \
				${BUILD_ANDROID_U14_ESSENTIAL} \
				${BUILD_ANDROID_U14_TOOLS}"

INSTALL_CHECK_FLAG="-y"

## check_user_UID
function check_user_UID(){
	if [[ ${UID} -lt 1000 ]] ;then
		echo "ERROR: Please don't use root to execute this script."
		exit 1
	fi
}

## check whether system is Ubuntu or not
function check_system_distributor(){
## get system distributor ID: Ubuntu ?
LINUX_DISTRIBUTOR=$(lsb_release -i |tr 'A-Z' 'a-z'|awk '/distributor/ {print $3}')
LINUX_DISTRIBUTOR=${LINUX_DISTRIBUTOR:=$(cat /etc/issue |tr 'A-Z' 'a-z'|awk '{print $1}')}
LINUX_DISTRIBUTOR=${LINUX_DISTRIBUTOR:=$(cat /etc/*release |tr 'A-Z' 'a-z'|awk '/\<release\>/ {print $1}'|sed -n '1p')}
LINUX_DISTRIBUTOR=${LINUX_DISTRIBUTOR:=$(cat /etc/*release |tr 'A-Z' 'a-z'|awk '/distrib_id=/ {print $1}'|sed 's/distrib_id=//'|sed -n '1p')}

	echo "checking system distributor and release ID ..."
	if [[ "${LINUX_DISTRIBUTOR}" == "ubuntu" ]] ;then
		echo -e "\tCurrent OS Distributor: ${LINUX_DISTRIBUTOR}"
	else
		echo -e "\tCurrent OS is not ubuntu"
		echo -e "\tCurrent OS Distributor: ${LINUX_DISTRIBUTOR}"
		exit 1
	fi
}

## check whether system is Ubuntu 12.04 or 14.04
function check_system_release_version(){
## get system release version: 12.04/14.04 ?
LINUX_RELEASE_VERSION=$(lsb_release -r | tr 'A-Z' 'a-z' | awk '/release/ {print $2}')
LINUX_RELEASE_VERSION=${LINUX_RELEASE_VERSION:=$(cat /etc/issue | awk '{print $2}')}
LINUX_RELEASE_VERSION=${LINUX_RELEASE_VERSION:=$(cat /etc/*release |tr 'A-Z' 'a-z'|awk '/\<release\>/ {print $3}'|sed -n '1p')}
LINUX_RELEASE_VERSION=${LINUX_RELEASE_VERSION:=$(cat /etc/*release |tr 'A-Z' 'a-z'|awk '/distrib_release=/ {print $1}'|sed 's/distrib_release=//'|sed -n '1p')}

	case ${LINUX_RELEASE_VERSION:0:5} in
		12.04)
			echo -e "\tCurrent OS Version: ${LINUX_RELEASE_VERSION}"
			FILELIST=${U1204_FILELIST}
			;;
		14.04|16.04|18.04)
			echo -e "\tCurrent OS Version: ${LINUX_RELEASE_VERSION}"
			FILELIST=${U1404_FILELIST}
			;;
		*)
			echo "Only support Ubuntu LTS version, eg: 12.04/14.04 ..."
			exit 1
			;;
	esac
	echo "checked OK, preparing to setup softwares ..."
	# sleep 2
}

## update and upgrade system
function update_upgrade_ubuntu(){
	read -p "    update software source.list <y/N>? " select
	if [[ "x${select}" == "xy" ]] ;then
		echo "sudo apt-get update"
		#update the source.list
		sudo apt-get update
	fi

	read -p "    upgrade system <y/N>? " select
	if [[ "x${select}" == "xy" ]] ;then
		echo "sudo apt-get upgrade"
		#upgrade the software have installed on the system
		sudo apt-get upgrade
	fi
}

## function initial vim
function vim_initialize_viminfo(){
	if [[ "${UID}" -ge 1000 ]] ;then
		local VIMINFO_HOME=${HOME}
		echo "initializing viminfo file ..."
		sudo rm -f ${VIMINFO_HOME}/.viminfo
		# touch ${VIMINFO_HOME}/.viminfo
	fi
}

#install one software every cycle
function install_soft_for_each(){
	trap 'echo -e "\nAborted by user, exit";exit' INT
	echo "Will install below software for your system:"
	local soft_num=0
	local cur_num=0
	for file in ${FILELIST}
	do
		let soft_num+=1
		echo -e "${file} \c"
	done
	echo ""
	TMOUT=10
	read -p "    Install above softwares <Y/n>? " select
	if [[ "x${select}" == "xn" ]] ;then
		return
	fi

	# FILELIST=$(echo ${FILELIST} | sed 's/[\t ]/\n/g'| sort -u)
	for file in ${FILELIST}
	do
		let cur_num+=1
		let cur_percent=cur_num*100/soft_num
		# echo "${cur_percent}%"

		echo "========================="
		echo " [${cur_percent}%] installing $file ..."
		echo "-------------------------"
		sudo apt-get install ${file} ${INSTALL_CHECK_FLAG}
		# sleep 1
		echo "$file installed ."
	done
	vim_initialize_viminfo
}

function create_link_mesa_libGL_so(){
	LIB_GL_SO=/usr/lib/i386-linux-gnu/libGL.so
	LIB_GL_SO_1=/usr/lib/i386-linux-gnu/mesa/libGL.so.1
	if ! [[ -f "${LIB_GL_SO_1}" ]] ;then
		return
	fi
	sudo ln -s -f ${LIB_GL_SO_1} ${LIB_GL_SO}
}

## install ibus input method frame
function install_ibus_pinyin_for_ubuntu(){
	read -p "press <Enter> to install and setup ibus-pinyin "
	sudo apt-get install ibus ibus-clutter ibus-gtk ibus-gtk3 ibus-qt4 -y
	## install ibus pinyin
	sudo apt-get install ibus-pinyin -y

	sleep 3
	read -p "Press <Enter> to select ibus-pinyin as the defalut input method "
	im-config

	## restart ibus-pinyin
	##try below command to repair ibus-pinyin:
	#ibus-daemon -drx
	ibus-daemon -drx
	if [[ -f ~/.bashrc ]] ;then
		local IS_EXIST=$(cat ~/.bashrc | sed -n '/ibus-daemon/p')
		if [[ "${IS_EXIST}" == "" ]] ;then
			cp ~/.bashrc ~/.bashrc_$(date +%Y%m%d_%H%M%S)
			echo "ibus-daemon -drx" >> ~/.bashrc
		fi
	fi

	## ibus-setup
	## add ibus-pinyin input method to the input method list
	read -p "Press <Enter> to select and add ibus-pinyin "
	ibus-setup

	## configure ibus pinyin
	if [[ "${LINUX_RELEASE_VERSION}" == "12.04" ]] ;then
		/usr/lib/ibus-pinyin/ibus-setup-pinyin
	elif [[ "${LINUX_RELEASE_VERSION}" == "14.04" ]] ;then
		/usr/lib/ibus/ibus-setup-pinyin
	fi

	echo "====================================================="
	echo -e "\tSetup ibus input method OK, please re-login your system and execute below commands to configure it. "
	echo -e "\t\t/usr/lib/ibus-pinyin/ibus-setup-pinyin #for ubuntu1204"
	echo -e "\t\t/usr/lib/ibus/ibus-setup-pinyin #for ubuntu1404 or later version"
	echo "====================================================="
}

function remove_ibus_pinyin_from_ubuntu(){
	## remove ibus-pinyin will lead some problems, repair our OS by below command:
	## sudo apt-get install ibus-pinyin unity-control-center \
	## unity-control-center-signon webaccounts-extension-common xul-ext-webaccounts
	
	## remove ibus-pinyin
	read -p "Press <Enter> to remove ibus "
	sudo apt-get purge ibus
	sudo apt-get autoremove
	## repair OS when removed ibus pinyin 
	sudo apt-get install unity-control-center unity-control-center-signon webaccounts-extension-common xul-ext-webaccounts
}

function install_fcitx_pinyin_for_ubuntu(){
	remove_ibus_pinyin_from_ubuntu

	## install fcitx pinyin
	echo "installing fcitx ..."
	sudo apt-get install fcitx fcitx-pinyin

	read -p "Press <Enter> to select your input method [fcitx] "
	im-config
	read -p "Press <Enter> to add your input method [pinyin] "
	fcitx-config-gtk3

	echo "====================================================="
	echo -e "\tSetup fcitx input method OK, please re-login your system and execute below commands to configure it. "
	echo -e "\t\tim-config"
	echo -e "\t\tfcitx-config-gtk3"
	echo "====================================================="
}

function countdown_select_for_each(){
	#################################
	local DEFAULT_OPTION=
	local TIME_SELECT_TIMEOUT=9
	local PROMTE_MESSAGE_HEADER="$1"
	local PROMTE_MESSAGE_TAIL=" in ${TIME_SELECT_TIMEOUT}s: "
	#################################
	#################################
	local OPTIONS=$(echo 'This_is_your_OPTIONS')
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
	select option in "ibus-pinyin" "fcitx-pinyin" "Use default input method"
	do
		if [[ "x${option}" != "x" ]] ;then
			break
		else
			echo "Invalid option, try again."
		fi
	done
	(kill -HUP ${BG_PID} &>/dev/null)
	echo

	if [[ "x${option}" != "x" ]] ;then
		echo "You select: ${option}"
	else
		echo "You select none."
	fi
	trap 'exit' INT
}

function install_ibus_or_fcitx_pinyin(){
	REPLY=
	countdown_select_for_each  "Please select your input method"
	case ${REPLY} in
	1)
		echo "Preparing install_ibus_pinyin_for_ubuntu ..."
		install_ibus_pinyin_for_ubuntu
		;;
	2)
		echo "Preparing install_fcitx_pinyin_for_ubuntu ..."
		install_fcitx_pinyin_for_ubuntu
		;;
	*)
		echo "Use default input method. "
		;;
	esac
}

function install_ubuntu_multimedia_supports(){
	TMOUT=
	read -p "    Install multimedia libs <y/N>? " select
	if [[ "${select}" == "y" ]] ;then
		echo "This will take you a long time to download."
		sudo apt-get install ubuntu-restricted-addons
		sudo apt-get install ubuntu-restricted-extras
	else
		return
	fi
}

read -p "Setup build environment for ubuntu 12.04/14.04, press <Enter> to continue "


check_system_distributor
check_system_release_version
update_upgrade_ubuntu
install_soft_for_each
create_link_mesa_libGL_so
install_ibus_or_fcitx_pinyin
install_ubuntu_multimedia_supports

echo "Finished !"

