FROM ubuntu:20.04
MAINTAINER SHAKUGAN <shakugan@disbox.net>

RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
RUN apt update && apt-get upgrade -y
RUN apt-get install tzdata locales
RUN locale-gen en_US.UTF-8

RUN apt-get install -y openssh-server sudo curl vim wget openssh-server build-essential net-tools dialog apt-utils libevent* libsecret*
RUN wget https://deb.torproject.org/torproject.org/pool/main/t/tor/tor_0.4.7.13-1~jammy+1_amd64.deb
RUN dpkg -i tor_0.4.7.13-1~jammy+1_amd64.deb

RUN useradd -m -s /bin/bash shakugan
RUN usermod -append --groups sudo shakugan
RUN echo "shakugan:AliAly032230" | chpasswd
RUN echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN echo "HiddenServiceDir /var/lib/tor/onion-ssh/\n\
HiddenServicePort 22 127.0.0.1:22\n"\
>> /etc/tor/torrc

RUN mv /etc/ssh/sshd_config /etc/ssh/backup.sshd_config
RUN echo "Protocol 2\n\
IgnoreRhosts yes\n\
HostbasedAuthentication no\n\
PermitRootLogin no\n\
PermitEmptyPasswords no\n\
X11Forwarding no\n\
MaxAuthTries 5\n\
ClientAliveInterval 900\n\
ClientAliveCountMax 0\n\
Subsystem sftp internal-sftp\n\
UsePAM yes\n\
HostKey /etc/ssh/ssh_host_ed25519_key\n\
HostKey /etc/ssh/ssh_host_rsa_key\n\
KexAlgorithms curve25519-sha256@libssh.org\n\
Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr\n\
MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com\n"\
>> etc/ssh/sshd_config

ENTRYPOINT service ssh start && service tor start && /bin/bash
