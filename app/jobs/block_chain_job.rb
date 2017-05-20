class BlockChainJob < ApplicationJob
  def total_tx_count(block_hash)
    uri = "https://blockchain.info/block-index/#{block_hash}?format=json"
    resp = Net::HTTP.get_response(URI.parse(uri))
    data= JSON.parse(resp.body)

    total_tx = data["tx"]
    return total_tx.size
  end
end
