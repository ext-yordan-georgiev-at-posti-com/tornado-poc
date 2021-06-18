do_read_cmd_args() {

  print_usage=$1
  shift

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -a|--actions) shift && actions="${actions:-}${1:-} " && shift ;;
      -b|--box) shift && export BOX=${1:-} && shift ;;
      -h|--help) actions=$print_usage && shift && test -z ${BOX:-} && BOX=sat ;;
      -j|--target-project-dir) shift && export TGT_PROJ_DIR=${1:-} && export TGT_PROJ=$(basename $TGT_PROJ_DIR) && shift ;;
      *) echo "ERROR : unknown cmd arg: '$1' - invalid cmd arg, probably a typo !!!" && shift && exit 1
    esac
  done

  unset print_usage
  shift "$((OPTIND -1))"
}