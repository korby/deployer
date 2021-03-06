#!/bin/bash
if [ "$(uname)" != "Linux" ]; then rpath=`readlink "$0"`; else rpath=`readlink -f "$0"`; fi;

abs_path=$(dirname "$rpath")
log_dir=./logs
copy_dir=./tmp
remote_copy_dir=/tmp
keep_releases=4
if [ ! -d "$log_dir" ] ; then mkdir -p $log_dir; fi

. $abs_path/lib/yaml_parse
. $abs_path/lib/colors
. $abs_path/lib/wrappers
. $abs_path/lib/trap

#trap "on_exit" SIGINT SIGTERM INT TERM EXIT ERR;
trap "on_exit" SIGTERM TERM EXIT ERR;
#parse_yaml vhosts.yml
#parse_yaml hosts.yml
#parse_yaml vars.yml
#exit 1



release_name=$(date +%Y%m%d%H%M%S)
log_file=$log_dir"/"$release_name".log"

action=""
option_total=0
while getopts ds options
do	case "$options" in
    d)  debug=1
        (( option_total++ ))
		;;
  	s)  simulate=1
        (( option_total++ ))
  		;;
	esac
done
for (( c=1; c<=$option_total; c++ ))
do
   shift;
done

case $1 in
	 init )
  		read -p "Example config files will be written here $(echo -e $yellow `pwd` $std) [N,y] ? " agree
  			case $agree in
  				"y" | "Y" | "yes" | "Yes")
  					. $abs_path/lib/init;;
  				*)
  					track "screen" "Aborted."; ;;
  			esac
           exit 1;;

    test )
        action=each_deploy_test ;;

    showtasks )
        action=each_show_tasks ;;

    deploy )
	     track "screen" $green"Deploying release $release_name and loging in $log_file"$std;
       action=each_deploy ;;

    rollback )
	     track "screen" $green"Rollbacking $release_name and loging in $log_file"$std;
       action=each_rollback ;;

    exec )
    		if [ "$debug" == 1 ]; then track "warning" "-d not allowed with $1"; exit 1; fi;

    		track "warning" "That Command will be executed on each server for each vhost (don't forget you can use these kind of replacement: %deploy_to, %shared_path etc.)!";
    		read -p "Sure to execute it [N,y] ?" agree
    		case $agree in
    			"y" | "Y" | "yes" | "Yes")
    				to_exec=${@:2}
    	    		action=each_exec;;
    			*) track "info" "Aborted."; exit 1;;
    		esac
    	 ;;

  	"")
  		  # If not args
      	action=each_info
        ;;
    *)
        track "screen" "Unknown action";
        exit 1;;
esac

if [ ! -f vhosts.yml ] || [ ! -f hosts.yml ] ; then track "screen" $red"No Configuration's files here!"$std; exit 1; fi

eval $(parse_yaml vhosts.yml)
vhosts=(${ids[@]})
ids=()
eval $(parse_yaml hosts.yml)
hosts=(${ids[@]})
eval $(parse_yaml vars.yml)
vars=(${ids[@]})

if [ "$action" == "each_info" ];
	then
		track "screen" "This repository "$green"$repository"$std" will be cloned by method $green$method$std"
		track "screen" "and deployed according to this settings :"
fi

counter=1
for id in "${vhosts[@]}"
do
  user_vhost="vhosts_"$id"_user"
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
