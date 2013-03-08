file = File.open("output.txt", "w")

at_exit do
	file.puts "Wobbles"
	file.fsync
	File.open("itworks.txt", "w").write "yes"
end

def shutdown
	file.puts "Shutting down..."
	exit
end

Signal.trap('TERM') do
	shutdown
end

while true
	sleep 1
	file.puts "Sleeping..."
	file.fsync
end
