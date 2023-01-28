# sui devnet & tesnet fullnode

Check the latest TX on chain with the testnet RPC (https://fullnode.testnet.sui.io:443/):

```bash
curl --location --request POST https://fullnode.testnet.sui.io:443 \
  --header 'Content-Type: application/json' \
  --data-raw '{ "jsonrpc":"2.0", "method":"sui_getTotalTransactionNumber","id":1}'
```

Check the latest TX on your node:

```bash
curl --location --request POST http://127.0.0.1:9000/ \
  --header 'Content-Type: application/json' \
  --data-raw '{ "jsonrpc":"2.0", "method":"sui_getTotalTransactionNumber","id":1}'
```
