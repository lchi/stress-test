require 'socket'
require 'thread'

port = ARGV[0] || 8080

sock = TCPServer.new port
total_connections = 0

puts "Listening on #{port}"

trap("INT") do
  puts "Shutting down..."
  puts total_connections
  sock.close

  exit
end


loop do
  client = sock.accept
  Thread.new do
    total_connections += 1
    # force apachebench
    client.readchar
    client.write("HTTP/1.0 200 OK\r\nContent-Type: text/plain\r\nContent-Length: 5\r\n\r\nPong!")
    client.close
  end

end
