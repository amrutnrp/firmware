
got_WLANip_event = function(T)
  -- Note: Having an IP address does not mean there is internet access!
  -- Internet connectivity can be determined with net.dns.resolve().
  print("Wifi connection is ready! IP address is: "..T.IP)											-- T.IP ?
end

connected_WLAN_event = function(T)
  print("Connection to AP("..T.SSID..") established!")												-- T.SSID
  print("Waiting for IP address...")
  if disconnect_ct ~= nil then disconnect_ct = nil end												-- disconnect_ct
end

disconnected_WLAN_event = function(T)
  if T.reason == wifi.eventmon.reason.ASSOC_LEAVE then
    --the station has disassociated from a previously connected AP
    return
  end
  -- total_tries: how many times the station will attempt to connect to the AP. Should consider AP reboot duration.
  local total_tries = 15
  print("\nWiFi connection to AP("..T.SSID..") has failed!")
  --There are many possible disconnect reasons, the following iterates through
  --the list and returns the string corresponding to the disconnect reason.
  for key,val in pairs(wifi.eventmon.reason) do
    if val == T.reason then
      print("Disconnect reason: "..val.."("..key..")")
      break
    end
  end

  if disconnect_ct == nil then
    disconnect_ct = 1
  else
    disconnect_ct = disconnect_ct + 1
  end
  if disconnect_ct < total_tries then
    print("Retrying connection...(attempt "..(disconnect_ct+1).." of "..total_tries..")")
  else
    wifi.sta.disconnect()
    print("Aborting connection to AP!")
    disconnect_ct = nil
  end
end


-- what is disconnect_ct, wifi.eventmon, "..T.SSID.."

wifi.eventmon.register(wifi.eventmon.STA_CONNECTED, connected_WLAN_event)
wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, got_WLANip_event)
wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, disconnected_WLAN_event)
wifi.setmode(wifi.STATION)
wifi.sta.config({ssid=SSID, pwd=PASSWORD})
