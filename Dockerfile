FROM ubuntu:20.04
MAINTAINER SHAKUGAN <shakugan@disbox.net>

RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
RUN apt update && apt-get upgrade -y
RUN apt-get install tzdata locales
RUN locale-gen en_US.UTF-8

RUN apt-get install -y openssh-server sudo curl vim wget build-essential net-tools dialog apt-utils libevent* libsecret*
RUN wget https://deb.torproject.org/torproject.org/pool/main/t/tor/tor_0.4.7.13-1~focal+1_amd64.deb
RUN dpkg -i tor_0.4.7.13-1~focal+1_amd64.deb

RUN useradd -m -s /bin/bash shakugan
RUN usermod -append --groups sudo shakugan
RUN echo "shakugan:AliAly032230" | chpasswd
RUN echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN echo "HiddenServiceDir /var/lib/tor/onion-ssh/\n\
HiddenServicePort 22 127.0.0.1:22\n"\
>> /etc/tor/torrc

RUN mv /etc/ssh/sshd_config /etc/ssh/backup.sshd_config
RUN echo "Protocol 2" >> etc/ssh/sshd_config
RUN echo "IgnoreRhosts yes" >> etc/ssh/sshd_config
RUN echo "HostbasedAuthentication no" >> etc/ssh/sshd_config
RUN echo "PermitRootLogin no" >> etc/ssh/sshd_config
RUN echo "PermitEmptyPasswords no" >> etc/ssh/sshd_config
RUN echo "X11Forwarding no" >> etc/ssh/sshd_config
RUN echo "MaxAuthTries 5" >> etc/ssh/sshd_config
RUN echo "ClientAliveInterval 900" >> etc/ssh/sshd_config
RUN echo "ClientAliveCountMax 0" >> etc/ssh/sshd_config
RUN echo "Subsystem sftp internal-sftp" >> etc/ssh/sshd_config
RUN echo "UsePAM yes" >> etc/ssh/sshd_config
RUN echo "HostKey /etc/ssh/ssh_host_ed25519_key" >> etc/ssh/sshd_config
RUN echo "HostKey /etc/ssh/ssh_host_rsa_key" >> etc/ssh/sshd_config
RUN echo "KexAlgorithms curve25519-sha256@libssh.org" >> etc/ssh/sshd_config
RUN echo "Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr" >> etc/ssh/sshd_config
RUN echo "MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com" >> etc/ssh/sshd_config

EXPOSE 22
ENTRYPOINT service ssh start && service tor start && cat /var/lib/tor/onion-ssh/hostname && /bin/bash
