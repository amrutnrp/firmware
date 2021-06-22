WP_pin = 8 ----------------------------------------------------------------------------------------------------------------------------------
value = got_table[ 6]
push_data = function (varName, value)
	target_address = end_address [ varName ] 
	target_address = target_address + 8 
	if (target_address - origin_address [ varName ] )< 0x7FF then -- check_range for overflow
		flag = 5
	else
		end_address [ varName ] = target_address 
		write_reg (eeprom_addr, target_address, value )
		write_reg (eeprom_addr, addr_loc[varName], target_address )		
	end
end					
								
pop_read = function (varName)
	--base_address  =  origin_address [ varName ]
	target_address = end_address [ varName ] 	
	c= read_reg (eeprom_addr, target_address, 8)
	return c
end							


target_address = end_address [ varName ] 
print (   read_reg (eeprom_addr, target_address, 8) )




push_data = function (varName, value)
	print (varName ,  value , 'got the write ')
end					
								
pop_read = function (varName)
	print (varName , 'got changce to read ')
end		

stream_ = function (varName, number)
	print ('stream init', varName) 

end



handle_client = function (text_inp)
    local  got_table= {}
    local  query= ''
    local flag= 0
	if string.sub (text_inp,1,3) == 'GET' 
	then
        local flag= 0
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
		see (got_table)
		
        id_formatted= string.sub(got_table[1] .. '.......',1,7)
		var_formatted= string.sub(got_table[5],1,1)
		
		local deviceOK=  		(device_ids [id_formatted ] ~= nil )				-- device id exists 
		local dereg= 			(got_table[ 4] ==  '5' )								 
		local reg= 				(got_table[ 4] ==  '2')	
		local readone = 		(got_table[ 4] ==  '0')
		local readmany = 		(got_table[ 4] ==  '1')
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
				stream_ (var_formatted,  got_table[ 6] )
			elseif  readone then 
				pop_read ( var_formatted )
			end
		elseif (deviceOK and var_ok and isWR and wr_pw_ok and (not dereg )) then
			push_data (var_formatted ,    got_table[ 6])
		elseif ( isWR and wr_pw_ok  and reg ) then
			if blank_variable then
				if deviceOK then
					flag = 7
				else
					flag = add_device (id_formatted ,  got_table[5] )
				end
			else
				if var_ok then
					flag = 7
				else
					flag = register_var (var_formatted)
				end
			end
		elseif ( deviceOK and isWR and wr_pw_ok  and dereg ) then 
			if blank_variable then
				deregister_device(id_formatted)
			else
				if var_ok then
					deregister_var (var_formatted)
				else
					flag = 4
				end
			end
		elseif ( not deviceOK)  then
			flag = 2
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
    return tostring(flag)..' '.. query
end

print ('Handler declared')

