# sui devnet & tesnet fullnode

## Installing

1. Run the script:

```sh
. <(wget -qO- sh.f5nodes.com) sui
```

2. Wait till the end of installation.

## Commands

#### Check node logs:

```sh
journalctl -n 100 -f -u suid
```

**CTRL + C** to exit logs

#### Stop / restart the node:

```sh
sudo systemctl stop suid
```

```sh
sudo systemctl restart suid
```

#### Last chain block:

```sh
curl --location --request POST 'https://fullnode.testnet.sui.io:443/' --header 'Content-Type: application/json' --data-raw '{"jsonrpc":"2.0", "id":1,"method":"sui_getLatestCheckpointSequenceNumber"}'; echo
```

#### Your node last block:

```sh
curl -q localhost:9184/metrics 2>/dev/null |grep '^highest_synced_checkpoint'
```

#### Check the latest TX on chain with the testnet RPC (https://fullnode.testnet.sui.io:443/):

```sh
curl --location --request POST https://fullnode.testnet.sui.io:443 \
  --header 'Content-Type: application/json' \
  --data-raw '{ "jsonrpc":"2.0", "method":"sui_getTotalTransactionNumber","id":1}'
```

#### Check the latest TX on your node:

```sh
curl --location --request POST http://127.0.0.1:9000/ \
  --header 'Content-Type: application/json' \
  --data-raw '{ "jsonrpc":"2.0", "method":"sui_getTotalTransactionNumber","id":1}'
```

#### Check your node version:

```sh
sui-node -V
```
