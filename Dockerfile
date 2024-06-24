FROM dyne/devuan:daedalus

WORKDIR /root
RUN apt update && \
    apt install -y openrc policycoreutils sysvinit-core && \
    apt install -y sudo gpg openssh-server && \
    apt install -y -y apt-transport-https ca-certificates curl && \
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg && \
    chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg && \
    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list && \
    chmod 644 /etc/apt/sources.list.d/kubernetes.list && \
    apt update && \
    apt install -y kubectl wget tmux vim make && \
    rc-update add ssh && \
    groupadd -g 1000 kenhou && \
    useradd -m -u 1000 -g 1000 kenhou && \
    sed -i 's/\/bin\/sh/\/bin\/bash/' /etc/passwd && \
    printf 'kenhou\tALL=NOPASSWD:\tALL' > /etc/sudoers.d/kenhou && \
    mkdir /root/.ssh && \
    curl https://github.com/kenh0u.keys | tee /root/.ssh/authorized_keys && \
    cd /home/kenhou && \
    cp -r /root/.ssh ./ && \
    chown -R kenhou:kenhou .ssh && \
    sudo -u kenhou git clone https://github.com/kenh0u/.dotfiles.git && \
    cd .dotfiles && \
    sudo -u kenhou make install && \
    make install && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/sbin/init"]
