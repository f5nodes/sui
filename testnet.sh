#!/bin/bash

exists()
{
  command -v "$1" >/dev/null 2>&1
}
if exists curl; then
  echo ''
else
  sudo apt update && sudo apt install curl -y < "/dev/null"
fi
bash_profile=$HOME/.bash_profile
if [ -f "$bash_profile" ]; then
    . $HOME/.bash_profile
fi
echo -e 'Setting up swapfile...\n'
curl -s https://raw.githubusercontent.com/f5nodes/root/main/install/swap8.sh | bash

echo -e '\n\e[42mInstall software\e[0m\n' && sleep 1
sudo apt-get update
sudo apt-get install -y --no-install-recommends tzdata ca-certificates build-essential libssl-dev libclang-dev pkg-config openssl protobuf-compiler cmake
echo -e '\n\e[42mInstall Rust\e[0m\n' && sleep 1
sudo curl https://sh.rustup.rs -sSf | sh -s -- -y
source $HOME/.cargo/env

cd $HOME
git clone https://github.com/MystenLabs/sui.git
cd sui
git remote add upstream https://github.com/MystenLabs/sui
git fetch upstream
git checkout -B testnet --track upstream/testnet

mkdir $HOME/.sui
sudo mv $HOME/genesis.blob $HOME/.sui/genesis.blob
cp $HOME/sui/crates/sui-config/data/fullnode-template.yaml $HOME/.sui/fullnode.yaml
sed -i.bak "s|db-path:.*|db-path: \"$HOME\/.sui\/db\"| ; s|genesis-file-location:.*|genesis-file-location: \"$HOME\/.sui\/genesis.blob\"| ; s|127.0.0.1|0.0.0.0|" $HOME/.sui/fullnode.yaml

cargo build --release
sudo mv ~/sui/target/release/sui-node /usr/local/bin/
sudo mv ~/sui/target/release/sui /usr/local/bin/

echo "[Unit]
Description=Sui Node
After=network.target

[Service]
User=$USER
Type=simple
ExecStart=/usr/local/bin/sui-node --config-path $HOME/.sui/fullnode.yaml
Restart=on-failure
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target" > $HOME/suid.service

sudo mv $HOME/suid.service /etc/systemd/system/
sudo tee <<EOF >/dev/null /etc/systemd/journald.conf
Storage=persistent
EOF
sudo systemctl restart systemd-journald
sudo systemctl daemon-reload
sudo systemctl enable suid
sudo systemctl restart suid

if [ "$language" = "uk" ]; then
  if [[ `service suid status | grep active` =~ "running" ]]; then
    echo -e "\n\e[93mSui Testnet Fullnode Встановлена\e[0m\n"
    echo -e "Подивитись логи ноди \e[92mjournalctl -n 100 -f -u suid\e[0m"
    echo -e "\e[92mCTRL + C\e[0m щоб вийти з логів\n"
    echo -e "Зайти в клієнт ноди \e[92msui client\e[0m"
    echo -e "Подивитись адресу гаманця \e[92msui keytool list\e[0m"
  else
    echo -e "Ваша Sui нода \e[91mбула встановлена неправильно\e[39m, виконайте перевстановлення."
  fi
else
  if [[ `service suid status | grep active` =~ "running" ]]; then
    echo -e "\n\e[93mSui Testnet Fullnode Installed\e[0m\n"
    echo -e "Check node logs \e[92mjournalctl -n 100 -f -u suid\e[0m"
    echo -e "\e[92mCTRL + C\e[0m to exit logs\n"
    echo -e "Open sui menu \e[92msui client\e[0m"
    echo -e "Check your wallet address \e[92msui keytool list\e[0m"
  else
    echo -e "Your Sui Node \e[91mwas not installed correctly\e[39m, please reinstall."
  fi
fi