require 'socket'

network = "irc.foonetic.net"
port = "6667"
channel = "#rubytesting"
nick = "rubybot_69"

irc = TCPSocket.new(network, port)
puts irc.recv(4096)
irc.send("NICK #{nick}\n", 0)
puts irc.recv(4096)
irc.send("USER cool_dude * 0 :stranger danger\n", 0)

connection = Thread.new {
  while true
    buffer = irc.recv(4096)
    lines = buffer.split("\n")

    lines.each do |line|
      puts line
      if line.include?("PING")
        pong_out = line.split(":")[1]
        irc.send("PONG :#{pong_out}",0)
      end
    end
  end
}

input = Thread.new {
  while true
    user_input = gets

    irc.send(user_input, 0)
  end
}

connection.join
input.join

irc.close