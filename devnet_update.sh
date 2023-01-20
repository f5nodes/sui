#!/bin/bash

if ! command -v curl &> /dev/null && ! command -v git &> /dev/null && ! command -v jq &> /dev/null; then
    sudo apt install -y curl git jq
fi

echo -e "\n\e[93mUpdate Started...\e[0m\n"
systemctl stop suid
rm -rf /var/sui/db/* /var/sui/genesis.blob $HOME/sui
source $HOME/.cargo/env
RELEASE_INFO=$(curl --silent https://api.github.com/repos/MystenLabs/sui/releases/latest)
TAG_NAME=$(echo $RELEASE_INFO | jq -r '.tag_name')
cd $HOME
git clone https://github.com/MystenLabs/sui.git
cd sui
git checkout $TAG_NAME
cargo build --bin sui-node --bin sui --release
mv ~/sui/target/release/sui-node /usr/local/bin/
mv ~/sui/target/release/sui /usr/local/bin/
wget -O /var/sui/genesis.blob https://github.com/MystenLabs/sui-genesis/raw/main/devnet/genesis.blob
systemctl restart suid


if [ "$language" = "uk" ]; then
    echo -e "\n\e[93mSui $TAG_NAME Оновлено\e[0m\n"
    echo -e "Подивитись логи ноди \e[92mjournalctl -n 100 -f -u suid\e[0m"
    echo -e "\e[92mCTRL + C\e[0m щоб вийти з логів\n"
    echo -e "Зайти в клієнт ноди \e[92msui client\e[0m"
    echo -e "Подивитись адресу гаманця \e[92msui keytool list\e[0m"
else
    echo -e "\n\e[93mSui $TAG_NAME Updated\e[0m\n"
    echo -e "Check node logs \e[92mjournalctl -n 100 -f -u suid\e[0m"
    echo -e "\e[92mCTRL + C\e[0m to exit logs\n"
    echo -e "Open sui menu \e[92msui client\e[0m"
    echo -e "Check your wallet address \e[92msui keytool list\e[0m"
fi