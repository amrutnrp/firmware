

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
	print(conn, payload) 
	conn:close()
    print("Closing connection")
	end)
    
	conn:connect(80,root_server_ip )
	

	
	local msg = inp_text

	
	conn:send(msg )
	conn:on("sent",function(conn)
		print("Sent ...")
	end)
	-- conn:on("disconnection", function(conn)
		-- print("Got disconnection...")
	-- end)
    collectgarbage()
end


Error_LUT = {
[0]= 'ack',
[1]= 'syntax/ order incorrect',
[2]= 'new_id / id     wasn\'t present',
[3]= 'incorrect password (wrt that mode)',
[4]= 'invalid variable name',
[5]= 'overflow_can\'t write',
[6]= 'can\'t register new, table is full',
[7]= 'already registered',
[8]= 'nothing more to read, (add a dummy)',
[9]= 'read/write access problem/ syntax incorrect',
[10]= 'incorrect address',
[11]= 'Browser',
[12]= 'underflow- nothing left to read  ',
[13]= 'INsufficinent query length'
}
