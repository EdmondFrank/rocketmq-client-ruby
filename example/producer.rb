# frozen_string_literal: true
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

require 'rocketmq-client-ruby'
require 'thread'

$gid = 'PID-XXX'
$topic = 'YOUR-TOPIC'
$name_srv = '0.0.0.0:9876'
$queue = Queue.new

def create_message(body)
  msg = Client::Message.new($topic)
  msg.set_keys('key')
  msg.set_tags('tag')
  msg.set_body(body)
  msg['client'] = 'ruby'
  msg
end

def send_sync_message(count)
  puts('begin to send_sync_message')
  producer = Client::Producer.new($gid)
  producer.set_name_server_address($name_srv)
  producer.start
  count.times do
    msg = create_message('sync_message')
    ret = producer.send_sync(msg)
    puts("send message status: #{ret[:send_status]}  msgId: #{ret[:msg_id]}")
  end
  puts('send sync message done')
  producer.shutdown
end

def send_orderly_with_sharding_key(count)
  puts('begin to send_orderly_with_sharding_key')
  producer = Client::Producer.new($gid, orderly: true)
  producer.set_name_server_address($name_srv)
  producer.start
  count.times do
    msg = create_message('orderly message')
    ret = producer.send_orderly_with_sharding_key(msg, 'orderId')
    puts("send message status: #{ret[:send_status]} msgId: #{ret[:msg_id]}")
  end
  puts('send orderly message done')
  producer.shutdown
end

def send_message_multi_thread(retry_time)
  puts('begin to send_message_multi_thread')
  producer = Client::Producer.new($gid)
  producer.set_name_server_address($name_srv)
  msg = create_message('muti thread message')
  producer.start
  retry_time.times do
    Thread.new do
      ret = producer.send_sync(msg)
      $queue.push(ret)
    end
  end
  retry_time.times do
    ret = $queue.pop() # Blocks until thread 't' pushes onto the queue
    if ret[:send_status]
      puts("send message status: #{ret[:send_status]} msgId: #{ret[:msg_id]}")
    else
      puts('send message to MQ failed.')
    end
  end
  puts('send multi_thread message done')
  producer.shutdown
end

def send_transaction_message(count)
  puts('begin to send_transaction_message')
  check_callback = ->(msg) {
    puts('check: ' + msg.body)
    return Rocketmq::C::TransactionStatus[:commit]
  }
  local_callback = ->(msg) {
    puts('local: ' + msg.body)
    return Rocketmq::C::TransactionStatus[:unknown]
  }
  producer = Client::TransactionMQProducer.new($gid, check_callback)
  producer.set_name_server_address($name_srv)
  producer.start()
  count.times do
    msg = create_message('transaction message')
    ret = producer.send_message_in_transaction(msg, local_callback)
    puts("send message status: #{ret}")
  end
  puts('send transaction message done')
  producer.shutdown
end


send_sync_message(3)
send_message_multi_thread(3)
send_orderly_with_sharding_key(3)
send_transaction_message(3)
