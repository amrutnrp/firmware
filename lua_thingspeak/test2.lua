ws = websocket.createClient()



ws:on("connection", function(ws)
  ws:send ('hello!')
  print('got ws connection')
end)



ws:on("receive", function(_, msg, opcode)
   
  print('got message:', msg, opcode) -- opcode is 1 for text message, 2 for binary
end)



ws:on("close", function(_, status)
  print('connection closed', status)
  ws = nil -- required to Lua gc the websocket client
end)

ws:connect('ws://echo.websocket.org')