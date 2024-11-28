# Only one single output remains unspent from block 123,321. What address was it sent to?
block_hash=$(bitcoin-cli getblockhash 123321)
block_transactions=$(bitcoin-cli getblock $block_hash | jq -r ".tx[]")

for tx in $block_transactions; do
	tx_output_indexes=$(bitcoin-cli getrawtransaction "$tx" 1 | jq ".vout[].n")

	for index in $(echo "$tx_output_indexes"); do
	    utxo=$(bitcoin-cli gettxout $tx $index)
	    if [ ! -z "$utxo" ]; then
		echo "$utxo" | jq -r '.scriptPubKey.address'
		exit
            fi
	done
done
