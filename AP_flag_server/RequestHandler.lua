


srv_con:listen (80,  function (conn)

conn:on("receive",function(conn,payload)
    print(payload)
    local ret = handle_client(payload)
	print ('here is return')
    local ret2= "<h1> " .. ret ..  "  </h1>"
    print (ret2)
    conn:send(ret2)
end)

conn:on("sent",function(conn) 
conn:close() 
end)

--collectgarbage()
end)


print ('Now listening ...')





