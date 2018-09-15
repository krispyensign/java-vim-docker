FROM centos:latest

WORKDIR /tmp

RUN yum -y install wget curl
RUN wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN yum install -y /tmp/epel-release-latest-7.noarch.rpm
RUN yum -y install python34-devel\
  python34-pip\
  git\
  cargo\
  ncurses-devel\
  which\
  unzip\
  zip\
  make\
  gcc\
  automake\
  autoconf

RUN pip3 install neovim

RUN wget --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" \
    http://download.oracle.com/otn-pub/java/jdk/10.0.1+10/fb4372174a714e6b8c52526dc134031e/jdk-10.0.1_linux-x64_bin.tar.gz\
  && tar zxf jdk-10.0.1_linux-x64_bin.tar.gz -C /usr/local\
  && mv /usr/local/jdk-10.0.1 /usr/local/jdk-10\
  && alternatives --install /usr/bin/java java /usr/local/jdk-10/bin/java 1\
  && alternatives --install /usr/bin/jar jar /usr/local/jdk-10/bin/jar 1\
  && alternatives --install /usr/bin/javac javac /usr/local/jdk-10/bin/javac 1\
  && alternatives --set jar /usr/local/jdk-10/bin/jar\
  && alternatives --set javac /usr/local/jdk-10/bin/javac

RUN git clone https://github.com/vim/vim\
  && cd vim\
  && ./configure --enable-python3interp\
  && make\
  && make install\
  && cd ..\
  && rm -fr vim

RUN git clone https://github.com/universal-ctags/ctags\
  && cd ctags\
  && ./autogen.sh\
  && ./configure\
  && make\
  && make install\
  && cd ..\
  && rm -fr ctags

RUN useradd -ms /bin/bash vimuser

RUN mkdir -p /home/vimuser/bin
COPY vimrc /home/vimuser/.vimrc
COPY java-lsp.sh /home/vimuser/bin/java-lsp.sh
RUN chown -R vimuser:vimuser /home/vimuser/\
  && chmod +x /home/vimuser/bin/java-lsp.sh

USER vimuser
WORKDIR /home/vimuser

RUN curl -s "https://get.sdkman.io" | bash
RUN source "$HOME/.sdkman/bin/sdkman-init.sh"\
  && sdk install gradle 4.10\
  && sdk install maven

RUN mkdir -p /home/vimuser/.vim/\
  && git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

RUN git clone https://github.com/eclipse/eclipse.jdt.ls\
  && cd eclipse.jdt.ls\
  && ./mvnw install -DskipTests

RUN echo "\n" | vim +PluginInstall +qall

RUN cd /home/vimuser/.vim/bundle/LanguageClient-neovim\
  && make release

RUN cd /home/vimuser/.vim/bundle/LanguageClient-neovim\
  && rm -fr build.rs Cargo.toml install.ps1 LICENSE.txt min-vimrc src tests\
            Cargo.lock ci INSTALL.md install.sh Makefile target TODO.md
RUN rm -fr .cache .cargo .eclipse .gradle

USER root
WORKDIR /tmp

RUN yum remove -y autoconf automake make gcc cargo
RUN yum clean all

USER vimuser
WORKDIR /home/vimuser

ENV JAVA_HOME /usr/local/jdk-10
ENV PATH $PATH:/usr/local/jdk-10/bin

