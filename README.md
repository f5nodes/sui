# sui devnet & tesnet fullnode

```bash
curl --location --request POST https://fullnode.testnet.sui.io:443 \
  --header 'Content-Type: application/json' \
  --data-raw '{ "jsonrpc":"2.0", "method":"sui_getTotalTransactionNumber","id":1}'
```
