FROM debian

RUN apt-get update && \
    apt-get install -y --no-install-recommends gnupg ca-certificates && \
    rm -rf /var/lib/apt/lists/*
    
RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y qemu-kvm xz-utils dbus-x11 curl firefox-esr gnome-system-monitor mate-system-monitor git xfce4 xfce4-terminal tightvncserver wget fonts-wqy-zenhei

RUN wget https://github.com/novnc/noVNC/archive/refs/tags/v1.2.0.tar.gz

RUN curl -LO https://proot.gitlab.io/proot/bin/proot && \
    chmod 755 proot && \
    mv proot /bin

RUN tar -xvf v1.2.0.tar.gz
RUN mkdir $HOME/.vnc
RUN echo 'luo' | vncpasswd -f > $HOME/.vnc/passwd
RUN chmod 600 $HOME/.vnc/passwd

RUN echo 'whoami ' >>/luo.sh && \
    echo 'cd ' >>/luo.sh && \
    echo "su -l -c 'vncserver :2000 -geometry 1280x800' " >>/luo.sh && \
    echo 'cd /noVNC-1.2.0' >>/luo.sh && \
    echo './utils/launch.sh --vnc localhost:7900 --listen 8900 ' >>/luo.sh && \
    chmod 755 /luo.sh
    
EXPOSE 8900
CMD ["/luo.sh"]
