# Dockerfile
FROM texlive-full:2026

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# ロケール
RUN apt-get update && apt-get install -y --no-install-recommends locales && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen en_US.UTF-8 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 開発ツール（TeX Live はすでに base に入っている）
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    python3 \
    make \
    git \
    curl \
    sudo \
    ca-certificates \
    zip \
    unzip \
    fd-find \
    bat \
    fzf \
    ripgrep \
    openssh-client \
    libatomic1 \
    gnupg \
    dirmngr \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# コマンド名整合
RUN ln -sf /usr/bin/fdfind /usr/local/bin/fd && \
    ln -sf /usr/bin/batcat /usr/local/bin/bat

# ubuntuユーザー + sudo設定（bash運用）
RUN set -eux; \
    if ! id -u ubuntu >/dev/null 2>&1; then \
        useradd -m -s /bin/bash ubuntu; \
    fi; \
    usermod -aG sudo ubuntu; \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/010-sudo-nopasswd; \
    chmod 440 /etc/sudoers.d/010-sudo-nopasswd

# 作業ディレクトリ
RUN mkdir -p /workspace && chown ubuntu:ubuntu /workspace

USER ubuntu
ENV HOME=/home/ubuntu
WORKDIR /workspace

CMD ["/bin/bash"]
