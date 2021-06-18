do_run_actions(){

   actions=$1
   test -n "$actions" || {
      echo "ERROR : The actions argument is missing.";
      exit 1;
   }

   all_funcs=$2
   test -n "$all_funcs" || {
      echo "ERROR : The functions argument is missing.";
      exit 1;
   }

   run_funcs=''
   for arg_action in $actions ; do
      # If the action argument is not a deploy action, convert it to a boxer action.
      if [[ $(echo $arg_action | cut -c1-3) != 'do_' ]] ; then
         arg_action="$(echo $arg_action|sed -e "s/\b\(.\)/\u\1/g"|sed -e 's/-//g'|sed -e 's/[^ ]* */do&/g')"
      fi

      found_action=$(echo $all_funcs | grep -o -w $arg_action)
      if [[ $found_action == $arg_action ]] ; then
         run_funcs="$run_funcs $found_action"
      else
         echo "ERROR : action $arg_action is not a function."; exit 1
      fi
   done

   for run_func in $run_funcs ; do
      do_log "INFO START ::: running action :: $run_func"
      $run_func
      exit_code=$?
      if [[ $exit_code != "0" ]]; then
         echo "ERROR : function $run_func exited with code $exit_code"
         exit $exit_code
      fi
      do_log "INFO STOP ::: running action :: $run_func"
      sleep 1 ; do_flush_screen
   done
}
