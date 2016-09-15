#!/bin/bash

PREFIX="netflow-"

# OLDER_THAN 時間経過したインデックスを削除する
OLDER_THAN=168
if [ $1 ]; then
  OLDER_THAN=$2
fi

# 秒数に変換
#OLDER_THAN=`expr "${OLDER_THAN}" \* 3600`
OLDER_THAN=43200

function dateComp()
{
	# 1970/01/01 00:00:00 からの経過秒に変換
	ARG1_SECOND=`date -d "$1" '+%s'`
	ARG2_SECOND=`date -d "$2" '+%s'`

	# 差を返却
	expr $ARG1_SECOND - $ARG2_SECOND
}

for index in $(curl -s localhost:9200/_cat/indices | grep ${PREFIX} | awk '{print $3}' | sort -n); do
	date=`echo ${index} | sed "s/^${PREFIX}//g" | sed "s/\.//g" | sed "s/\-/ /g"`
	date_locale=`date --date "${date} UTC" "+%Y/%m/%d %H:%M(%Z)"`
	echo "${index}(UTC) => ${date_locale}"
	
	diff=`dateComp "$(date)" "${date_locale}"`
	if [ ${diff} -gt ${OLDER_THAN} ]; then
		echo "[DELETE INDEX] ${index}" 1>&2
		curl -w'\n' -XDELETE "http://localhost:9200/${index}"
	fi
done

exit 0
