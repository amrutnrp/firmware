WP_pin = 8 ----------------------------------------------------------------------------------------------------------------------------------
					
	

stream_ = function (varName, addr_str)
    if  string.len(addr_str) ~= 2 then
        return 10
    end
    local target_address, c, addr_str2
    if addr_str == '00' then
         target_address = end_address [ varName ]  
    else
         local adrL_str = (string.sub(addr_str,2,2))
         local adrH_str = (string.sub(addr_str,1,1))       
         target_address = bit.lshift(string.byte( adrH_str ),8) + string.byte( adrL_str )
    end
    --print (target_address)
    local base_address  =  origin_address [ varName ]
    local delta = target_address- base_address
    --print (delta)
	if delta == 0 then
		return 12
    elseif  delta <= 64 then
        c= read_reg (eeprom_addr, base_address+8, delta )
        end_address [ varName ] = base_address 
        local addrL= bit.band(base_address, 0x0FF)
        local addrH= bit.rshift(base_address, 8)
        --print (addrH , addrL)
        write_reg (eeprom_addr, addr_loc[varName],  addrH )    
        tmr.delay(100000)
        write_reg (eeprom_addr, addr_loc[varName]+1,  addrL )    
        tmr.delay(100000)

        addr_str2 = '00'          
	else
        target_address = target_address -64
        c= read_reg (eeprom_addr, target_address, 64)
        local addrL= bit.band(target_address, 0x0FF)
        local addrH= bit.rshift(target_address, 8)
        addr_str2 = string.char(addrH) .. string.char(addrL)           
    end
    return tostring(c).. ' ' .. tostring(addr_str2 )
end 


pop_read = function (varName)
    --base_address  =  origin_address [ varName ]
    local target_address = end_address [ varName ]    
    local c= read_reg (eeprom_addr, target_address, 8)
    return c
end 


push_data = function (varName, value)
    print ('pushing data')
    local flag = 0
    local v2 = string.sub(value .. '   ', 1,4)
    local target_address = end_address [ varName ] 
    target_address = target_address + 8 
    if (target_address - origin_address [ varName ] ) >= 0x7FF then -- check_range for overflow
        flag = 5
    else
        end_address [ varName ] = target_address 
        write_reg (eeprom_addr, target_address, v2 )
        local addrL= bit.band(target_address, 0x0FF)
        local addrH= bit.rshift(target_address, 8)
        --print (addrH , addrL)
        write_reg (eeprom_addr, addr_loc[varName],  addrH )    
        tmr.delay(100000)
        write_reg (eeprom_addr, addr_loc[varName]+1,  addrL )    
        tmr.delay(100000)
    end
    return flag
end 

handle_client = function (text_inp)
    local  got_table= {}
    local  query= ''
    local flag= 0
	if string.sub (text_inp,1,3) == 'GET' 
	then
        flag= 11
        print ('coming from Browser!! ')
	-- browser
	else 
	-- other ESP
	-- ask for password
		local token
        
        local order = 1
		for token in string.gmatch( text_inp, "[^%s]+") do
			--print(token)
			got_table[order] = token
			order= order+1
		end
		token =nil

		see (got_table)
		if (order < 7 ) then
			return '0 13'
		end
		order =nil		
        local id_formatted= string.sub(got_table[1] .. '.......',1,7)
		local var_formatted= string.sub(got_table[5],1,1)
		
		local deviceOK=  		(device_ids [id_formatted ] ~= nil )				-- device id exists 
		local dereg= 			(got_table[ 4] ==  '5' )								 
		local reg= 				(got_table[ 4] ==  '2')	
		local readone = 		(got_table[ 4] ==  '0')
		local readmany = 		(got_table[ 4] ==  '1')
		local isPush = 			(got_table[ 4] ==  '4')
		local var_ok = 			(end_address [ var_formatted ] ~= nil)  			-- var exists
		local isRD = 			(got_table[ 2] ==  '1' )   							-- for read 
		local isWR =  			(got_table[ 2] ==  '0' )   							-- for read 
		local rd_pw_ok = 		(got_table[ 3] ==  RD_key )
		local wr_pw_ok = 		(got_table[ 3] ==  WR_key )
		local blank_variable =  (got_table[ 5] ==  "-" )	
		
		print (id_formatted, var_formatted)
		--if (isWR and wr_pw_ok ) then  
		--gpio.write (WP_pin, gpio.LOW)
		--end
		
		print ( deviceOK,  dereg , reg, readone, readmany, var_ok, isRD, isWR , rd_pw_ok  , wr_pw_ok , blank_variable  )
		
		
		
		
		if (deviceOK and var_ok and isRD and rd_pw_ok ) then
			if readmany then
				print ('read single')
				local ret = stream_ (var_formatted,  got_table[ 6] )
				if ret ==10 then
					flag = 10
				elseif ret == 12 then
					flag = 12
				else
					query = ret
				end
			elseif  readone then 
				print ('read many')
				if ( end_address [ var_formatted ] == origin_address [ var_formatted ]    ) then
					flag = 12
				else 
					local ret = pop_read ( var_formatted )
					query =  var_formatted .. ' ' .. ret
				end
			end
		elseif (deviceOK and var_ok and isWR and wr_pw_ok and isPush ) then
			print ('pushing data')
			flag = push_data (var_formatted ,    got_table[ 6])
		elseif ( isWR and wr_pw_ok  and reg ) then
			if ( blank_variable and deviceOK )then
				flag = 7
			elseif ( blank_variable and not deviceOK ) then
				print ('registering device ')
				flag = add_device (id_formatted ,  got_table[5] )
			elseif ( var_ok and deviceOK )then
				flag = 7
			elseif ( not var_ok and deviceOK )then
				print ('registering VARIABLE ')
				flag = register_var (var_formatted)
			elseif ( not deviceOK )then
				flag = 2
			end
		elseif ( deviceOK and isWR and wr_pw_ok  and dereg ) then 
			if blank_variable then
				print ('DEregistering device ')
				deregister_device(id_formatted)
			else
				if var_ok then
					print ('DEregistering VARIABLE ')
					deregister_var (var_formatted)
				else
					flag = 4
				end
			end
		elseif ( not deviceOK)  then
			flag = 2
		elseif (not ( isRD or isWR )) then
			flag = 1
		elseif ( not var_ok ) then
			flag = 4
		elseif  ( not (isRD or isWR)) then
			flag = 1
		elseif ( not (rd_pw_ok or wr_pw_ok )) then
			flag = 3
		else 
			flag = 1
		--gpio.write (WP_pin, gpio.HIGH)
		end

	end
	local ack 
	if flag== 0 then
		ack = 0
	else
		ack =1
	end
    return tostring(ack) .. ' ' ..  tostring(flag)..' '.. query
end

print ('Handler declared')
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
[12]= 'underflow- nothing left to read	',
[13]= 'INsufficinent query length'
}
