# Which tx in block 257,343 spends the coinbase output of block 256,128?
coinbase_blockhash=$(bitcoin-cli getblockhash 256128)
coinbase_block=$(bitcoin-cli getblock $coinbase_blockhash)
coinbase_block_id=$(echo "$coinbase_block" | jq -r ".tx[0]")
coinbase_transaction=$(bitcoin-cli getrawtransaction $coinbase_block_id 1 | jq -r ".txid")

target_blockhash=$(bitcoin-cli getblockhash 257343)
target_block=$(bitcoin-cli getblock $target_blockhash)
target_block_transactions=$(echo "$target_block" | jq -r ".tx[1:]")

for tx in $(echo "$target_block_transactions" | jq -r ".[]"); do
	candidate_transaction=$(bitcoin-cli getrawtransaction $tx 1)
	candidate_tx_inputs=$(echo "$candidate_transaction" | jq -r ".vin")
	candidate_tx_ids=$(echo "$candidate_tx_inputs" | jq -r ".[].txid")

	for candidate_id in $candidate_tx_ids; do
      	  if [ "$candidate_id" = "$coinbase_transaction" ]
          then
            echo "$candidate_transaction" | jq -r ".txid"
            exit
          fi
	done
done
