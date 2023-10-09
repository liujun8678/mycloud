# 使用 Ubuntu 20.04 作为基础镜像
FROM ubuntu:20.04

# 更新软件包列表
RUN apt-get update

# 安装所需软件包，保持其余部分不变
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
  qemu-kvm \
  fonts-arphic-ukai fonts-arphic-uming xz-utils dbus-x11 curl firefox gnome-system-monitor mate-system-monitor git xfce4 xfce4-terminal tightvncserver wget

# 下载 noVNC
RUN wget https://github.com/novnc/noVNC/archive/refs/tags/v1.2.0.tar.gz

# 下载 proot
RUN curl -LO https://proot.gitlab.io/proot/bin/proot
RUN chmod 755 proot
RUN mv proot /bin

# 解压 noVNC
RUN tar -xvf v1.2.0.tar.gz

# 创建 .vnc 目录并设置密码
RUN mkdir $HOME/.vnc
RUN echo 'luo' | vncpasswd -f > $HOME/.vnc/passwd
RUN chmod 600 $HOME/.vnc/passwd

# 创建启动脚本
RUN echo 'whoami' >> /luo.sh
RUN echo 'cd' >> /luo.sh
RUN echo "su -l -c 'vncserver :2000 -geometry 1280x800'" >> /luo.sh
RUN echo 'cd /noVNC-1.2.0' >> /luo.sh
RUN echo './utils/launch.sh --vnc localhost:7900 --listen 8900' >> /luo.sh
RUN chmod 755 /luo.sh

# 暴露端口 8900
EXPOSE 8900

# 运行启动脚本
CMD /luo.sh

