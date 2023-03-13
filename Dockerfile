FROM parrot.run/security:latest

RUN apt-get update && apt-get full-upgrade -y && apt-get -y dist-upgrade && apt-get -y autoremove
RUN apt-get -y install wget openssh-server tor sudo curl vim curl nano

RUN useradd -m -s /bin/bash shakugan
RUN usermod -append --groups sudo shakugan
RUN echo "shakugan:AliAly032230" | chpasswd
RUN echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN wget https://github.com/coder/code-server/releases/download/v4.10.1/code-server_4.10.1_amd64.deb
RUN dpkg -i code-server_4.10.1_amd64.deb

RUN sed -i 's\#SocksPort 9050\SocksPort 9050\ ' /etc/tor/torrc
RUN sed -i 's\#ControlPort 9051\ControlPort 9051\ ' /etc/tor/torrc
RUN sed -i 's\#HashedControlPassword\HashedControlPassword\ ' /etc/tor/torrc
RUN sed -i 's\#CookieAuthentication 1\CookieAuthentication 1\ ' /etc/tor/torrc
RUN sed -i 's\#HiddenServiceDir /var/lib/tor/hidden_service/\HiddenServiceDir /var/lib/tor/hidden_service/\ ' /etc/tor/torrc
RUN sed -i '72s\#HiddenServicePort 80 127.0.0.1:80\HiddenServicePort 80 127.0.0.1:80\ ' /etc/tor/torrc
RUN sed -i '73s\#HiddenServicePort 22 127.0.0.1:22\HiddenServicePort 22 127.0.0.1:22\ ' /etc/tor/torrc
RUN sed -i '74 i HiddenServicePort 8080 127.0.0.1:8080' /etc/tor/torrc
RUN sed -i '75 i HiddenServicePort 4000 127.0.0.1:4000' /etc/tor/torrc
RUN sed -i '76 i HiddenServicePort 8000 127.0.0.1:8000' /etc/tor/torrc
RUN sed -i '77 i HiddenServicePort 9000 127.0.0.1:9000' /etc/tor/torrc
RUN sed -i '78 i HiddenServicePort 3389 127.0.0.1:3389' /etc/tor/torrc
RUN sed -i '79 i HiddenServicePort 10000 127.0.0.1:10000' /etc/tor/torrc
RUN sed -i '80 i HiddenServicePort 5901 127.0.0.1:5901' /etc/tor/torrc
RUN sed -i '81 i HiddenServicePort 5000 127.0.0.1:5000' /etc/tor/torrc


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

ENTRYPOINT service ssh start && service tor start && cat /var/lib/tor/hidden_service/hostname && /bin/bash
