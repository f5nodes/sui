#!/bin/bash

sudo systemctl stop suid
cd $HOME/sui
git fetch upstream
git checkout -B testnet --track upstream/testnet
cargo build --release --bin sui-node

sudo rm /usr/local/bin/sui-node
sudo mv $HOME/sui/target/release/sui-node /usr/local/bin/

sudo systemctl restart suid
git log -1

if [ "$language" = "uk" ]; then
  if [[ `service suid status | grep active` =~ "running" ]]; then
    echo -e "\n\e[93mSui Testnet Fullnode Оновлена\e[0m\n"
    echo -e "Подивитись логи ноди \e[92mjournalctl -n 100 -f -u suid\e[0m"
    echo -e "\e[92mCTRL + C\e[0m щоб вийти з логів\n"
  else
    echo -e "Ваша Sui нода \e[91mбула оновлена неправильно\e[39m, виконайте оновлення знову."
  fi
else
  if [[ `service suid status | grep active` =~ "running" ]]; then
    echo -e "\n\e[93mSui Testnet Fullnode Updated\e[0m\n"
    echo -e "Check node logs \e[92mjournalctl -n 100 -f -u suid\e[0m"
    echo -e "\e[92mCTRL + C\e[0m to exit logs\n"
  else
    echo -e "Your Sui Node \e[91mwas not updated correctly\e[39m, please reupdate."
  fi
fi