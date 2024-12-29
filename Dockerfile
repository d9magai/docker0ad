# ベースイメージ: 軽量な Debian slim を使用
FROM debian:bullseye-slim

# 必要なパッケージをインストール
RUN apt-get update && apt-get install -y --no-install-recommends \
    0ad \
    locales \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Xvfb のディスプレイ番号と PulseAudio サーバー設定
ENV DISPLAY=:99
ENV PULSE_SERVER=unix:/tmp/pulseaudio.socket

# 日本語ロケールの設定
RUN echo "ja_JP.UTF-8 UTF-8" >> /etc/locale.gen && locale-gen
ENV LANG=ja_JP.UTF-8 LANGUAGE=ja_JP:ja LC_ALL=ja_JP.UTF-8

# 自動起動スクリプトをコンテナ内にコピーし、実行権限を付与
COPY start-0ad.sh /usr/local/bin/start-0ad.sh 
RUN chmod +x /usr/local/bin/start-0ad.sh 

# 新しい非 root ユーザーを作成し、sudo 権限を付与
RUN useradd -m -s /bin/bash gamer && echo "gamer ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# コンテナを非 root ユーザーで実行
USER gamer

# mod用ディレクトリを作成し、日本語modをコピー
RUN mkdir -p /home/gamer/.local/share/0ad/mods
COPY 0ad_ja-lang_mod /home/gamer/.local/share/0ad/mods/0ad_ja-lang_mod

# 0 A.D. 設定ファイルを作成してmodを有効化
RUN mkdir -p /home/gamer/.config/0ad/config/ && \
   echo "mod.enabledmods = \"mod public 0ad_ja-lang_mod\"" > /home/gamer/.config/0ad/config/user.cfg && \
   echo "playername.singleplayer = \"gamer\"" >> /home/gamer/.config/0ad/config/user.cfg

# 起動時のデフォルトコマンド 
CMD ["/usr/local/bin/start-0ad.sh"]

