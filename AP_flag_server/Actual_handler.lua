WP_pin = 8 ----------------------------------------------------------------------------------------------------------------------------------

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
		print(token)
        got_table[order] = token
        order= order+1
		end
        id_formatted= string.sub(got_table[1] .. '.......',1,7)
		var_formatted= string.sub(got_table[5],1,1)
        if ( got_table[ 2] ==  1 ) then  -- for read 
			if ( got_table[ 3] ==  RD_key ) then  -- READ PASSSWORD
				if (  device_ids [id_formatted ] ~= nil )  -- device id exists 
					if (  end_address [ var_formatted ] ~= nil) then -- var exists
						base_address  =  origin_address [ var_formatted ]-- get the address
						target_address = end_address [ var_formatted ] 
						if ( got_table[ 4] ==  0 ) then -- read 1
							ret_data = read_reg (eeprom_addr, target_address)
						elseif ( got_table[ 4] ==  1 ) then -- read all
						
						
						
							local address = ''  -- get the address
							read_reg (device, address)
						elseif ( got_table[ 4] ==  3 ) then -- last operation
						
						
						
						
							base_address= 
							target_address = base_address + got_table[ 6] 
						
						
						else
							flag =9
						end
					else
						flag = 4
					end
				else
					flag = 2
				end	
			else
				flag =3
			end
		elseif ( got_table[ 2] ==  0 ) then  -- for write
			if ( got_table[ 3] ==  WR_key ) then  -- write PASSSWORD
				gpio.write (WP_pin, gpio.LOW)
				local deviceOK=  device_ids [id_formatted ] ~= nil -- device id exists 
				local dereg= got_table[ 4] ==  5 
				local reg= got_table[ 4] ==  2
				if ( dereg ) then -- deregister 
					if (deviceOK )then
						if ( got_table[ 5] ==  '0' ) then -- it's self deregister
							deregister_device(id_formatted )
						else --it's a variable
							if (end_address [ var_formatted ] ~= nil  )--make sure variable already exoists
								deregister_var ( var_formatted )
							else
								flag = 4
							end
						end
					else
						flag = 2
					end
				elseif reg then -- register 
					if ( got_table[ 5] ==  '0' ) then -- register  self
						if ( deviceOK ) then ------- device id exists
								flag = 7     -- already registered
						else
							local r = add_device (id_formatted , got_table[ 6])
							if (r == 6 ) then
								flag =6
							end
						end
					else -- it's a variable
						if ( deviceOK ) then------- device id exists
							local r = register_var(var_formatted )
							if (r== 6  ) then
								flag = 6
							end
						else
							flag = 2
						end		
				elseif ( got_table[ 4] ==  4 ) then -- push 1
				
				
				
				
				
				
				
				
				only 1 byte
				
				
				
					if ( deviceOK )  then-- device id exists 
						if ( end_address [ var_formatted ] ~= nil) then -- var exists
							target_address = end_address [ var_formatted ] 
							target_address = target_address + 8 
							if (target_address - origin_address [ var_formatted ] )< 0x7FF then -- check_range for overflow
								end_address [ var_formatted ] = target_address 
								write_reg (eeprom_addr, target_address, got_table[ 6])
								write_reg (eeprom_addr, addr_loc[var_formatted], target_address )
								
							else
								flag = 5
							end
						else
							flag = 4
						end
					else
						flag = 2
					end
				else
					flag = 9
				end
				gpio.write (WP_pin, gpio.HIGH)
			else	
				flag =3
			end
		else
			flag =1
		end



	end
    return tostring(flag)..' '.. query
end

print ('Handler declared')

