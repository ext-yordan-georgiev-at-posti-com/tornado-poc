do_load_functions(){

    path=$1
    test -n "$path" || {
      echo "ERROR : Argument path is missing.";
      exit 1;
    }

    while read -r f; do source $f; done < <(ls -1 $path/*.func.sh)
 }