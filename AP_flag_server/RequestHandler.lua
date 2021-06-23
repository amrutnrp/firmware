


srv_con:listen (80,  function (conn)

conn:on("receive",function(conn,payload)
    --print(payload)
    local ret = handle_client(payload)
    conn:send("<h1> " .. ret ..  "  </h1>")
end)

conn:on("sent",function(conn) 
conn:close() 
end)

--collectgarbage()
end)


print ('Now listening ...')





