#!/bin/bash

devnet_install="https://raw.githubusercontent.com/f5nodes/sui/main/devnet.sh"
devnet_update="https://raw.githubusercontent.com/f5nodes/sui/main/devnet_update.sh"
testnet_install="https://raw.githubusercontent.com/f5nodes/sui/main/testnet.sh"
testnet_update="https://raw.githubusercontent.com/f5nodes/sui/main/testnet_update.sh"

if [ "$language" = "uk" ]; then
    PS3='Виберіть опцію: '
    options=("Встановити devnet" "Оновити devnet" "Встановити testnet" "Оновити testnet" "Вийти з меню")
    selected="Ви вибрали опцію"
else
    PS3='Enter your option: '
    options=("Install the devnet" "Update the devnet" "Install the testnet" "Update the testnet" "Quit")
    selected="You choose the option"
fi

select opt in "${options[@]}"
do
    case $opt in
        "${options[0]}")
            echo "$selected $opt"
            sleep 1
            . <(wget -qO- $devnet_install)
            break
            ;;
        "${options[1]}")
            echo "$selected $opt"
            sleep 1
            . <(wget -qO- $devnet_update)
            break
            ;;
        "${options[2]}")
            echo "$selected $opt"
            sleep 1
            . <(wget -qO- $testnet_install)
            break
            ;;
        "${options[3]}")
            echo "$selected $opt"
            sleep 1
            . <(wget -qO- $testnet_update)
            break
            ;;
        "${options[4]}")
            echo "$selected $opt"
            break
            ;;
        *) echo "unknown option $REPLY";;
    esac
done