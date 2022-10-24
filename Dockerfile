#
# 用于构建使用 Supervisord 的 Python 3.10 基础包
#
# Author: Zhongdong Yang
# Email: zhongdong_y@outlook.com
# Copyright: Zhongdong Yang
# Date: 2022-09-26
#

FROM ubuntu:focal
USER root

WORKDIR /app

# ===
# Add all locales and set en_US.utf8 as default
# ===
RUN apt-get update \
  && apt-get -y install ca-certificates software-properties-common curl dos2unix
RUN add-apt-repository -y 'ppa:deadsnakes/ppa'
RUN apt-get update && apt-get install -y locales apt-transport-https
RUN rm -rf /var/lib/apt/lists/*
RUN localedef -i en_US -c -f UTF-8 \
  -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

# ==
# 安装必要的软件
# ==
# 1. Python 3.10.x
RUN apt-get update && apt-get -y install software-properties-common
RUN apt-get update && apt-get -y install python3.10 python3.10-distutils python3.10-dev
RUN unlink /usr/bin/python3
RUN ln -s /usr/bin/python3.10 /usr/bin/python3
RUN curl -sS https://bootstrap.pypa.io/get-pip.py | /usr/bin/python3


# 2. supervisor
RUN /usr/bin/python3 -m pip install supervisor
RUN mkdir -p /app/_supervisor.d

# ==
# 更新配置文件并复制代码文件
# ==
# Flask
COPY config/supervisord.conf /etc/supervisor/supervisord.conf
COPY script/startup.sh /app/startup.sh
RUN mkdir -p /var/log/supervisord/
RUN dos2unix /app/startup.sh
RUN chmod +x /app/startup.sh
WORKDIR /app
ENTRYPOINT ["./startup.sh"]
