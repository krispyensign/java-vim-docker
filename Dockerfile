FROM alpine:edge

WORKDIR /tmp

RUN apk update && apk add wget curl
RUN apk add python3-dev\
  git\
  cargo\
  ncurses-dev\
  unzip\
  zip\
  make\
  gcc\
  automake\
  autoconf\
  pkgconf\
  bash\
  gradle\
  maven

RUN pip3 install neovim

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

RUN adduser -h /home/vimuser -D -s /bin/bash vimuser

RUN mkdir -p /home/vimuser/bin
COPY vimrc /home/vimuser/.vimrc
COPY java-lsp.sh /home/vimuser/bin/java-lsp.sh
RUN chown -R vimuser:vimuser /home/vimuser/\
  && chmod +x /home/vimuser/bin/java-lsp.sh

RUN apk add openjdk8

USER vimuser
WORKDIR /home/vimuser

RUN mkdir -p /home/vimuser/.vim/\
  && git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

RUN git clone https://github.com/eclipse/eclipse.jdt.ls\
  && cd eclipse.jdt.ls\
  && ./mvnw clean verify -DskipTests

RUN echo "\n" | vim +PluginInstall +qall

RUN cd /home/vimuser/.vim/bundle/LanguageClient-neovim\
  && make release

USER root
WORKDIR /tmp

RUN cd /home/vimuser/.vim/bundle/LanguageClient-neovim\
  && rm -fr build.rs Cargo.toml install.ps1 LICENSE.txt min-vimrc src tests\
            Cargo.lock ci INSTALL.md install.sh Makefile target TODO.md\
            .git .github .circleci .vscode .vim

RUN apk del autoconf automake make gcc cargo openjdk8 pkgconf ncurses-dev
RUN rm -fr .cache .cargo .eclipse .gradle

RUN wget https://download.java.net/java/early_access/alpine/28/binaries/openjdk-11+28_linux-x64-musl_bin.tar.gz\
  && tar xvfz openjdk-11+28_linux-x64-musl_bin.tar.gz\
  && mkdir -p /opt/\
  && cp -fr jdk-11 /opt/java/\
  && rm -fr openjdk-11+28_linux-x64-musl_bin.tar.gz jdk-11

USER vimuser
WORKDIR /home/vimuser
RUN rm -fr .cache .cargo .eclipse .gradle .m2

