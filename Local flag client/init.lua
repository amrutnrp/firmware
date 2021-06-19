-- load credentials, 'SSID' and 'PASSWORD' declared and initialize in there

print ('woke up.. connecting to wifi ')
--collectgarbage()
disconnect_ct =nil
dofile("credentials.lua")
dofile("wconnect.lua")

print ('manifesting the server now')

print (wifi.sta.status() )

--mytimer = tmr.create()

--mytimer:alarm (5000, tmr.ALARM_SINGLE, function(t)

--dofile("Actual_handler.lua") 
--srv_con =  net.createServer(net.TCP, 80)
--dofile("RequestHandler.lua") 

--t:unregister()
--end)



