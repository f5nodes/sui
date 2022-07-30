#!/bin/bash

sudo apt update && sudo apt install curl -y &>/dev/null
sudo apt-get update && DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC sudo apt-get install -y --no-install-recommends tzdata git ca-certificates libclang-dev cmake &>/dev/null
curl -s https://raw.githubusercontent.com/razumv/helpers/main/tools/install_ufw.sh | bash &>/dev/null
curl -s https://raw.githubusercontent.com/razumv/helpers/main/tools/install_rust.sh | bash &>/dev/null
source $HOME/.cargo/env
source $HOME/.profile
source $HOME/.bashrc
sleep 1

rm -rf /var/sui/db /var/sui/genesis.blob $HOME/sui $HOME/.sui
mkdir -p $HOME/.sui
git -C $HOME clone https://github.com/kuraassh/sui.git &>/dev/null
cd $HOME/sui
git remote add upstream https://github.com/MystenLabs/sui
git fetch upstream &>/dev/null
git checkout --track upstream/devnet &>/dev/null

cargo build --release
sudo mv $HOME/sui/target/release/{sui,sui-node,sui-faucet} /usr/bin/
wget -qO $HOME/.sui/genesis.blob https://github.com/MystenLabs/sui-genesis/raw/main/devnet/genesis.blob
cp $HOME/sui/crates/sui-config/data/fullnode-template.yaml $HOME/.sui/fullnode.yaml
sed -i -e "s%db-path:.*%db-path: \"$HOME/.sui/db\"%; "\
"s%metrics-address:.*%metrics-address: \"0.0.0.0:9184\"%; "\
"s%json-rpc-address:.*%json-rpc-address: \"0.0.0.0:9000\"%; "\
"s%genesis-file-location:.*%genesis-file-location: \"$HOME/.sui/genesis.blob\"%; " $HOME/.sui/fullnode.yaml

sudo tee <<EOF >/dev/null /etc/systemd/journald.conf
Storage=persistent
EOF
sudo systemctl restart systemd-journald

sudo tee <<EOF >/dev/null /etc/systemd/system/sui.service
[Unit]
  Description=SUI Node
  After=network-online.target
[Service]
  User=$USER
  ExecStart=/usr/bin/sui-node --config-path $HOME/.sui/fullnode.yaml
  Restart=on-failure
  RestartSec=3
  LimitNOFILE=65535
[Install]
  WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable sui &>/dev/null
sudo systemctl restart sui

if [ "$language" = "uk" ]; then
    echo -e "\n\e[93mSui Fullnode Installed\e[0m\n"
    echo -e "Подивитись логи ноди \e[92mjournalctl -n 100 -f -u sui\e[0m"
    echo -e "\e[92mCTRL + C\e[0m щоб вийти з логів\n"
    echo -e "Зайти в клієнт ноди \e[92msui client\e[0m"
    echo -e "Подивитись адресу гаманця \e[92msui keytool list\e[0m"
else
    echo -e "\n\e[93mMasa Finance Testnet\e[0m\n"
    echo -e "Check node logs \e[92mjournalctl -n 100 -f -u sui\e[0m"
    echo -e "\e[92mCTRL + C\e[0m to exit logs\n"
    echo -e "Open sui menu \e[92msui client\e[0m"
    echo -e "Check your wallet address \e[92msui keytool list\e[0m"
fi