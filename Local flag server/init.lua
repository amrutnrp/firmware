-- load credentials, 'SSID' and 'PASSWORD' declared and initialize in there

print ('woke up.. connecting to wifi ')
--collectgarbage()
disconnect_ct =nil
dofile("credentials.lua")
dofile("wconnect.lua")

print ('manifesting the server now')

print (wifi.sta.status() )





