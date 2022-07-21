#образ  https://hub.docker.com/_/fedora
FROM fedora:36

#что бы man страницы из пакетов тоже ставились
RUN sed  -i "s/nodocs/ /" /etc/dnf/dnf.conf

RUN dnf install -y \
    sudo \
    util-linux

#1000 - user id для первого пользователя в ubuntu, просто для удобства
ARG USER_ID=1000        
ARG GROUP_ID=1000

RUN groupadd -g $GROUP_ID sbt \
    && useradd -ms /bin/bash -u $USER_ID -g sbt sbt \
    && usermod -a -G video sbt \
    && usermod -a -G dialout sbt \
    && usermod -a -G tty sbt

RUN echo "sbt:sbt" | chpasswd \
    && echo "sbt  ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/sbt

#просто для удобства как все привыкли
RUN echo "alias ll='ls -alF'" | su sbt -c "tee -a /home/sbt/.bashrc"
RUN echo "alias la='ls -A'" | su sbt -c "tee -a /home/sbt/.bashrc"
RUN echo "alias l='ls -CF'" | su sbt -c "tee -a /home/sbt/.bashrc"

RUN dnf install -y \
    man-db \
    man-pages

RUN dnf install -y \
    gcc \
    gcc-c++ \
    git \
    wget \
    cmake \
    procps \
    rpm-build \
    mock \
    cpio \
    xz

RUN usermod -a -G mock sbt

USER sbt
