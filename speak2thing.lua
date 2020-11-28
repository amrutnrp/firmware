thing_speak_ip = '184.106.153.149'
host= "api.thingspeak.com"
read_thsp_val = ''

function sendData(field_num, data_to_send)
    if wifi.sta.status()~=5 then
        --wifi.sta.connect()
		print ('No Wifi !')
		return nil
    end
	--local data_len= string.len(tostring(data_to_send))
	print("Sending data to thingspeak.com")
	conn=net.createConnection(net.TCP, 0)
	conn:on("receive", function(conn, payload) 
	print(payload) 
	
	end)
    
	conn:connect(80,thing_speak_ip )
	
    --local msg = "GET /update?api_key=4X1L42JDBX4SKRZH&field1=" .. data_to_send .. " HTTP/1.1\r\nHost: api.thingspeak.com\r\nConnection: close\r\nAccept: */*\r\nUser-Agent: Mozilla/4.0 (compatible; esp8266 Lua; Windows NT 5.1)\r\n\r\n"	
	
	
	local msg = "GET /update?api_key=".. WR_key .. "&field"..field_num  .. "=" .. data_to_send
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
	conn:on("disconnection", function(conn)
		print("Got disconnection...")
	end)
    collectgarbage()
end


function ReadData(field_num)
    if wifi.sta.status()~=5 then
        --wifi.sta.connect()
        print ('No Wifi !')
        return nil
    end
    local path2 = "/channels/688655/fields/" .. field_num .. "/last?key=" .. RD_key
    local msg = "GET " .. path2 .. " HTTP/1.1\r\nHost: " .. host .. "\r\nConnection: keep-alive\r\nAccept: */*\r\n\r\n"  
    print("Reading from thingspeak.com")
    local conn=net.createConnection(net.TCP, 0)
    conn:on("receive", function(sck, payload) 
    --print(payload) 
    for match in payload:gmatch("[^\r\n]+") do 
        read_thsp_val= match    
    end    
    print (read_thsp_val)
    
    conn:close()
    end)
    conn:on("connection", function(sck, c)
    sck:send(msg)
    end)  
    conn:connect(80,thing_speak_ip )  
    conn:on("disconnection", function(conn)
        print("Got disconnection...")
        collectgarbage()
    end)
end


















