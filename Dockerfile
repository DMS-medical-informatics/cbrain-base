FROM centos:latest
RUN yum update -y  && yum install -y \
        git openssh \
        mariadb-devel \
        mariadb  \
        libyaml-devel \
        glibc-headers \
        autoconf \
        gcc-c++ \
        glibc-devel \
        patch \
        readline-devel \
        libffi-devel \
        make \
        bzip2 \
        automake \
        libtool \
        bison \
        sqlite-devel \
        libxml2 \
        libxml2-devel \
        libxslt \
    && useradd cbrain
USER cbrain
RUN gpg2 --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 && \
    cd $HOME && \
    \curl -sSL https://get.rvm.io | bash -s stable
ENV PATH $PATH:/home/cbrain/.rvm/bin:/home/cbrain/.rvm/rubies/ruby-2.2.1/bin
RUN source ~/.profile && \
    rvm install 2.2   && \
    rvm use 2.2       && \
    rvm --default 2.2 && \
    cd $HOME          && \
    git clone https://github.com/aces/cbrain.git && \
    gem install bundler
RUN cd $HOME/cbrain/BrainPortal    && \
    bundle install                 && \
    cd `bundle show sys-proctable` && \
    rake install                   && \
    cd $HOME/cbrain/BrainPortal    && \
    rake cbrain:plugins:install:all
RUN cd $HOME/cbrain/Bourreau       && \
    bundle install                 && \
    rake cbrain:plugins:install:plugins
EXPOSE [3000,22]
