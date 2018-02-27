# https://hub.docker.com/r/cdns/scmodeldev/
# Stephen Engelman
# 2018
FROM ubuntu:16.04

RUN apt-get -y update && apt-get -y install apt-transport-https libgtk2.0-0 libxss1 libasound2 wget clang cmake make vim curl gnupg git && curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/trusted.gpg.d/microsoft.gpg && sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list' && apt-get -y update && apt-get -y install code

ENV CC /usr/bin/clang
ENV CXX /usr/bin/clang++
ENV DOWNLOADS /opt/downloads
ENV ACCELLERA_SYSTEMC_VER 2.3.2
ENV ACCELLERA_SYSTEMC_FILE_NOEXT systemc-$ACCELLERA_SYSTEMC_VER
ENV ACCELLERA_SYSTEMC_FILE $ACCELLERA_SYSTEMC_FILE_NOEXT.tar.gz
ENV ACCELLERA_SYSTEMC_URL http://www.accellera.org/images/downloads/standards/systemc/$ACCELLERA_SYSTEMC_FILE
ENV SYSTEMC_HOME /opt/tools/accellera/systemc
ENV DEVELOPER_USER devuser
ENV DEVELOPER_USER_HOME /home/$DEVELOPER_USER
ENV DEVELOPER_USER_WORK $DEVELOPER_USER_HOME/work
ENV EXAMPLE_PROJECT $DEVELOPER_USER_WORK/model_example

RUN mkdir -p $SYSTEMC_HOME && mkdir -p $DOWNLOADS && cd $DOWNLOADS && wget -c $ACCELLERA_SYSTEMC_URL && tar xfz $ACCELLERA_SYSTEMC_FILE && cd $ACCELLERA_SYSTEMC_FILE_NOEXT && ./configure --prefix=$SYSTEMC_HOME && make && make install
RUN useradd -ms /bin/bash $DEVELOPER_USER
RUN mkdir $DEVELOPER_USER_WORK && cd $DEVELOPER_USER_WORK && git clone https://github.com/engest/model_example.git && cd /home && chown -R devuser.devuser devuser && cd $EXAMPLE_PROJECT
USER $DEVELOPER_USER
ENV HOME $DEVELOPER_USER_HOME
RUN cd $DEVELOPER_USER_HOME && code --install-extension ms-vscode.cpptools
RUN cd $DEVELOPER_USER_HOME && code --install-extension mitaki28.vscode-clang
RUN cd $DEVELOPER_USER_HOME && code --install-extension twxs.cmake
RUN cd $DEVELOPER_USER_HOME && code --install-extension vector-of-bool.cmake-tools
RUN cd $DEVELOPER_USER_HOME && code --install-extension vscodevim.vim
WORKDIR $EXAMPLE_PROJECT
