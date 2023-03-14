FROM parrot.run/security:latest

RUN apt-get update && apt-get full-upgrade -y && apt-get -y dist-upgrade && apt-get -y autoremove
RUN apt-get -y install wget openssh-server tor sudo curl vim curl nano

RUN useradd -m -s /bin/bash shakugan
RUN usermod -append --groups sudo shakugan
#RUN echo "Defaults    env_reset" >> /etc/sudoers
#RUN echo "Defaults    mail_badpass" >> /etc/sudoers
#RUN echo 'Defaults    secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin' >> /etc/sudoers
RUN echo "shakugan:AliAly032230" | chpasswd
#RUN echo "root    ALL=(ALL:ALL) ALL" >> /etc/sudoers
#RUN echo "%sudo   ALL=(ALL:ALL) ALL" >> /etc/sudoers
#RUN echo "@includedir /etc/sudoers.d" >> /etc/sudoers
RUN echo "%sudo   ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN chown root:root /usr/bin/sudo 
RUN chmod 4755 /usr/bin/sudo

RUN wget https://github.com/coder/code-server/releases/download/v4.10.1/code-server_4.10.1_amd64.deb
RUN dpkg -i code-server_4.10.1_amd64.deb

RUN sed -i 's\#SocksPort 9050\SocksPort 9050\ ' /etc/tor/torrc
RUN sed -i 's\#ControlPort 9051\ControlPort 9051\ ' /etc/tor/torrc
RUN sed -i 's\#HashedControlPassword\HashedControlPassword\ ' /etc/tor/torrc
RUN sed -i 's\#CookieAuthentication 1\CookieAuthentication 1\ ' /etc/tor/torrc
RUN sed -i 's\#HiddenServiceDir /var/lib/tor/hidden_service/\HiddenServiceDir /var/lib/tor/hidden_service/\ ' /etc/tor/torrc
RUN sed -i '72s\#HiddenServicePort 80 127.0.0.1:80\HiddenServicePort 80 127.0.0.1:80\ ' /etc/tor/torrc
RUN sed -i '73 i HiddenServicePort 22 127.0.0.1:22\ ' /etc/tor/torrc
RUN sed -i '74 i HiddenServicePort 8080 127.0.0.1:8080' /etc/tor/torrc
RUN sed -i '75 i HiddenServicePort 4000 127.0.0.1:4000' /etc/tor/torrc
RUN sed -i '76 i HiddenServicePort 8000 127.0.0.1:8000' /etc/tor/torrc
RUN sed -i '77 i HiddenServicePort 9000 127.0.0.1:9000' /etc/tor/torrc
RUN sed -i '78 i HiddenServicePort 3389 127.0.0.1:3389' /etc/tor/torrc
RUN sed -i '79 i HiddenServicePort 10000 127.0.0.1:10000' /etc/tor/torrc
RUN sed -i '80 i HiddenServicePort 5901 127.0.0.1:5901' /etc/tor/torrc
RUN sed -i '81 i HiddenServicePort 5000 127.0.0.1:5000' /etc/tor/torrc


RUN mkdir -p /var/run/sshd
RUN sed -i 's\#PermitRootLogin prohibit-password\PermitRootLogin yes\ ' /etc/ssh/sshd_config
RUN sed -i 's\#PubkeyAuthentication yes\PubkeyAuthentication yes\ ' /etc/ssh/sshd_config
RUN apt clean

RUN echo "service tor start" >> /VSCODETOr.sh
RUN echo "cat /var/lib/tor/hidden_service/hostname" >> /VSCODETOr.sh
RUN echo "service ssh start" >> /VSCODETOr.sh
RUN echo "code-server --bind-addr 127.0.0.1:10000 --auth none" >> /VSCODETOr.sh

RUN chmod 755 /VSCODETOr.sh
EXPOSE 22
CMD  ./VSCODETOr.sh

#ENTRYPOINT ./VSCODETOr.sh  && /bin/bash  #service ssh start && service tor start && cat /var/lib/tor/hidden_service/hostname && /bin/bash
