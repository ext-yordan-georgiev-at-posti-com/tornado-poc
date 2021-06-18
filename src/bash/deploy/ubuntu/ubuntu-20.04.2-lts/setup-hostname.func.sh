do_setup_hostname(){

    do_read_conf_section ".env.box"
    sudo hostnamectl set-hostname "$dns_name"

}
