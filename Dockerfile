# use
#     docker run --rm -ti -v $(pwd):/app/ eunts/java-eclipse-ssh-x11:latest
# to run

FROM openjdk:slim-buster

COPY run.sh /bin/run

RUN apt-get update && \
    apt-get install -y openssh-server && \
    passwd -d root && \
    sed -ri 's/^\s*(PermitRootLogin)/#\1/'                   /etc/ssh/sshd_config && \
    echo "PermitRootLogin yes"                           >> /etc/ssh/sshd_config && \

    sed -ri 's/^\s*(X11Forwarding)/#\1/'                     /etc/ssh/sshd_config && \
    echo "X11Forwarding yes"                             >> /etc/ssh/sshd_config && \

    sed -ri 's/^\s*(X11DisplayOffset)/#\1/'                 /etc/ssh/sshd_config && \
    echo "X11DisplayOffset 10"                           >> /etc/ssh/sshd_config && \

    sed -ri 's/^\s*(X11UseLocalhost)/#\1/'                  /etc/ssh/sshd_config && \
    echo "X11UseLocalhost no"                            >> /etc/ssh/sshd_config && \

    sed -ri 's/^\s*(ChallengeResponseAuthentication)/#\1/'  /etc/ssh/sshd_config && \
    echo "ChallengeResponseAuthentication no"            >> /etc/ssh/sshd_config && \

    sed -ri 's/^\s*(PasswordAuthentication)/#\1/'           /etc/ssh/sshd_config && \
    echo "PasswordAuthentication yes"                    >> /etc/ssh/sshd_config && \

    sed -ri 's/^\s*(UsePAM)/#\1/'                           /etc/ssh/sshd_config && \
    echo "UsePAM no"                                     >> /etc/ssh/sshd_config && \

    sed -ri 's/^\s*(PermitEmptyPasswords)/#\1/'             /etc/ssh/sshd_config && \
    echo "PermitEmptyPasswords yes"                      >> /etc/ssh/sshd_config && \

    sed -ri 's/^\s*(Compression)/#\1/'                      /etc/ssh/sshd_config && \
    echo "Compression no"                                >> /etc/ssh/sshd_config && \
    mkdir /var/run/sshd                                                          && \
    echo "export PATH=\$PATH:/usr/java/openjdk-13/bin/"   >> /etc/profile        && \
    apt-get install -y libgtk-3-dev wget && \
    wget -O /tmp/eclipse.tar.gz http://eclipse.mirror.garr.it/mirrors/eclipse/technology/epp/downloads/release/2019-12/R/eclipse-java-2019-12-R-linux-gtk-x86_64.tar.gz && \
    tar xzfv /tmp/eclipse.tar.gz && \
    mv eclipse /opt/ && \
    ln -s /opt/eclipse/eclipse /usr/sbin/


EXPOSE 22
ENTRYPOINT [ "run", "/usr/sbin/sshd", "-D", "-f", "/etc/ssh/sshd_config" ]
