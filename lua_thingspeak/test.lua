
--sendData ( 3,879)
-- delay must be present  between two functions
--ReadData (3)
--composeQury (1,500)
--composeQury( 2,6000)
--composeQury (3, 7000)
--send_multiple()

a= 1
mytimer = tmr.create()
mytimer:register(5000, tmr.ALARM_AUTO, function (t) 
print("expired", a);
a= a+1
end)
mytimer:start()





b=20000000 



--node.dsleep(b, 0)


--a= node.dsleepMax()
--print (35791/1000)