do_set_conf_files(){
   test -z ${BOX:-} && export BOX=sat
   test -z ${BOX:-} && \
      echo "ERROR : you MUST specify the box to pick the right box config file !!!" && exit 1
   
   source $PRODUCT_DIR/.env ; export ENV_TYPE
   export PROJ_CONF_FILE="$PRODUCT_DIR/cnf/env/$ENV_TYPE.env.json"
   test -f $PROJ_CONF_FILE && rm -v $PROJ_CONF_FILE

   box_conf_file="$TGT_PROJ_DIR/cnf/env/$ENV_TYPE.$BOX.env.json"
   test -f $box_conf_file || {
      echo "ERROR : the box_conf_file: $box_conf_file does not exist" && exit 1;
   }
   cp -v $box_conf_file $PROJ_CONF_FILE

   secrets_conf_fle=~/.$TGT_PROJ/v$TGT_PROJ_VER/env/$ENV_TYPE.env.json
   box_conf_secret_fle=~/.$TGT_PROJ/v$TGT_PROJ_VER/env/$ENV_TYPE.$BOX.env.json
   test -f $box_conf_secret_fle || \
      echo "WARNING : the box_conf_secret_fle: $box_conf_secret_fle does not exist"
   
   test -f $box_conf_secret_fle && {
      test -f $secrets_conf_fle && rm -v $secrets_conf_fle
      cp -v $box_conf_secret_fle $secrets_conf_fle
      test -f $secrets_conf_fle && PROJ_CONF_FILE=$secrets_conf_fle
   }
   echo -e "INFO : using the following PROJ_CONF_FILE: $PROJ_CONF_FILE \n"
}
