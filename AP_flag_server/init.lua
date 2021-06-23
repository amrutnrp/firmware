-- load credentials, 'SSID' and 'PASSWORD' declared and initialize in there

print ('Creating wifi...')
--collectgarbage()
disconnect_ct =nil
dofile("credentials.lua")

dofile("EEPROM_rd_wr.lua")
dofile("file_keeping.lua")

parse_ids()
parse_vars()

dofile("wconnect.lua")

print ('creating server now')

print (wifi.sta.status() )

mytimer = tmr.create()

mytimer:alarm (5000, tmr.ALARM_SINGLE, function(t)

dofile("Actual_handler.lua") 
srv_con =  net.createServer(net.TCP, 80)
dofile("RequestHandler.lua") 

t:unregister()
end)



