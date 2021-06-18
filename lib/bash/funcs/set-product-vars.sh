do_set_product_vars() {
  export RUN_UNIT=$(basename $PRODUCT_DIR)

  test -f $PRODUCT_DIR/.env || { 
    echo "ERROR : the .env file does not exist for \"$RUN_UNIT\" !!!"; 
    exit 1;
  }
}