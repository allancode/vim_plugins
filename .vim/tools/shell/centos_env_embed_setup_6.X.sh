#! /bin/bash
# Author:			longbin <beangr@163.com>
# Created Date:		2014-06-24
# Release Version:	1.15.805
# Last Modified:	2015-08-05
# this script is available for centos to configure embedded environment

#list the software need to be installed to the variable FILELIST
CENTOS_BASIC_TOOLS="axel vim ctags cscope curl rar unrar zip unzip ghex nautilus-open-terminal p7zip p7zip-plugins tree meld tofrodos python-markdown subversion filezilla gedit firefox "

CENTOS_CODE_TOOLS="indent git-core gitk libtool cmake automake flex bison gperf graphviz gnupg gettext gcc gcc-c++ zlib-devel emacs "

# EMBED_TOOLS="ckermit minicom putty tftp-hpa tftpd-hpa uml-utilities nfs-kernel-server "
CENTOS_EMBED_TOOLS="xinetd ckermit minicom putty tftp tftp-server nfs4-acl-tools nfs-utils nfs-utils-lib "

UBUNTU_BUILD_ANDROID_U12="git gnupg flex bison gperf python-markdown build-essential zip curl ia32-libs libc6-dev libncurses5-dev:i386 xsltproc x11proto-core-dev libx11-dev:i386 libreadline6-dev:i386 libgl1-mesa-dev g++-multilib mingw32 tofrodos libxml2-utils zlib1g-dev:i386 "
#libgl1-mesa-dri:i386 libgl1-mesa-glx:i386
UBUNTU_BUILD_ANDROID_U14_ESSENTIAL="git gperf python-markdown g++-multilib libxml2-utils "
UBUNTU_BUILD_ANDROID_U14_TOOLS="git-core flex bison gperf gnupg build-essential zip curl zlib1g-dev libc6-dev lib32ncurses5-dev lib32z1 x11proto-core-dev libx11-dev libreadline-gplv2-dev lib32z-dev libgl1-mesa-dev g++-multilib mingw32 tofrodos python-markdown libxml2-utils xsltproc libxml-simple-perl"
UBUNTU_AI_TOOLS="build-dep python python-numpy python-scipy python-setuptools matplotlib"
UBUNTU_PROXY_TOOLS="ntlmaps"

## apt-cache search opencv
# OPEN_CV="$(apt-cache search opencv | awk '{print $1}')"
# OPEN_CV="libgtk2.0-dev pkg-config"
## g++ `pkg-config opencv --cflags --libs` my_example.cpp -o my_example

## bison and flex is the analyzer of programmer and spell
## textinfo is a tool to read manual like man
## automake is used to help create Makefile
## libtool helps to deal with the dependency of libraries
## cvs, cvsd and subversion are used to control version

CENTOS_6_FILELIST="${CENTOS_BASIC_TOOLS} ${CENTOS_CODE_TOOLS} ${CENTOS_EMBED_TOOLS} ${CENTOS_AI_TOOLS}"
INSTALL_CHECK_FLAG="-y"

## check_user_UID
function check_user_UID(){
	if [[ ${UID} -lt 500 ]] ;then
		echo "ERROR: Please don't use root to execute this script."
		exit 1
	fi
	# echo "Please input your password "
	sudo ls > /dev/null
	if [[ "x$?" == "x1" ]] ;then
		echo -e "\tThere is a configuration/permission problem."
		echo -e "\tPlease ensure that you have permission to use sudo"
		exit 1
	fi
}
check_user_UID

## check whether system is centos or not
function check_system_distributor() {
## get system distributor ID: centos ?
LINUX_DISTRIBUTOR=$(cat /etc/issue |tr 'A-Z' 'a-z'|awk ' /release/ {print $1}' | sed -n "1p")
LINUX_DISTRIBUTOR=${LINUX_DISTRIBUTOR:=$(lsb_release -i |tr 'A-Z' 'a-z'|awk '/distributor/ {print $3}')}
LINUX_DISTRIBUTOR=${LINUX_DISTRIBUTOR:=$(cat /etc/*release |tr 'A-Z' 'a-z'|awk '/\<release\>/ {print $1}'|sed -n '1p')}
LINUX_DISTRIBUTOR=${LINUX_DISTRIBUTOR:=$(cat /etc/*release |tr 'A-Z' 'a-z'|awk '/distrib_id=/ {print $1}'|sed 's/distrib_id=//'|sed -n '1p')}

	echo "checking system distributor and release ID ..."
	if [[ "${LINUX_DISTRIBUTOR}" == "centos" ]] ;then
		echo -e "\tCurrent OS Distributor: ${LINUX_DISTRIBUTOR}"
	else
		echo -e "\tCurrent OS is not centos"
		echo -e "\tCurrent OS Distributor: ${LINUX_DISTRIBUTOR}"
		exit 1
	fi
}

## check whether system is centos 12.04 or 14.04
function check_system_release_version(){
## get system release version: 6.5/6.6 ?
LINUX_RELEASE_VERSION=$(cat /etc/issue | awk '/release/ {print $3}'| sed -n '1p')
LINUX_RELEASE_VERSION=${LINUX_RELEASE_VERSION:=$(lsb_release -r | tr 'A-Z' 'a-z' | awk '/release/ {print $2}')}
LINUX_RELEASE_VERSION=${LINUX_RELEASE_VERSION:=$(cat /etc/*release |tr 'A-Z' 'a-z'|awk '/\<release\>/ {print $3}'|sed -n '1p')}
LINUX_RELEASE_VERSION=${LINUX_RELEASE_VERSION:=$(cat /etc/*release |tr 'A-Z' 'a-z'|awk '/distrib_release=/ {print $1}'|sed 's/distrib_release=//'|sed -n '1p')}

	case ${LINUX_RELEASE_VERSION:0:5} in
		6.*)
			echo -e "\tCurrent OS Version: ${LINUX_RELEASE_VERSION}"
			FILELIST=${CENTOS_6_FILELIST}
			;;
		*)
			echo "Only support CentOS 6.X Version, eg: 6.5/6.6 ..."
			exit 1
			;;
	esac
	echo "checked OK, preparing to setup softwares ..."
	# sleep 2
}

## update and upgrade system
function update_upgrade_centos(){
	read -p "	update yum cache <y/N>? " select
	if [[ "${select}" == "y" ]] ;then
		echo "sudo yum clean all"
		sudo yum clean all
		#update the source.list
		echo "sudo yum makecache"
		sudo yum makecache
	fi

	read -p "	update system <y/N>? " select
	if [[ "${select}" == "y" ]] ;then
		echo "sudo yum update"
		#upgrade the software have installed on the system
		sudo yum update
	fi
}

## function yum groupinstall software
function yum_groupinstall_supports(){
	echo -e "\tsudo yum groupinstall \"Base\""
	sudo yum groupinstall "Base"
	echo -e "\tInstalling Development tools ..."
	sudo yum groupinstall "Development tools"
	echo -e "\tInstalling X Window System ..."
	sudo yum groupinstall "X Window System"
	echo -e "\tInstalling Desktop ..."
	sudo yum groupinstall "Desktop"
	echo -e "\tInstalling Chinese Support ..."
	sudo yum groupinstall "Chinese Support"
}

## function initial vim
function vim_initialize_viminfo(){
	if [[ "${UID}" -ge 500 ]] ;then
		local VIMINFO_HOME=${HOME}
		echo "Initializing viminfo file ..."
		sudo rm -f ${VIMINFO_HOME}/.viminfo
		# touch ${VIMINFO_HOME}/.viminfo
	fi
}

#install one software every cycle
function install_soft_for_each(){
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
		let cur_persent=cur_num*100/soft_num
		# echo "${cur_persent}%"

		trap 'echo -e "\nAborted by user, exit";exit' INT
		echo "========================="
		echo " [${cur_persent}%] installing $file ..."
		echo "-------------------------"
		sudo yum install ${file} ${INSTALL_CHECK_FLAG}
		# sleep 1
		echo "$file installed ."
	done
	vim_initialize_viminfo
}

read -p "Setup build environment for CentOS, press <Enter> to continue "

check_system_distributor
check_system_release_version
update_upgrade_centos
yum_groupinstall_supports
install_soft_for_each

echo "Finished !"

