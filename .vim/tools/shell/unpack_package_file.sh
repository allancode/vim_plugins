#! /bin/bash
# created by longbin <beangr@163.com>
# 2015-03-30

## check_user_UID
function check_user_UID(){
	if [[ ${UID} -lt 1000 ]] ;then
		echo "ERROR: Please don't use root to execute this script."
		exit 1
	fi
}

# function unpack package file
function unpack_package_file(){
	## print current script file name and PID
	## echo $0		$$
	if [[ $# -lt 2 ]] ;then
		echo "function Usage:"
		echo -e "\tunpack_package_file -f packagefile [-d destiantion] [-u USER]"
	fi

	## get install file name
	local PKG_FILE_NAME
	local PKG_FILE_TAIL
	## gain target directory
	local DESTINATION_DIR
	local USER_UID
	local USER_FLAG

	## gain options and arguments 
	# echo "There are $# arguments: $*"
	local OPTIND
	while getopts "f:d:u:" func_opt
	do
		case "${func_opt}" in
			f)
				PKG_FILE_NAME=${OPTARG}
				# echo "package file name: ${PKG_FILE_NAME}"
				;;
			d)
				DESTINATION_DIR=${OPTARG}
				# echo "unpack destination: ${DESTINATION_DIR}"
				;;
			u)
				USER_UID=${OPTARG}
				# echo "unpack user UID: ${USER_UID}"
				;;
			*)
				local ERROR=${*%${OPTARG}}
				echo "Unknown option and argument: -${ERROR##*-} ${OPTARG}"
				exit 1
				;;
		esac
	done

	if [[ "${PKG_FILE_NAME}" == "" ]] ;then
		echo "package file name can not be empty."
		exit 1
	fi
	if ! [[ -f "${PKG_FILE_NAME}" ]] ;then
		echo "${PKG_FILE_NAME}: package not exists."
		exit 1
	fi
	if [[ "${USER_UID}" == "root" ]] ;then
		USER_FLAG=sudo
	else
		USER_FLAG=""
	fi

	if [[ "${DESTINATION_DIR}" == "" ]] ;then
		DESTINATION_DIR=$(pwd)
	fi
	if ! [[ -d "${DESTINATION_DIR}" ]] ;then
		${USER_FLAG} mkdir -p ${DESTINATION_DIR}
	fi
	if ! [ -d ${DESTINATION_DIR} -a -w ${DESTINATION_DIR} ] ;then
		if ! [[ "${USER_UID}" == "root" ]] ;then
			echo "ERROR: ${DESTINATION_DIR} not exists or no permission to write"
			exit 1
		fi
	fi

	PKG_FILE_TAIL=$(echo ${PKG_FILE_NAME:0-7} | tr 'A-Z' 'a-z')
	PKG_FILE_TAIL=${PKG_FILE_TAIL:=${PKG_FILE_NAME}}
	# echo "${PKG_FILE_TAIL}"
	case ${PKG_FILE_TAIL} in
		*.7z)
			which 7z > /dev/null
			if [[ $? != 0 ]] ;then
				echo "zip command not exists. Please install p7zip-full"
				exit
			fi
			echo "7z x ${PKG_FILE_NAME} -o${DESTINATION_DIR}"
			${USER_FLAG} 7z x ${PKG_FILE_NAME} -o${DESTINATION_DIR}
			;;
		*.zip)
			which unzip > /dev/null
			if [[ $? != 0 ]] ;then
				echo "zip command not exists. Please install zip"
				exit
			fi
			echo "unzip ${PKG_FILE_NAME} -d ${DESTINATION_DIR}"
			${USER_FLAG} unzip ${PKG_FILE_NAME} -d ${DESTINATION_DIR}
			;;
		*.rar)
			which unrar > /dev/null
			if [[ $? != 0 ]] ;then
				echo "unrar command not exists. Please install unrar"
				exit
			fi
			echo "unrar x ${PKG_FILE_NAME} ${DESTINATION_DIR}"
			${USER_FLAG} unrar x ${PKG_FILE_NAME} ${DESTINATION_DIR}
			;;
		*.tar | *.jar)
			echo "tar -xvf ${PKG_FILE_NAME} -C ${DESTINATION_DIR}"
			${USER_FLAG} tar -xvf ${PKG_FILE_NAME} -C ${DESTINATION_DIR}
			;;
		.tar.gz | *.tgz)
			echo "tar -zxvf ${PKG_FILE_NAME} -C ${DESTINATION_DIR}"
			${USER_FLAG} tar -zxvf ${PKG_FILE_NAME} -C ${DESTINATION_DIR}
			;;
		tar.bz2)
			echo "tar -jxvf ${PKG_FILE_NAME} -C ${DESTINATION_DIR}"
			${USER_FLAG} tar -jxvf ${PKG_FILE_NAME} -C ${DESTINATION_DIR}
			;;
		.tar.xz)
			echo "tar -Jxvf ${PKG_FILE_NAME} -C ${DESTINATION_DIR}"
			${USER_FLAG} tar -Jxvf ${PKG_FILE_NAME} -C ${DESTINATION_DIR}
			;;
		*.gz | *-gz | *.z | *-z)
			if [[ "${DESTINATION_DIR}" != "$(pwd)" ]] ;then
				mv ${PKG_FILE_NAME} ${DESTINATION_DIR}
			fi
			pushd ${DESTINATION_DIR} > /dev/null
			echo "gunzip ${PKG_FILE_NAME} ..."
			${USER_FLAG} gunzip ${PKG_FILE_NAME}
			popd > /dev/null
			;;
		*)
			echo "Unsupported package type."
			exit 1
			;;
	esac

	echo "Done."
}

check_user_UID
# unpack_package_file -f $1
unpack_package_file -f $1 -d $2
# unpack_package_file -f $1 -d $2 -u root
