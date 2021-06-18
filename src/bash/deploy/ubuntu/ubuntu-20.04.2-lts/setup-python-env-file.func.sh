do_setup_python_env_file(){

   source $PRODUCT_DIR/lib/bash/funcs/load-aws-configs.sh ; do_load_aws_configs

   python3 "$PRODUCT_DIR/src/python/tpl_gen.py"

   env_file=$PRODUCT_DIR/src/python/.env
   perl -pi -e 'foreach $key(sort keys %ENV){ s|\$$key|$ENV{$key}|g}' "$env_file"
   perl -e 'foreach $key(sort keys %ENV){ print "echo \$$key key:$key \n, val:$ENV{$key} \n"}'

}
