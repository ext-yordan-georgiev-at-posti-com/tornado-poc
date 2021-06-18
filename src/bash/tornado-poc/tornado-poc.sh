#!/usr/bin/env bash

#------------------------------------------------------------------------------
# the main shell entry point of the application
#------------------------------------------------------------------------------
main(){
   ts=$(date "+%Y%m%d_%H%M%S")
   mkdir -p ~/var/log
   main_exec "$@" \
    > >(tee ~/var/log/tornado-poc-stdout-$ts.log) \
    2> >(tee ~/var/log/tornado-poc-stderr-$ts.log)
}

main_exec(){
   do_set_vars "$@"
   do_check_sudo_rights
   do_load_functions "$PRODUCT_DIR/src/bash/$RUN_UNIT/funcs"
   do_install_min_req_bins
   test -z "${actions:-}" && actions=' print-usage '
   do_run_actions "$actions" "$(find "$PRODUCT_DIR/src/bash/$RUN_UNIT/funcs/" -type f -name '*.func.sh' -exec basename {} .func.sh \;|sed -e "s/\b\(.\)/\u\1/g"|sed -e 's/-//g'|sed -e 's/[^ ]* */do&/g')"
   do_finalize
}

do_set_vars(){
   umask 022
   set -u -o pipefail
   unit_run_dir=$(perl -e 'use File::Basename; use Cwd "abs_path"; print dirname(abs_path(@ARGV[0]));' -- "$0")
   
   # register the run-time vars before the call of the $0
   tmp_dir="$unit_run_dir/tmp/.tmp.$$"
mkdir -p "$tmp_dir"
   ( set -o posix ; set )| sort >"$tmp_dir/vars.before"
   
   export PRODUCT_DIR=$(cd $unit_run_dir/../../.. ; echo `pwd`)
   source "$PRODUCT_DIR/lib/bash/funcs/load-lib-functions.sh" && do_load_lib_functions

   do_set_product_vars
   do_read_cmd_args 'print-usage' "$@"
   do_set_tgt_vars

   # register the run-time vars after the call of the $0
   ( set -o posix ; set ) | sort >"$tmp_dir/vars.after"

   do_log "INFO # --------------------------------------"
   do_log "INFO #       ::: START MAIN ::: $RUN_UNIT"
   do_log "INFO # --------------------------------------"

   echo -e "\nINFO: Using the following variables:"
   cmd=$(comm -3 $tmp_dir/vars.before $tmp_dir/vars.after | perl -ne 's#\s+##g;print "$_ \n"')
   echo -e "$cmd\n"
}

# ------------------------------------------------------------------------------
# perform the checks to ensure that all the vars needed to run are set
# ------------------------------------------------------------------------------
do_install_min_req_bins(){
   do_perform_apt_get_install $((test -L "$0" && readlink $PRODUCT_DIR/$(basename "$0")) || echo $PRODUCT_DIR/src/bash/$RUN_UNIT/$(basename "$0")) || { exit $?; }
}
# )

do_finalize(){
   rm -rf "$unit_run_dir/tmp"  #clear the tmpdir
   do_flush_screen
   cat << EOF_INIT_MSG
   :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
         $RUN_UNIT Shell script run completed :::  $RUN_UNIT
   :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
EOF_INIT_MSG
}

# basically there are very few reason why you should be able to change the src code
# on a non-working instance, thus to prevent regression tests each commit runs them
# locally 


# Action !!!
main "$@"

#
#----------------------------------------------------------
# Purpose:
# the main entry point of the app - runs shell actions 
# -a <<run-shell-action>> which a doRunShellAction func
#----------------------------------------------------------
# a vars
# ${VAR:=default_value}
# var=10 ; if ! ${var+false};then echo "is set";else echo "NOT set";fi # prints is set
# unset var ; if ! ${var+false};then echo "is set";else echo "NOT set";fi # prints NOT set
# +--------------------+----------------------+-----------------+-----------------+
# |                    |       parameter      |     parameter   |    parameter    |
# |                    |   Set and Not Null   |   Set But Null  |      Unset      |
# +--------------------+----------------------+-----------------+-----------------+
# | ${parameter:-word} | substitute parameter | substitute word | substitute word |
# | ${parameter-word}  | substitute parameter | substitute null | substitute word |
# | ${parameter:=word} | substitute parameter | assign word     | assign word     |
# | ${parameter=word}  | substitute parameter | substitute null | assign word     |
# | ${parameter:?word} | substitute parameter | error, exit     | error, exit     |
# | ${parameter?word}  | substitute parameter | substitute null | error, exit     |
# | ${parameter:+word} | substitute word      | substitute null | substitute null |
# | ${parameter+word}  | substitute word      | substitute word | substitute null |
# +--------------------+----------------------+-----------------+-----------------+
#
# ${var+blahblah}: if var is defined, 'blahblah' is substituted for the expression, else null is
# substituted
# ${var-blahblah}: if var is defined, it is itself substituted, else 'blahblah' is substituted
# ${var?blahblah}: if var is defined, it is substituted, else the function exists with 'blahblah' as
# an error message.
#----------------------------------------------------------
#  EXIT CODES
# 0 --- Successfull completion
# 1 --- error 
#----------------------------------------------------------
#
#
# eof file
