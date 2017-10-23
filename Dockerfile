FROM ubuntu:16.04

# Install core components

ENV DEBIAN_FRONTEND noninteractive
ENV LANG en_US.UTF-8
RUN apt-get update && apt-get dist-upgrade -y && apt-get autoremove -y && apt-get clean
RUN apt-get install -y curl gcc git make cmake python3 openssl sudo vim python3-dev python3-pip software-properties-common locales supervisor
RUN locale-gen en_US.UTF-8

RUN pip3 install --upgrade pip
RUN pip3 install -U dnspython urllib3 defang ftfy

RUN sed -i -e "s/from urllib2/#from urllib2/g" /usr/local/lib/python3.5/dist-packages/defang/__init__.py

WORKDIR /root
RUN git clone https://github.com/stricaud/faup.git && \
    cd faup && \
    mkdir install && \
    cd install && \
    cmake .. && \
    make && \
    make install

RUN echo '/usr/local/lib' | sudo tee -a /etc/ld.so.conf.d/faup.conf && \
    ldconfig

WORKDIR /root/faup/src/lib/bindings/python
RUN python3 setup.py install

WORKDIR /root
RUN rm -rf faup
RUN git clone https://github.com/MISP/mail_to_misp.git && cd mail_to_misp

WORKDIR /root/mail_to_misp
COPY mail_to_misp_config.py mail_to_misp_config.py
RUN ln -s mail_to_misp_config.py fake_smtp_config.py

# Supervisord Setup
RUN echo '[supervisord]' >> /etc/supervisor/conf.d/supervisord.conf
RUN echo 'nodaemon = true' >> /etc/supervisor/conf.d/supervisord.conf
RUN echo '' >> /etc/supervisor/conf.d/supervisord.conf
RUN echo '[program:fake_smtp]' >> /etc/supervisor/conf.d/supervisord.conf
RUN echo 'command=/bin/bash -c "/usr/bin/python3 fake_smtp.py"' >> /etc/supervisor/conf.d/supervisord.conf
RUN echo 'user = root' >> /etc/supervisor/conf.d/supervisord.conf
RUN echo 'startsecs = 0' >> /etc/supervisor/conf.d/supervisord.conf
RUN echo 'autorestart = false' >> /etc/supervisor/conf.d/supervisord.conf

WORKDIR /root/mail_to_misp
VOLUME /root/mail_to_misp
USER root
CMD sh -c "/usr/bin/python3 fake_smtp.py"

EXPOSE 25/TCP