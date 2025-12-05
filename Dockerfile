FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ENV LANG=ja_JP.UTF-8
ENV LANGUAGE=ja_JP:ja
ENV LC_ALL=ja_JP.UTF-8

RUN apt-get update && apt-get install -y --no-install-recommends \
    locales \
    && locale-gen ja_JP.UTF-8 \
    && update-locale LANG=ja_JP.UTF-8 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# TeXインストール
RUN apt-get update && apt-get install -y \
    make \
    perl \
    wget \
    git \
    curl \
    sudo \
    ca-certificates \
    zsh \
    zip \
    unzip \
    fd-find \
    ripgrep \
    # latexmk はperl依存なのでこちらでもOKですが、下のTeXと一緒でも構いません
    latexmk \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 2. TeX関連：ここだけは --no-install-recommends を残してドキュメントを除外
RUN apt-get update && apt-get install -y --no-install-recommends \
    texlive-latex-base \
    texlive-latex-recommended \
    texlive-latex-extra \
    texlive-luatex \
    texlive-lang-japanese \
    texlive-fonts-recommended \
    texlive-extra-utils \
    texlive-bibtex-extra \
    biber \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN set -eux; \
    usermod -aG sudo ubuntu; \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/010-sudo-nopasswd; \
    chmod 440 /etc/sudoers.d/010-sudo-nopasswd

COPY .devcontainer/.p10k.zsh /tmp/.p10k.zsh

# root のうちにホームディレクトリに配置して chown する
RUN set -eux; \
    cp /tmp/.p10k.zsh /home/ubuntu/.p10k.zsh; \
    chown ubuntu:ubuntu /home/ubuntu/.p10k.zsh; \
    rm /tmp/.p10k.zsh

RUN chsh -s /usr/bin/zsh ubuntu

RUN mkdir /workspace && chown ubuntu:ubuntu /workspace

USER ubuntu
ENV HOME=/home/ubuntu
WORKDIR /workspace

# oh-my-zsh インストール
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

RUN echo '[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh' >> ~/.zshrc

# powerlevel10k テーマを oh-my-zsh に追加
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    ~/.oh-my-zsh/custom/themes/powerlevel10k && \
    sed -i 's|ZSH_THEME=".*"|ZSH_THEME="powerlevel10k/powerlevel10k"|' ~/.zshrc

# 外部 zsh プラグインのインストール
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting && \
    git clone https://github.com/zsh-users/zsh-history-substring-search ~/.oh-my-zsh/custom/plugins/history-substring-search && \
    git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions

# plugins 設定を差し替え
RUN sed -i 's/^plugins=.*/plugins=(\
    git \
    zsh-autosuggestions \
    zsh-syntax-highlighting \
    history-substring-search \
    zsh-completions \
    command-not-found \
    gitignore \
    aliases \
    docker \
    copyfile \
    copypath \
)/' ~/.zshrc

CMD ["/usr/bin/zsh"]
