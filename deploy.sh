#!/bin/bash
abs_path=$(dirname "$0")
log_dir=./logs
copy_dir=./tmp
if [ ! -d "$log_dir" ] ; then mkdir -p $log_dir; fi

. $abs_path/lib/yaml_parse
. $abs_path/lib/colors
. $abs_path/lib/exec_wrap
. $abs_path/lib/trap

trap "on_exit" SIGINT SIGTERM INT TERM EXIT;
#parse_yaml vhosts.yml
#parse_yaml hosts.yml

eval $(parse_yaml vhosts.yml)
vhosts=(${ids[@]})
ids=()
eval $(parse_yaml hosts.yml)
hosts=(${ids[@]})

release_name=$(date +%Y%m%d%H%M%S)
log_file=$log_dir"/"$release_name".log"

action=""
if [ $# -eq 0 ] ; then
	echo -e "This repository $green$repository$std will be cloned by method $green$method$std"
	echo -e "and deployed according this settings :"
    action=each_info
fi

switcher=$1
while getopts d options
do	case "$options" in
    d)  debug=1
		switcher=$2
		;;
	esac
done
case $switcher in
    test )
        action=each_deploy_test ;;
    deploy )
	echo -e "$green Deploying release $release_name$std";
        action=each_deploy ;;
esac



counter=1
for id in "${vhosts[@]}"
do

	branch="vhosts_"$id"_branch"
	deploy_to="vhosts_"$id"_deploy_to"
	tasks="vhosts_"$id"_tasks"
	eval "tasks=(\${$tasks[@]})"

	release_path=${!deploy_to}releases/$release_name/
	shared_path=${!deploy_to}shared/

	. $abs_path/lib/$action


    ((counter++))
done