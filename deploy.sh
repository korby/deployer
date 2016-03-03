#!/bin/bash
abs_path=$(dirname "$0")

. $abs_path/lib/yaml_parse
. $abs_path/lib/colors
. $abs_path/lib/exec_remote
#parse_yaml vhosts.yml
#parse_yaml hosts.yml

eval $(parse_yaml vhosts.yml)
vhosts=(${ids[@]})
ids=()
eval $(parse_yaml hosts.yml)
hosts=(${ids[@]})


action=""
if [ $# -eq 0 ] ; then
	echo -e "This repository $green$repository$std will be cloned by method $green$method$std"
	echo -e "and deployed according this settings :"
    action=each_info
fi
case $1 in
    test )
        action=each_deploy_test ;;
esac

now=$(date +%Y%m%d%H%M%S)
counter=1
for id in "${vhosts[@]}"
do

	branch="vhosts_"$id"_branch"
	deploy_to="vhosts_"$id"_deploy_to"
	tasks="vhosts_"$id"_tasks"
	eval "tasks=(\${$tasks[@]})"

	release_path=${!deploy_to}releases/$now/
	shared_path=${!deploy_to}shared/

	. $abs_path/lib/$action


    ((counter++))
done