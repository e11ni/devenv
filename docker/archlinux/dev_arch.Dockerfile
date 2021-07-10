ARG image=archlinux:base-devel

FROM $image

ARG username=test
ARG uid=1001
ARG groupname=$username
ARG pw=docker

ARG http_proxy
ARG https_proxy
ARG no_proxy

ENV HTTP_PROXY=$http_proxy \
    http_proxy=$http_proxy \
    HTTPS_PROXY=$https_proxy \
    https_proxy=$https_proxy \
    no_PROXY=$no_proxy \
    no_proxy=$no_proxy

# RUN pacman -Syyu --noconfirm && pacman-db-upgrade && pacman -S --noconfirm \
#     git \
#     go

RUN sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) NOPASSWD:ALL/g' /etc/sudoers

# Setup user
RUN groupadd -r $groupname && \
    groupadd -r docker && \
    useradd -rm -s /bin/zsh -d /home/$username -u $uid -g $groupname -G wheel,docker,video $username && \
    echo "$username:$pw" | chpasswd && \
    mkhomedir_helper $username

USER $username
WORKDIR /home/$username

# COPY ./dotfiles/setup/install_utils.sh ./install_utils.sh
# COPY --chown=$username:$groupname ./dotfiles/* ./
# RUN source ./install_utils.sh && rm ./install_utils.sh
RUN curl -L https://raw.githubusercontent.com/e11ni/dotfiles/master/setup/install_utils.sh -o install_utils.sh && source ./install_utils.sh && rm ./install_utils.sh

# Finish steps
RUN sudo sed -i 's/%wheel ALL=(ALL) NOPASSWD:ALL/%wheel ALL=(ALL) ALL/g' /etc/sudoers

CMD [ "/bin/zsh" ]
