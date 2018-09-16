FROM openjdk:11-slim

WORKDIR /tmp

RUN apt update && apt -y install wget curl
RUN apt -y install python3-dev\
  python3-pip\
  git\
  cargo\
  ncurses-dev\
  unzip\
  zip\
  make\
  gcc\
  automake\
  autoconf\
  pkg-config\
  bash

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

RUN useradd -ms /bin/bash vimuser

RUN mkdir -p /home/vimuser/bin
COPY vimrc /home/vimuser/.vimrc
COPY java-lsp.sh /home/vimuser/bin/java-lsp.sh
RUN chown -R vimuser:vimuser /home/vimuser/\
  && chmod +x /home/vimuser/bin/java-lsp.sh

USER vimuser
WORKDIR /home/vimuser

RUN curl -s "https://get.sdkman.io" | bash
RUN /bin/bash -c 'source "$HOME/.sdkman/bin/sdkman-init.sh"\
  && sdk install gradle 4.10\
  && sdk install maven'

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

RUN apt remove -y autoconf automake make gcc cargo

USER vimuser
WORKDIR /home/vimuser

