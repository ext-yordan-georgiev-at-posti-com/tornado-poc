do_setup_docker(){

   do_read_conf_section '.env'
   do_read_conf_section '.env.gitlab_runner'
   do_read_conf_section '.env.docker'

   # Set gitlab container registry url
   domain=$(hostname | cut -d'.' -f 2-3)
   registry_url="$ENV_TYPE-gitlab.$domain:5050"

   # Set docker image info
   git_hash=$(git log --pretty --format='%h'|head -n 1)
   image_tag="$registry_url/$gitlab_group/$TGT_PROJ"
   image_hash=$(docker images $image_tag -q)

   # Remove image if exists
   [ -z $image_hash ] || [ -z $(docker images $image_hash -q) ] || docker rmi $image_hash

   # Populate ports variable
   do_read_conf_section ".env.os_ports"
   export PORTS=$(jq '[ .env.os_ports | to_entries[] | .value ] | join(" ")' $PROJ_CONF_FILE | sed -e 's/^"//' -e 's/"$//')
   test -z "${PORTS:-}" && echo "FATAL Can't define PORTS variable from field os_ports in \"$PROJ_CONF_FILE\" file !!!" && exit 1

   # Build image
   cd $TGT_PROJ_DIR/src/docker/$TGT_PROJ && \
   docker build -t $image_tag \
        --build-arg TZ='Etc/UTC' \
        --build-arg USER=$USER \
        --build-arg UID=$UID \
        --build-arg GROUP=$GROUP \
        --build-arg GID=$GID \
        --build-arg ROOT_PASSWORD=$root_password \
        --build-arg USER_PASSWORD=$user_password \
        --build-arg PORTS="$PORTS" \
      .
   cd -

   docker images
   sleep 3

   #docker tag $image_tag $registry_url/$docker_registry_usr/$RUN_UNIT
   # docker tag [OPTIONS] IMAGE[:TAG] [REGISTRYHOST/][USERNAME/]NAME[:TAG]
   # src: https://stackoverflow.com/a/28349540

   # docker login at gitlab registry
   docker login $registry_url \
      -u $docker_registry_usr -p $docker_registry_pw

   # Push image to registry
   docker tag $image_tag $image_tag:$git_hash
   docker push $image_tag:$git_hash

}
