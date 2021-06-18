do_print_usage(){
   # if $run_unit is --help, then message will be "--help deployer PURPOSE"
   cat << EOF_USAGE
   :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
      This is the app eployer 
		PURPOSE: 
      to create the app base image from an Ubuntu 20.04 with 
      a single shell call by deploying and configuring : 
         - OS packages and utils
         - OS hardening for network rules and fstab
         - Perl and Python modules
         - NodeJS runtime and npm modules
         - strapi CMS 
         - Postgres db enginge, db roles etc

   The list of the functions to execute for provisioning with their order 
   is stored in the following file: 
   $PRODUCT_DIR/src/bash/deploy/ubuntu/ubuntu-20.04.2-lts/run.def

   you can specify in which run-time-environment to run by using the --mode cmd arg
   for example :
   $0 --mode lcl 
   will run in the local mode ( which is the default one ) 

   $0 --mode aws 
   will run in the aws run-time-environment

   :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
   

EOF_USAGE

   img=$(lsb_release -d|grep -i ubuntu |perl -ne '$s=lc($_);$s=~s| |-|g;print $s'|awk '{print $2}')

cat << EOF_US_02
   You can also execute one or multiple actions with the 
   $0 --action <<action-name>> 
   or 
   $0 -a <<action-name>> -a <<action-name-02>>

   where the <<action-name>> is one of the following
EOF_US_02
   find src/bash/deploy/ubuntu/$img/ -name *.func.sh \
      | perl -ne 's/(.*)(\/)(.*).func.sh/$3/g;print'| perl -ne 's/-/_/g;print "do_" . $_' | sort




   exit 1
}
