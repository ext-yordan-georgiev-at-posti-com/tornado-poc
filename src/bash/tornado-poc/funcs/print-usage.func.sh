doPrintUsage(){

   while read -r f ; do
      acts="${acts:-} "$(echo `basename $f`| perl -ne 's/^(.*?)\.func.sh$/$1/g;print') ;
   done < <(ls -1 src/bash/$RUN_UNIT/funcs/*.func.sh)

   test_script=$(dirname $0)"/$RUN_UNIT.sh"
   do_flush_screen
   cat << EOF_USAGE | tee -a ${log_file:-}

------------------------------------------------------------------------
--   This is the main shell entry point of the $RUN_UNIT
--
------------------------------------------------------------------------
   Purpose:
   run multiple actions passed in the --action cmd arg

   Usage:
   $0 -a <<action-name-01>> -a <<ation-name-02>> -a <<action-name-03>>

   where <<action-name> is one of the following:

   Note: you MUST always specify the box you are running on with the -b cmd arg

------------------------------------------------------------------------

EOF_USAGE
   echo $acts | tr ' ' '\n' ; echo -e "\n"

cat << EOF_US_03

# initialize the sysops VPC on the satellite host for the core-api project
./tornado-poc -b sat -a init-aws-ops-vpc -j core-api

# generate the ssh jump files on the satellite host for the core-api project
./tornado-poc -b sat -a generate-ssh-jump-scripts -j core-api

# destroy the sysops VPC infra on the satellite host for the core-api project
./tornado-poc -b sat -a destroy-aws-ops-vpc -j core-api

EOF_US_03

}
