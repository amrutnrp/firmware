


--ssid, password, bssid_set, bssid= wifi.sta.getconfig()

--print (ssid)

--dofile ("speak2thing.lua")
--sendData(0,250)

function Read()
	print("Reading data from thingspeak.com")
	conn=net.createConnection(net.TCP, 0)
	conn:on("receive", function(conn, payload) print(payload) end)
	conn:connect(80,'184.106.153.149')
	
	conn:send("GET /update?api_key=".. WR_key .."&field1=874"
	.. " HTTP/1.1\r\n"
	.. "Host: api.thingspeak.com\r\n"
	.. "Connection: close\r\n"
	.. "Accept: */*\r\n"
	.. "User-Agent: Mozilla/4.0 (compatible; esp8266 Lua; Windows NT 5.1)\r\n"
	.. "\r\n")	
	conn:send("Host: api.thingspeak.com\r\n")
	conn:send("Accept: */*\r\n")
	conn:send("User-Agent: Mozilla/4.0 (compatible; esp8266 Lua; Windows NT 5.1)\r\n")
	conn:send("\r\n")
	conn:on("sent",function(conn)
		print("Closing connection")
		conn:close()
	end)
	conn:on("disconnection", function(conn)
		print("Got disconnection...")
	end)
end