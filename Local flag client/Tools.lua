

GET_root_ip = function ()
    a= wifi.sta.getip()  --'192.168.4.1'  --ip
    root_server_ip= ''
    token1= ''
    for token in string.gmatch( a, "[^%.]+") do
        root_server_ip = root_server_ip .. token1    
        token1 = token ..'.'
    end
    root_server_ip = root_server_ip .. '1' 
end 

Ask_now = function()
    if wifi.sta.status()~=5 then
		print ('No Wifi !')
		return nil
    end
	print("Sending data to thingspeak.com")
	conn=net.createConnection(net.TCP, 0)
	conn:on("receive", function(conn, payload) 
	print(payload) 
	
	end)
    
	conn:connect(80,root_server_ip )
	

	
	local msg = "GET /update?api_key=".. WR_key 
        .. " HTTP/1.1\r\n"
        .. "Host: api.thingspeak.com\r\n"
        .. "Connection: close\r\n"
        .. "Accept: */*\r\n"
        .. "User-Agent: Mozilla/4.0 (compatible; esp8266 Lua; Windows NT 5.1)\r\n"
        .. "\r\n"

	
	conn:send(msg )
	
	
	conn:on("sent",function(conn)
		print("Closing connection")
		conn:close()
	end)
	-- conn:on("disconnection", function(conn)
		-- print("Got disconnection...")
	-- end)
    collectgarbage()
end
