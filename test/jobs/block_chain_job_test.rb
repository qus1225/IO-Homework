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

    # 트랜잭션(tx)수가 맞는지 확인
    correct_tx_count = 1376
    result_tx_count = block.total_tx_count(block_hash)
    puts "트랜잭션(tx)수: #{result_tx_count}"
    assert_equal correct_tx_count, result_tx_count

    # 평균 트랜잭션의 값(value)이 맞는지 확인
    ## 블록구조 정보에 나온 총 트랜잭션값과, json으로 받은 트랜잭션값의 단위가 달라 100,000,000을 곱해줍니다.
    correct_avg_value = ((3746.58530944 * 100000000) / block.total_tx_count(block_hash).to_f).round(5)
    result_avg_value = block.avg_tx_value(block_hash).round(5)
    puts "평균 트랜잭션의 값: #{result_avg_value}"
    assert_equal correct_avg_value, result_avg_value
  end
end
