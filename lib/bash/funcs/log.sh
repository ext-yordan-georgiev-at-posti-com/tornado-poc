#------------------------------------------------------------------------------
# echo pass params and print them to a log file and terminal
# usage:
# do_log "INFO some info message"
# do_log "ERROR some debug message"
#------------------------------------------------------------------------------
do_log(){
   type_of_msg=$(echo $*|cut -d" " -f1)
   msg="$(echo $*|cut -d" " -f2-)"
   echo "[$type_of_msg] `date "+%Y-%m-%d %H:%M:%S %Z"` [${RUN_UNIT:-}][@${host_name:-}] [$$] $msg"
}