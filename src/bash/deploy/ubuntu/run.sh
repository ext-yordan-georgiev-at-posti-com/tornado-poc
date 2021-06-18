#!/usr/bin/env bash

#------------------------------------------------------------------------------
# the main shell entry point of the application
#------------------------------------------------------------------------------
main(){
   ts=$(date "+%Y%m%d_%H%M%S")
   mkdir -p ~/var/log
   main_exec "$@" \
    > >(tee ~/var/log/deploy_outall_$ts.log) \
    2> >(tee ~/var/log/deploy_outerr_$ts.log)
}

main_exec(){
   do_set_vars "$@"
   do_check_sudo_rights
   do_set_fs_permissions
   do_use_python_venv
   do_load_functions "$PRODUCT_DIR/src/bash/deploy/ubuntu/$img"
   do_install_min_req_bins
   do_set_conf_files

   test -z "${actions:-}" && {
      do_deploy_def_file
   }
   test -z "${actions:-}" || {
      do_run_actions "$actions" "$(find "$PRODUCT_DIR/src/bash/deploy/ubuntu/$img/" -type f -name '*.func.sh' -exec basename {} .func.sh \;|sed -e 's/-/_/g'|sed -e 's/[^ ]* */do_&/g')"
   }
   do_finalize
}

do_set_vars(){
   set -u -o pipefail

   export host_name="$(hostname -s)"

   img=$(lsb_release -d|grep -i ubuntu |perl -ne '$s=lc($_);$s=~s| |-|g;print $s'|awk '{print $2}')
   
   unit_run_dir=$(perl -e 'use File::Basename; use Cwd "abs_path"; print dirname(abs_path(@ARGV[0]));' -- "$0")
   
   export PRODUCT_DIR=$(cd $unit_run_dir/../../../.. ; echo `pwd`)
   source "$PRODUCT_DIR/lib/bash/funcs/load-lib-functions.sh" && do_load_lib_functions

   do_set_product_vars
   do_read_cmd_args 'do_print_usage' "$@"
   do_set_tgt_vars

   # workaround for github actions running on docker
   export GROUP=$(ps -o group,supgrp $$|tail -n 1|awk '{print $1}')
   test -z ${USER:-} || export USER=$(id -un)
   #test -z ${GROUP:-} || export GROUP=$(id -gn)
   #test -z ${UID:-} || export UID=$(id -u)
   test -z ${GID:-} || export GID=$(id -g)
}


do_install_min_req_bins(){
   do_perform_apt_get_install $((test -L "$0" && readlink $PRODUCT_DIR/$(basename "$0")) || echo $PRODUCT_DIR/src/bash/deploy/ubuntu/$(basename "$0")) || { exit $?; }
}

do_set_fs_permissions(){

   chmod 700 $PRODUCT_DIR ; sudo chown -R $USER:$GROUP $PRODUCT_DIR

   # User chmod rwx to source dirs.
   for dir in `echo lib src cnf`; do 
      chmod -R 0700 $PRODUCT_DIR/$dir ;
   done  ;

   # User chmod rwx to sh and py files and rw- to all other files from source dirs.
   for dir in "$PRODUCT_DIR/cnf" "$PRODUCT_DIR/lib" "$PRODUCT_DIR/src"; do
      find $dir -type f -not -path */node_modules/* \( -name '*.*' ! -name '*.sh' ! -name '*.py' \) -exec chmod 600 {} \;
      find $dir -type f -not -path */node_modules/* \( -name '*.sh' -or -name '*.py' \) -exec chmod 700 {} \;
   done
}

do_finalize(){
   do_flush_screen
   cat << EOF_INIT_MSG_NO_BOOT
   :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
         $RUN_UNIT binary deployment completed successfully. 
   :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
EOF_INIT_MSG_NO_BOOT
}

do_deploy_def_file(){
   box_definition_file=$TGT_PROJ_DIR/src/bash/deploy/ubuntu/$img/run.def.$BOX
   test -f $box_definition_file || {
      echo "missing box_definition_file: $box_definition_file !!!" && exit 1
   }
   current_box_definition_file=$TGT_PROJ_DIR/src/bash/deploy/ubuntu/$img/run.def
   cp -v $box_definition_file $current_box_definition_file

   deploy_step_funcs=($(cat $current_box_definition_file))
   echo "INFO : running the following functions:"
   echo "${deploy_step_funcs[@]}"| perl -ne 's|^|\t|g;s| |\n\t|g;print'
   for i in ${!deploy_step_funcs[*]}
   do
      run_step=${deploy_step_funcs[$i]}
      do_log "INFO START $run_step"
      printf "INFO : $(( $i + 1 ))/${#deploy_step_funcs[*]} $run_step \n\n";
      $run_step
      do_log "INFO STOP $run_step"
      sleep 1 ; do_flush_screen
   done
}

main "$@"
