# Which public key signed input 0 in this tx:
#   `e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163`
tx=$(bitcoin-cli getrawtransaction "e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163" 1)

witness_res=$(echo "$tx" | jq -r '.vin[].txinwitness[1]') # Ex.: "01"
witness_redeem=$(echo "$tx" | jq -r '.vin[].txinwitness[2]')

pubkeys_script=$(bitcoin-cli decodescript "$witness_redeem" | jq -r '.asm')
pubkeys=($(echo "$pubkeys_script" | jq -R 'split(" ") | map(select(length == 66)) | .[]'))

if [ "$witness_res" = "01" ]; then
    echo "${pubkeys[0]}" | jq -r 
else
    echo "${pubkeys[1]}" | jq -r 
fi
