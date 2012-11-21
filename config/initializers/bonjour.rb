require 'dnssd'

# http = TCPServer.new nil, 80 
# DNSSD.announce http, 'my awesome HTTP server'

service = DNSSD.register "StageCom", "_stage_com._tcp", nil, 3000 do
  puts "Block Called"
end