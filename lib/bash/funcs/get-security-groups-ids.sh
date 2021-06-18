#------------------------------------------------------------------------------
# this function exports the variables:
#
# $https_sg_id
# $ssh_sg_id
#
# usage example:
# source $PRODUCT_DIR/lib/bash/funcs/get-security-groups-ids.sh
# do_get_security_groups_ids "ops"
#------------------------------------------------------------------------------
do_get_security_groups_ids(){

   do_read_conf_section '.env'

   prefix="$1"
   https_sg_name="${prefix}_sgr_${PROJ}_${ENV_TYPE}_${VER}_https"
   ssh_sg_name="${prefix}_sgr_${PROJ}_${ENV_TYPE}_${VER}_ssh"

   ids=$(aws ec2 describe-security-groups --filter "Name=group-name,Values=$https_sg_name,$ssh_sg_name" \
   --query "SecurityGroups[*].GroupId" --output text)

   export https_sg_id=$(echo $ids | cut -d " " -f 1)
   export ssh_sg_id=$(echo $ids | cut -d " " -f 2)

}
