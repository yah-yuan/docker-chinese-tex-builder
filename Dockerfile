FROM ubuntu:bionic
COPY resources/texcount.pl /root/.tools
ENV DEBIAN_FRONTEND noninteractive
RUN DEPENDS='texlive-xetex texlive-lang-chinese latex-cjk-chinese texlive-generic-recommended texlive-fonts-recommended ttf-mscorefonts-installer fontconfig'\
    && echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections\
    && apt-get update -y\
    && apt-get install -y $DEPENDS\
    && mkdir /root/playground /usr/share/fonts/WinFonts \
    && ln -s /root/.tools/texcount.pl /usr/bin/texcount \
    && apt-get clean
WORKDIR /root/playground
VOLUME [ "/root/playground" ]
CMD ["/bin/sh","-c","exit"]

# docker run --name tex-test tex:test