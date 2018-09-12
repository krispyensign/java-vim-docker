FROM centos:latest

WORKDIR /tmp

RUN yum -y install wget curl
RUN wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN yum install -y /tmp/epel-release-latest-7.noarch.rpm
RUN yum -y install python34-devel\
	python34-pip\
	java-1.8.0-openjdk\
	java-1.8.0-openjdk-devel\
	git\
	cargo\
	ncurses-devel\
	which\
	unzip\
	zip\
	make

RUN pip3 install neovim

RUN git clone https://github.com/vim/vim\
  && cd vim\
  && ./configure\
  && make\
  && make install

RUN useradd -ms /bin/bash vimuser
USER vimuser
WORKDIR /home/vimuser

RUN curl -s "https://get.sdkman.io" | bash
RUN source "$HOME/.sdkman/bin/sdkman-init.sh" && sdk install gradle 4.10
RUN source "$HOME/.sdkman/bin/sdkman-init.sh" && sdk install maven

RUN mkdir -p /home/vimuser/.vim/\
	&& git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

COPY vimrc /home/vimuser/.vimrc

RUN git clone https://github.com/eclipse/eclipse.jdt.ls\
	&& cd eclipse.jdt.ls\
	&& ./mvnw clean verify

RUN echo "\n" | vim +PluginInstall +qall

