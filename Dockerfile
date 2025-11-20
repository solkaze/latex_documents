FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# TeXインストール
RUN apt-get update && apt-get install -y --no-install-recommends \
      make \
      perl \
      wget \
      git \
      latexmk \
      texlive-latex-base \
      texlive-latex-recommended \
      texlive-latex-extra \
      texlive-luatex \
      texlive-lang-japanese \
      texlive-fonts-recommended \
      texlive-extra-utils \
      locales \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# ロケール
RUN sed -i 's/^# *ja_JP.UTF-8/ja_JP.UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG=ja_JP.UTF-8 LC_ALL=ja_JP.UTF-8

WORKDIR /workspace
CMD ["/bin/bash"]
