# How many new outputs were created by block 123,456?
block_hash=$(bitcoin-cli getblockhash 123456)
block=$(bitcoin-cli getblock $block_hash)
txids=$(echo $block | jq -r '.tx[]')
output_count=0

for txid in $txids; do
	raw_tx=$(bitcoin-cli getrawtransaction $txid true)
	outputs=$(echo $raw_tx | jq -C '.vout[]')
        num_outputs=$(echo $raw_tx | jq '.vout | length')
        output_count=$((output_count + num_outputs))
done

echo "$output_count"
