#! /bin/bash
# use this scripts can find out and backup
# the files modified in ndays, and copy them
# to backup_dir then compress to .tgz file
# created by longbin <beangr@163.com>
# v1.0 <2015-01-07>
# v1.1 <2015-01-08>
# v1.2 <2015-01-09>

ndays=-1
tmp_file_name=_findfiles_tmp
backup_file=changed_files
backup_dir="__modified_${USER}"

##find out files which modified in ndays, exclude backup_dir
##findout File's data was last modified ndays*24 hours ago.
echo "finding files modified in ${ndays} * 24 hours ..."
find . -name "${backup_dir}" -prune -o -mtime "$ndays" \
		 | sed -n "s%^\.\/% %p" \
		 > $tmp_file_name

sed -i '/^\.$/d' ${tmp_file_name} ## delete lines .
sed -i '/^\.\/$/d' ${tmp_file_name} ## delete lines ./
##delete lines begin with ./__backup
sed -i "/^\.\/${backup_dir}/d" ${tmp_file_name}
##delete lines begin with __backup
sed -i "/${backup_dir}/d" ${tmp_file_name}
sed -i "/${tmp_file_name}/d" ${tmp_file_name}
sed -i "/\.o$/d" ${tmp_file_name}
sed -i "/\.ko$/d" ${tmp_file_name}
sed -i "/\.a$/d" ${tmp_file_name}
sed -i "/\.dep$/d" ${tmp_file_name}
sed -i "/\.depend$/d" ${tmp_file_name}
sed -i "/\.map$/d" ${tmp_file_name}
sed -i "/\.bin$/d" ${tmp_file_name}
sed -i "/cscope/d" ${tmp_file_name}
sed -i "/tags$/d" ${tmp_file_name}
sed -i "/${backup_file}\.tgz/d" ${tmp_file_name} ##delete ${backup_file}.tgz

##delete dir and link name from $tmp_file_name
FILE=`sed -n '1,$'p $tmp_file_name`
line_nu=1
for rm_line in $FILE
do
	if [[ -d ${rm_line} ]] || [[ -L ${rm_line} ]] || [[ -x ${rm_line} ]]
	then
		# echo "delete line : ${rm_line}"
		sed -i "${line_nu}d" ${tmp_file_name}
		((line_nu-=1))
	fi
	((line_nu+=1))
done

##get total lines of file
echo "there are "0"`sed -n '$=' ${tmp_file_name}` files changed."

##get file's data as array
FILE=`sed -n '1,$'p $tmp_file_name`
##echo $FILE ##display file's data
if [[ "$FILE" != ""  ]]
then
	read -p "press <ENTER> to backup the new files."

	##backup files ref file's data
	[[ -d ${backup_dir} ]] || mkdir ${backup_dir}

	count=0
	for file in ${FILE}
	do
		## get file's directory
		cp_file_dir=${file%/*}
		## get file's name
		cp_file_name=${file##*/}
		if [[ -d ${cp_file_dir} ]]
		then
			[[ -d ${backup_dir}/${cp_file_dir} ]] \
				|| mkdir -p ${backup_dir}/${cp_file_dir}
			echo "cp ${file} ${backup_dir}/${cp_file_dir}/${cp_file_name}"
			cp -fdu ${file} ${backup_dir}/${cp_file_dir} && ((count+=1))
		else
			# if [[ -f ${file} ]] && ! [[ -L ${file} ]]
			# then
				echo "cp ${file} ${backup_dir}/${file}"
				cp -fdu ${file} ${backup_dir} && ((count+=1))
			# fi
		fi
	done
	echo "copied ${count} files."

	read -p "compress backed up files ? <y/n> " select
	if [[ "$select" == "y" ]]
	then
		tar -zcvf ${backup_file}.tgz ${backup_dir}
		echo "bachup files to  ${backup_file}.tgz finished."
	fi
	# tar -zcvf ${backup_file}.tgz ${FILE}
else
	echo "no files changed to backup."
fi

[[ -f ${tmp_file_name} ]] && rm -f ${tmp_file_name}

