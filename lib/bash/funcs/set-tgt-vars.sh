do_set_tgt_vars() {
  test -z ${TGT_PROJ:-} && export TGT_PROJ=$RUN_UNIT
  test -z ${TGT_PROJ_DIR:-} && export TGT_PROJ_DIR=$PRODUCT_DIR
  test "${TGT_PROJ_DIR:0:1}" = "/" || TGT_PROJ_DIR=$(dirname $PRODUCT_DIR)/$TGT_PROJ_DIR
  test -f $TGT_PROJ_DIR/.env || echo "ERROR : the .env file does not exist for \"$TGT_PROJ\" !!!" ; test -f $TGT_PROJ_DIR/.env || exit 1

  export TGT_PROJ_VER=$(cat $TGT_PROJ_DIR/.env |grep -i version|cut -d'=' -f2)
  export TGT_PROJ_ENV=$(cat $TGT_PROJ_DIR/.env |grep -i env_type|cut -d'=' -f2)
}