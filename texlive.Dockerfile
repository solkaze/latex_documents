# texlive.Dockerfile
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone

# TeX Live installerに必要な最低限 + フォント類
RUN apt-get update && apt-get install -y --no-install-recommends \
    perl \
    wget \
    ca-certificates \
    xz-utils \
    tar \
    fontconfig \
    fonts-noto-core \
    fonts-noto-cjk \
    fonts-noto-mono \
    fonts-ipaexfont \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# --- TeX Live (Official installer) ---
ARG TEXLIVE_YEAR=2026
ENV TEXLIVE_DIR=/usr/local/texlive/${TEXLIVE_YEAR}

RUN set -eux; \
    mkdir -p /tmp/install-tl; \
    cd /tmp/install-tl; \
    wget -qO- https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz \
        | tar -xz --strip-components=1; \
    ./install-tl \
        --no-interaction \
        --texdir="${TEXLIVE_DIR}" \
        --scheme=scheme-full \
        --no-doc-install \
        --no-src-install; \
    rm -rf /tmp/install-tl

# PATH（非ログインシェルでも有効にするため ENV で設定）
ENV PATH="${TEXLIVE_DIR}/bin/x86_64-linux:${PATH}"

# パスを通す
RUN set -eux; \
    tlmgr path add
