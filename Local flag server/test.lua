--srv_con:close()
a=0;
while( wifi.sta.status()~=5 ) 
do
    a= 1 +1 
    print ('not connected yet!')
end


dofile("Actual_handler.lua") 
srv_con =  net.createServer(net.TCP, 80)
dofile("RequestHandler.lua") 

