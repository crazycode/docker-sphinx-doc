FROM debian:wheezy

MAINTAINER crazycode

RUN   apt-get update

RUN   DEBIAN_FRONTEND=noninteractive apt-get install -y python-pip python-dev
RUN   DEBIAN_FRONTEND=noninteractive apt-get install -y texlive texlive-latex-recommended texlive-latex-extra texlive-fonts-recommended texlive-xetex
RUN   DEBIAN_FRONTEND=noninteractive apt-get install -y fontconfig latex-cjk-chinese fonts-wqy-microhei fonts-wqy-zenhei

RUN   pip install Sphinx
RUN   pip install sphinx_rtd_theme
RUN   pip install alabaster
RUN   pip install sphinx_bootstrap_theme

CMD ["/bin/bash"]
