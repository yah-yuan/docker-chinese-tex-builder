FROM ubuntu:bionic
ENV DEBIAN_FRONTEND noninteractive
RUN DEPENDS='texlive-xetex texlive-lang-cjk ttf-mscorefonts-installer texlive-lang-chinese'\
    && apt-get update -y\
    && apt-get install -y --no-install-recommends $DEPENDS\
    && mkdir /root/playground \
    && apt-get clean

    fontconfig

    auctex
    /usr/share/texlive/texmf-dist/tex/latex
    apt-get install texlive-lang-chinese                    good
    apt install latex-cjk-chinese-arphic-gkai00mp latex-cjk-chinese-arphic-gbsn00lp latex-cjk-chinese-arphic-bsmi00lp latex-cjk-chinese-arphic-bkai00mp latex-cjk-chinese cjk-latex latex-cjk-all

    cd /usr/share/texlive/texmf-dist/tex/latex/ctex/fontset