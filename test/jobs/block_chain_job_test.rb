require 'test_helper'

class BlockChainJobTest < ActiveJob::TestCase
  # 과제1 "블록 해쉬 값"을 Argument로 전달 받아서 아래의 정보를 출력
  # 트랜잭션(tx)의 수
  # 평균 트랜잭션의 값(value)
  # 평균 트랜잭션의 수수료(fee)
  # 평균 트랜잭션의 크기(size)
  test "'블록 해쉬 값'을 Argument로 전달 받아서 필요한 정보를 출력합니다" do
    block_hash = '0000000000000000010d1fecd817e30ac44c3e82453a84b54b31674e8192a4f8'
    block = BlockChainJob.new

    # 트랜잭션(tx)의 수가 맞는지 확인
    correct_tx_count = 1376
    result_tx_count = block.total_tx_count(block_hash)
    puts "트랜잭션(tx)의 수: #{result_tx_count}"
    assert_equal correct_tx_count, result_tx_count

    # 평균 트랜잭션의 값(value)이 맞는지 확인
    ## 블록구조 정보에 나온 총 트랜잭션값과, json으로 받은 트랜잭션값의 단위가 달라 100,000,000을 곱해줍니다.
    conditioning_value_for_value = 100000000
    origin_total_value = 3746.58530944
    correct_avg_value = ((origin_total_value * conditioning_value_for_value) / block.total_tx_count(block_hash).to_f).round(5)
    result_avg_value = block.avg_tx_value(block_hash).round(5)
    puts "평균 트랜잭션의 값: #{result_avg_value}"
    assert_equal correct_avg_value, result_avg_value

    # 평균 트랜잭션의 수수료(fee)가 맞는지 확인
    ## 블록구조 정보에 나온 총 수수료값과, json으로 받은 트랜잭션값의 단위가 달라 100,000,000을 곱해줍니다.
    conditioning_value_for_fee = 100000000
    origin_total_fee = 1.51631181
    correct_avg_fee = ((origin_total_fee * conditioning_value_for_fee) / block.total_tx_count(block_hash).to_f).round(5)
    result_avg_fee = block.avg_tx_fee(block_hash).round(5)
    puts "평균 트랜잭션의 수수료: #{result_avg_fee}"
    assert_equal correct_avg_fee, result_avg_fee

    # 평균 트랜잭션의 크기(size)가 맞는지 확인
    ## 블록구조 정보에 나온 총 트랜잭션 크기와, json으로 받은 트랜잭션 크기의 단위가 달라 1,000을 곱해줍니다.
    conditioning_value_for_size = 1000
    origin_total_size = 998.222
    correct_avg_size = ((origin_total_size * conditioning_value_for_size) / block.total_tx_count(block_hash).to_f).round(5)
    result_avg_size = block.avg_tx_size(block_hash).round(5)
    ## 블록구조 정보에 나온 총 트랜잭션 크기와 개별 트랜잭션 크기를 합산한 값 간에 약 1KB이내의 오차가 있습니다.
    ## 따라서 1KB 범위를 오차범위로 삼아 오차범위 내로 계산될 경우는 맞았다고 간주합니다.
    ## 평균값은 '1KB / 총 트랜잭션수' 만큼의 오차범위 내로는 맞았다고 간주합니다.
    error_range = 10000
    puts "평균 트랜잭션의 크기: #{result_avg_size}"
    result_is_within_rage = result_avg_size.between? correct_avg_size - (error_range / block.total_tx_count(block_hash)), correct_avg_size
    assert result_is_within_rage
  end
end
