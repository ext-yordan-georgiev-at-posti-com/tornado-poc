do_check_install_os_packages(){

   do_perform_apt_get_install ${BASH_SOURCE} || { exit $?; }
   
}
