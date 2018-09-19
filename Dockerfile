FROM alpine:edge as builder

WORKDIR /tmp

RUN apk update && apk add wget\
  curl\
  python3-dev\
  python3\
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
  maven\
  openjdk8

RUN pip3 install neovim

RUN git clone https://github.com/vim/vim\
  && cd vim\
  && ./configure --enable-python3interp=dynamic --enable-cscope --prefix=/usr/local\
  && make\
  && make install

RUN git clone https://github.com/universal-ctags/ctags\
  && cd ctags\
  && ./autogen.sh\
  && ./configure --prefix=/usr/local\
  && make\
  && make install

RUN adduser -h /home/vimuser -D -s /bin/bash vimuser
COPY vimrc /home/vimuser/.vimrc
COPY java-lsp.sh /home/vimuser/bin/java-lsp.sh
RUN chown -R vimuser:vimuser /home/vimuser/\
  && chmod +x /home/vimuser/bin/java-lsp.sh

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

RUN cd /home/vimuser/.vim/bundle/LanguageClient-neovim\
  && rm -fr build.rs Cargo.toml install.ps1 LICENSE.txt min-vimrc src tests\
            Cargo.lock ci INSTALL.md install.sh Makefile target TODO.md\
            .git .github .circleci .vscode .vim

######################################################################################################################
FROM alpine:edge
WORKDIR /tmp
RUN apk update && apk add wget\
  curl\
  python3-dev\
  python3\
  git\
  ncurses-dev\
  unzip\
  zip\
  bash\
  gcc\
  musl-dev\
  musl

RUN pip3 install neovim
RUN wget https://download.java.net/java/early_access/alpine/28/binaries/openjdk-11+28_linux-x64-musl_bin.tar.gz\
  && tar xvfz openjdk-11+28_linux-x64-musl_bin.tar.gz\
  && mkdir -p /opt/\
  && cp -fr jdk-11 /opt/java/\
  && rm -fr openjdk-11+28_linux-x64-musl_bin.tar.gz jdk-11
RUN cd /opt/\
  && wget https://services.gradle.org/distributions/gradle-4.10.1-bin.zip\
  && mkdir -p /opt/gradle\
  && unzip -d /opt/gradle gradle-4.10.1-bin.zip\
  && rm gradle-4.10.1-bin.zip
RUN adduser -h /home/vimuser -D -s /bin/bash vimuser
COPY vimrc /home/vimuser/.vimrc
COPY java-lsp.sh /home/vimuser/bin/java-lsp.sh
COPY --from=builder /usr/local/ /usr/local/
COPY --from=builder /home/vimuser/eclipse.jdt.ls /home/vimuser/eclipse.jdt.ls
COPY --from=builder /home/vimuser/.vim /home/vimuser/.vim
RUN chown -R vimuser:vimuser /home/vimuser/\
  && chmod +x /home/vimuser/bin/java-lsp.sh
USER vimuser
WORKDIR /home/vimuser

