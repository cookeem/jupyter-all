FROM jupyter/minimal-notebook:latest
MAINTAINER cookeem cookeem@qq.com

USER root

ENV JAVA_HOME=/usr/local/jdk1.8.0_151
ENV CLASSPATH=$JAVA_HOME/lib/tools.jar
ENV PATH=$JAVA_HOME/bin:$PATH
ENV SCALA_HOME=/usr/local/scala-2.11.11
ENV PATH=$SCALA_HOME/bin:$PATH
ENV SBT_HOME=/usr/local/sbt
ENV PATH=$SBT_HOME/bin:$PATH
ENV GOROOT=/usr/local/go
ENV PATH=$GOROOT/bin:$PATH
ENV GOPATH=/home/jovyan/gopath
ENV PATH=$GOPATH/bin:$PATH

# root
# install nodejs and npm
RUN apt update && \
apt install -y curl && \
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash - && \
apt-get install -y nodejs && \
apt-get install -y build-essential

# root
# install jdk
RUN wget http://dl.cookeem.com/jdk-8u151-linux-x64.tar.gz && \
tar zxvf jdk-8u151-linux-x64.tar.gz && \
mv jdk1.8.0_151 /usr/local/ && \
rm -rf jdk-8u151-linux-x64.tar.gz

# root
# install scala
RUN wget http://dl.cookeem.com/scala-2.11.11.tgz && \
tar zxvf scala-2.11.11.tgz && \
mv scala-2.11.11 /usr/local/ && \
rm -rf scala-2.11.11.tgz

# root
# install sbt
RUN wget http://dl.cookeem.com/sbt-1.0.2.tgz && \
tar zxvf sbt-1.0.2.tgz && \
mv sbt /usr/local/ && \
rm -rf sbt-1.0.2.tgz

# root
# install go
RUN wget http://dl.cookeem.com/go1.9.2.linux-amd64.tar.gz && \
tar zxvf go1.9.2.linux-amd64.tar.gz && \
mv go /usr/local/ && \
rm -rf go1.9.2.linux-amd64.tar.gz

# root
# install gophernotes dependency
RUN apt install -y pkg-config && \
apt-get install -y libzmq3-dev

# root
# install pip library
# RUN cd ~ && \
# mkdir -p ~/.pip && \
# echo '[global]\n\
# index-url = http://mirrors.aliyun.com/pypi/simple/\n\
# \n\
# [install]\n\
# trusted-host=mirrors.aliyun.com'\
# >> ~/.pip/pip.conf

RUN pip install jupyter_contrib_nbextensions && \
pip install scipy && pip install scikit-image && pip install tensorflow && \
jupyter contrib nbextension install --system

USER jovyan

# jovyan
RUN cd ~ && \
mkdir -p /home/jovyan/gopath && \
mkdir -p /home/jovyan/work

# jovyan
# npm config set registry http://registry.npm.taobao.org/

# jovyan
# install jupyter-scala
RUN git clone https://github.com/jupyter-scala/jupyter-scala && \
cd jupyter-scala && \
./jupyter-scala && \
cd .. && \
rm -rf jupyter-scala && \
jupyter kernelspec list

# jovyan
# install gophernotes
RUN go get -u -v github.com/gopherdata/gophernotes && \
mkdir -p ~/.local/share/jupyter/kernels/gophernotes && \
cp $GOPATH/src/github.com/gopherdata/gophernotes/kernel/* ~/.local/share/jupyter/kernels/gophernotes && \
jupyter kernelspec list

# jovyan
# install ijavascript
RUN npm install -g ijavascript && \
ijsinstall && \
jupyter kernelspec list

WORKDIR /home/jovyan/work
