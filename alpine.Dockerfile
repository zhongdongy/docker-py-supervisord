#
# 用于构建使用 Supervisord 的 Python 3.11 基础包
#
# Author: Zhongdong Yang
# Email: zhongdong_y@outlook.com
# Copyright: Zhongdong Yang
# Date: 2022-11-29
#

FROM alpine:3.17
USER root

WORKDIR /app

# ===
# Add all locales and set en_US.utf8 as default
# ===
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories
RUN echo "https://mirrors.tuna.tsinghua.edu.cn/alpine/edge/main" >> /etc/apk/repositories
RUN echo "https://mirrors.tuna.tsinghua.edu.cn/alpine/edge/testing" >> /etc/apk/repositories
RUN apk -U add vim curl dos2unix build-base linux-headers pcre-dev
ENV LANG en_US.utf8

# ==
# 安装必要的软件
# ==
# 1. Python 3.11.6-r0
RUN apk -U add python3=3.11.6-r0 python3-dev=3.11.6-r0 bash
RUN ln -sf /usr/bin/python3 /usr/bin/python
RUN python3 -m ensurepip
RUN pip3 install --upgrade pip


# 2. supervisor
RUN python3 -m pip install supervisor
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
CMD ["/bin/bash", "/app/startup.sh"]
