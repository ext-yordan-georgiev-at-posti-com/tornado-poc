FROM ubuntu:20.04

ARG UID
ARG GID

EXPOSE 8888

# Mimic standard ec2 with ubuntu:ubuntu
# could be parametrized.
ENV USR="ubuntu"
ENV GRP="ubuntu"
ENV TERM="xterm-256color"
ENV TZ="Etc/UTC"
ENV PRODUCT_DIR="/opt/tornado-poc"

VOLUME $PRODUCT_DIR

RUN echo \n\
XKBMODEL="pc105" \n\
XKBLAYOUT="se" \n\
XKBVARIANT="" \n\
XKBOPTIONS="" \n\
BACKSPACE="guess" \n\
 > /etc/default/keyboard

RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get upgrade -y && \
      apt-get install -y --no-install-recommends apt-utils
RUN export DEBIAN_FRONTEND=noninteractive && ln -fs /usr/share/zoneinfo/UTC /etc/localtime && \
      apt-get install -y --no-install-recommends tzdata && dpkg-reconfigure --frontend noninteractive tzdata
RUN export DEBIAN_FRONTEND=noninteractive && apt-get install -y python3.8 lsb-release sudo curl net-tools wget \
      git zip unzip build-essential linux-headers-5.4.0-1037-aws perl make vim ufw jq snapd debconf-utils dialog telnet
RUN export DEBIAN_FRONTEND=noninteractive && apt-get install -y python3-pip python3-distutils python3-testresources \
      python3.8-dev python3.8-venv
RUN export DEBIAN_FRONTEND=noninteractive && apt-get clean all && apt-get install --fix-missing

RUN ln -sfn /usr/bin/python3.8 /usr/bin/python
RUN ln -sfn /usr/bin/python3.8 /usr/bin/python3

# Enable host to container edit of proj code on ubuntu and mac.
RUN test -z $(getent group $GID | cut -d: -f1) || \
      groupmod -g $((GID+1000)) $(getent group $GID | cut -d: -f1)

RUN addgroup --gid $GID $USR
RUN adduser \
      --gid $GID \
      --shell "/bin/bash" \
      --home "/home/$USR" \
      --uid $UID \
      $USR && exit 0 

RUN echo "ubuntu:1432@lAFk" | chpasswd
RUN echo "$USR ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER $USR
ENV USER=$USR
ENV GROUP=$GRP

ADD --chown=$USR:$GRP "." "$PRODUCT_DIR"
WORKDIR $PRODUCT_DIR

RUN $PRODUCT_DIR/src/bash/deploy/ubuntu/run.sh -a do_check_install_poetry \
   && $PRODUCT_DIR/src/bash/deploy/ubuntu/run.sh -a do_check_install_poetry_proj

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"
