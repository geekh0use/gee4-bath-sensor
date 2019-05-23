require 'time'
require 'json'
require 'serialport'
require 'httpclient'
require 'daemon_spawn'

#Process.daemon

# ruby 2.6
module Kernel
  def then(&block)
    return to_enum :yield_self unless block
    block.call(self)
  end
end

class FuroDaemon < DaemonSpawn::Base

  def start(args)
client = HTTPClient.new
client.debug_dev = $stderr

SerialPort.open '/dev/serial0' do |furo|
  loop do
    furo.readline.chomp
      .then { |line| line =~ /^::rc=/ ? [line] : [] }
      .map { |it|
        values = it.split(/:/).map { |e| e.split(/=/) }
        hash = Hash[*values.flatten]
        hash[:ts] = Time.now.iso8601
        JSON.generate(hash)
      }
      .each { |json| client.post_content('https://gee4-bath01.herokuapp.com/sensor_output', 
                                         json, 'Content-Type' => 'application/json')
      }
  end
end
  end

  def stop
  end
end

FuroDaemon.spawn!({
  :working_dir => "./",
  :pid_file => "./pid.log",
  :log_file => "./furo.log"
})

