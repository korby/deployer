#!/bin/bash
abs_path=$(dirname "$0")
log_dir=./logs
copy_dir=./tmp
keep_releases=4
if [ ! -d "$log_dir" ] ; then mkdir -p $log_dir; fi

. $abs_path/lib/yaml_parse
. $abs_path/lib/colors
. $abs_path/lib/wrappers
. $abs_path/lib/trap

trap "on_exit" SIGINT SIGTERM INT TERM EXIT ERR;
#parse_yaml vhosts.yml
#parse_yaml hosts.yml
#parse_yaml vars.yml
#exit 1

if [ ! -f vhosts.yml ] || [ ! -f hosts.yml ] ; then track "screen" $red"No Configuration's files here!"$std; exit 1; fi
eval $(parse_yaml vhosts.yml)
vhosts=(${ids[@]})
ids=()
eval $(parse_yaml hosts.yml)
hosts=(${ids[@]})
eval $(parse_yaml vars.yml)
vars=(${ids[@]})

release_name=$(date +%Y%m%d%H%M%S)
log_file=$log_dir"/"$release_name".log"

action=""

switcher=$1
while getopts ds options
do	case "$options" in
    d)  debug=1
		switcher=$2
		;;
	s)  simulate=1
		switcher=$2
		;;
	esac
done
case $switcher in
    test )
        action=each_deploy_test ;;

    deploy )
	track "screen" $green"Deploying release $release_name and loging in $log_file"$std;
    action=each_deploy ;;

    rollback )
	track "screen" $green"Rollbacking $release_name and loging in $log_file"$std;
    action=each_rollback ;;

    exec )
		if [ "$debug" == 1 ]; then track "warning" "-d not allowed with $switcher"; exit 1; fi;

		track "warning" "That Command will be executed on each server for each vhost (don't forget you can use these kind of replacement: %deploy_to, %shared_path etc.)!";
		read -p "Sure to execute it [n,Y] ?" agree
		case $agree in
			"y" | "Y" | "yes" | "Yes") 
				to_exec=${@:2}
	    		action=each_exec;;
			*) track "info" "Aborted."; exit 1;;
		esac
	 ;;

  	"")
		# If not args
        track "screen" "This repository $green$repository$std will be cloned by method $green$method$std"
		track "screen" "and deployed according to this settings :"
    	action=each_info
        ;;
    *)
        track "screen" "Unknown action";
        exit 1;;
esac

counter=1
for id in "${vhosts[@]}"
do

	branch="vhosts_"$id"_branch"
	deploy_to="vhosts_"$id"_deploy_to"
	tasks="vhosts_"$id"_tasks"
	eval "tasks=(\${$tasks[@]})"

	release_path=${!deploy_to}/releases/$release_name/
	shared_path=${!deploy_to}/shared/
	previous_release=""

	. $abs_path/lib/$action


    ((counter++))
done