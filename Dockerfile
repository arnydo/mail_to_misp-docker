FROM ubuntu:trusty

# Install core components
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8 DEBIAN_FRONTEND=noninteractive TERM=xterm
RUN apt-get update && apt-get dist-upgrade -y && apt-get autoremove -y && apt-get clean
RUN apt-get install -y curl gcc git make python openssl sudo vim
RUN apt-get install -y python-dev python-pip libxml2-dev libxslt1-dev zlib1g-dev python-setuptools

ENV MISP_URL=${MISP_URL} MISP_API={$MISP_API}

RUN mkdir -p /srv/mail_to_misp

EXPOSE 25/TCP

WORKDIR /srv/mail_to_misp

ENTRYPOINT ["/bin/bash"]

#CMD ["python ./fake_smtp.py"]