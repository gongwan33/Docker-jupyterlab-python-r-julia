FROM ubuntu:18.04

# Install packages
RUN apt-get update
RUN apt-get install -y --no-install-recommends git python3 python3-pip gcc python3-dev make cmake g++ gfortran libpng-dev libfreetype6-dev libxml2-dev libxslt1-dev nodejs ca-certificates musl-dev wget python3-setuptools apt-utils libcurl4-gnutls-dev libssl-dev

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y --no-install-recommends r-base

RUN apt-get install -y --no-install-recommends build-essential autoconf libtool pkg-config python3-opengl python3-pil python-pyrex python3-pyside.qtopengl idle-python2.7 qt4-dev-tools qt4-designer libqtgui4 libqtcore4 libqt4-xml libqt4-test libqt4-script libqt4-network libqt4-dbus python-qt4 python-qt4-gl libgle3

# Install Jupyter
RUN pip3 install wheel
RUN pip3 install jupyter
RUN pip3 install ipywidgets
RUN jupyter nbextension enable --py widgetsnbextension

# Install JupyterLab
RUN pip3 install jupyterlab && jupyter serverextension enable --py jupyterlab

# Additional packages for compatability (glibc)
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub && \
  wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.23-r3/glibc-2.23-r3.apk && \
  wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.23-r3/glibc-i18n-2.23-r3.apk && \
  wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.23-r3/glibc-bin-2.23-r3.apk && \
  apk add --no-cache glibc-2.23-r3.apk glibc-bin-2.23-r3.apk glibc-i18n-2.23-r3.apk && \
  rm "/etc/apk/keys/sgerrand.rsa.pub" && \
  /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 C.UTF-8 || true && \
  echo "export LANG=C.UTF-8" > /etc/profile.d/locale.sh && \
  ln -s /usr/include/locale.h /usr/include/xlocale.h

COPY julia-1.1.1-linux-x86_64.tar.gz /usr/local/julia-1.1.1-linux-x86_64.tar.gz
RUN tar -xf /usr/local/julia-1.1.1-linux-x86_64.tar.gz -C /usr/local 
RUN echo PATH=\$PATH:/usr/local/julia-1.1.1/bin/ >> /etc/profile
RUN /bin/bash -c "source /etc/profile"

RUN cd /

ENV LANG=C.UTF-8

# Install Python Packages & Requirements (Done near end to avoid invalidating cache)
COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

COPY juliainit juliainit
RUN /usr/local/julia-1.1.1/bin/julia juliainit

COPY rinit rinit
RUN R --no-save < rinit

RUN pip3 install conda

# Expose Jupyter port & cmd
EXPOSE 8888
RUN mkdir -p /opt/app/data

CMD jupyter lab --ip=* --port=8888 --no-browser --notebook-dir=/opt/app/data --allow-root
