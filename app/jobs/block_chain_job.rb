class BlockChainJob < ApplicationJob
  def total_tx_count(block_hash)
    data = get_json_data(block_hash)
    total_tx = data["tx"]
    return total_tx.size
  end

  def avg_tx_value(block_hash)
    data = get_json_data(block_hash)
    total_tx = data["tx"]
    total_tx_value = 0
    total_tx.each do |tx|
      # out의 value를 합산하면 해당 트랜잭션의 value가 나옴
      tx["out"].each do |out|
        total_tx_value += out["value"]
      end
    end
    return total_tx_value / total_tx_count(block_hash).to_f
  end

  def avg_tx_fee(block_hash)
    data = get_json_data(block_hash)
    total_tx_fee = data["fee"]
    return total_tx_fee / total_tx_count(block_hash).to_f
  end

  def get_json_data(block_hash)
    uri = "https://blockchain.info/block-index/#{block_hash}?format=json"
    resp = Net::HTTP.get_response(URI.parse(uri))
    JSON.parse(resp.body)
  end
end
