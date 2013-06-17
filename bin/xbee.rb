#!/usr/bin/ruby

require 'rubygems'
require 'optparse'
require 'serialport'

@config = Hash.new()

# set some default values`
@config[:device] = '/dev/tty.usbserial-A901LJ1Q'
@config[:baud] = 9600
@config[:read_timeout] = 5000
@config[:write_timeout] = 5000
@config[:verbose] = false

#
# xbee_cmds - hash lookup table of all commands
# keys are all symbols, values are the at command syntax
#
@xbee_cmds = Hash.new()
@xbee_cmds[:firmware_version] = 'ATVR'
@xbee_cmds[:hardware_version] = 'ATHV'
@xbee_cmds[:my_hw_address] = 'ATMY'
@xbee_cmds[:destination_low] = 'ATDL'
@xbee_cmds[:destination_high] = 'ATDH'
@xbee_cmds[:serial_low] = 'ATSL'
@xbee_cmds[:serial_high] = 'ATSH'
@xbee_cmds[:nodeid] = 'ATNI'
@xbee_cmds[:panid] = 'ATID'
@xbee_cmds[:last_rx_signal_dbm] = 'ATDB'
@xbee_cmds[:baud] = 'ATBD'
@xbee_cmds[:parity] = 'ATNB'
#@xbee_cmds[:write] = 'ATWR'
#@xbee_cmds[:restore] = 'ATRE'

OptionParser.new do |opts|
  opts.banner = "Usage: example.rb [options]"
  opts.on("-b", "--baud", "baud rate") do |v|
    options[:baud] = v
  end
  opts.on("-d", "--device", "Serial port") do |v|
    options[:device] = v
  end
  opts.on("-r", "--read_timeout", "Read timeout") do |v|
    options[:read_timeout] = v
  end
  opts.on("-v", "--verbose", "Verbosity toggle") do |v|
    options[:verbose] = true
  end
  opts.on("-w", "--write_timeout", "Write timeout") do |v|
    options[:write_timeout] = v
  end
end.parse!

#
# pass in the command without any \r crap
# Returns the raw response
#
def xbee_cmd(cmd)
  write_response = @serial.write("+++")
  if @serial.read(write_response) == ("OK\r")
    cmd_response = @serial.write("#{cmd}\r")
    resp = @serial.read(cmd_response)
    @serial.write('ATCN\r')
    return resp
  end
end

def xbee_info
  puts "Dumping information on #{@config[:device]}..."
  @xbee_cmds.keys.each do |key|
    puts "#{key} #{xbee_cmd(@xbee_cmds[key])}"
  end
end

@serial = SerialPort.new(@config[:device])
@serial.speed=@config[:speed]
@serial.baud=@config[:baud]
@serial.read_timeout=@config[:read_timeout]
# @serial.write_timeout=@config[:write_timeout] todo, not implemented on mac


