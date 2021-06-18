do_setup_sync_time(){

    alive=$(systemctl status systemd-timesyncd.service | grep -i 'Active: active (running)')
    test -n "$alive" || {
        sudo systemctl start systemd-timesyncd.service; res=$?
        [[ res -eq 0 ]] ||  {
            echo "ERROR : Failed to activate the time synchronization service.";
            exit 1;
        }
        sleep 1
    }

    sudo timedatectl set-ntp true; res=$?
    [[ res -eq 0 ]] ||  {
        echo "ERROR : Failed to activate automatic time synchronization.";
        exit 1;
    }

    sleep 1

    timedatectl

}
