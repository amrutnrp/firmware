

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

Ask_now = function(inp_text)
    if wifi.sta.status()~=5 then
		print ('No Wifi !')
		return nil
    end
	conn=net.createConnection(net.TCP, 0)
	conn:on("receive", function(conn, payload) 
	print(payload) 
	
	end)
    
	conn:connect(80,root_server_ip )
	

	
	local msg = inp_text

	
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
