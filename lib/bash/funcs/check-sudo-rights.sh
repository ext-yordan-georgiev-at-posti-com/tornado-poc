do_check_sudo_rights(){
   printf "INFO : Check sudo rights: "
   if sudo -n true 2>/dev/null; then
      printf "OK\n"
   else
      echo -e "sudo rights for user '$USER' do not exist !!! \nexiting ... \n"
      exit 1
   fi
}
