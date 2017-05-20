class BlockChainJob < ApplicationJob
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

  def avg_tx_size(block_hash)
    data = get_json_data(block_hash)
    total_tx = data["tx"]
    total_tx_size = 0
    total_tx.each_with_index do |tx, index|
      total_tx_size += tx["size"]
    end
    return total_tx_size / total_tx_count(block_hash).to_f
  end

  def get_specific_type(block_hash, type)
    data = get_json_data(block_hash)
    total_tx = data["tx"]

    result_data = []
    total_tx.each do |tx|
      result_data.push(tx[type])
    end

    return result_data
  end

  def total_tx_count(block_hash)
    data = get_json_data(block_hash)
    return data["n_tx"]
  end

  def total_fee(block_hash)
    data = get_json_data(block_hash)
    return data["fee"]
  end

  def total_size(block_hash)
    data = get_json_data(block_hash)
    return data["size"]
  end

  def get_json_data(block_hash)
    uri = "https://blockchain.info/block-index/#{block_hash}?format=json"
    resp = Net::HTTP.get_response(URI.parse(uri))
    JSON.parse(resp.body)
  end
end
