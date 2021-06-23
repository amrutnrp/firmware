
eeprom_addr = 0x50
device_ids ={}   -- registered devices
end_address = {}  -- latest stack address of variables
origin_address  = {}  -- original address base
addr_loc = {}    -- where the """latest"""   address is stored ?

parse_ids = function ()
    local reg_addr_loc3= 0x0000
    --local device_count= 1
    local c
    for i=0,7 do
        c= read_reg(eeprom_addr, reg_addr_loc3, 16)
        if string.sub (c,1,1)~='N' then
            device_ids[string.sub (c,2,8) ] = true --device_count
            --device_count = device_count+1 
        end
        reg_addr_loc3= reg_addr_loc3 +16
     end
end
see = function(table_) 
    for i,line in pairs(table_) do
        print (i, line)
    end
end
parse_vars = function ()
    local reg_addr_loc3= 0x0080
    --local var_count= 1
    local c, adrH, adrL
    for i=0,14 do
        c= read_reg(eeprom_addr, reg_addr_loc3, 8)
        if string.sub (c,1,1)~='N' then
			var_name = string.sub (c,2,2)
			adrH= (string.byte(string.sub(c,6,6)))
			adrL= (string.byte(string.sub(c,7,7)))
			end_address[ var_name ] = bit.lshift(adrH, 8) + adrL 
			
			adrH= (string.byte(string.sub(c,4,4)))
			adrL= (string.byte(string.sub(c,5,5)))
            origin_address[ var_name ] =  bit.lshift(adrH, 8) + adrL 
            addr_loc[ var_name ] = reg_addr_loc3 + 5
        end
        reg_addr_loc3= reg_addr_loc3 +8
        --var_count = var_count +1
     end
end
add_device = function(id, purpose)
    local reg_addr_loc3= 0x0000
    local done_flag = false
    local c, s
    for i=0,7 do 
        c= read_reg(eeprom_addr, reg_addr_loc3, 1)
        if c=='N' then
            s= 'Y'.. id  .. string.sub (purpose .. '........',1,8) 
            write_reg(eeprom_addr, reg_addr_loc3, s )
            done_flag = true
			device_ids[ id  ] = true 
            break
        end           
        reg_addr_loc3= reg_addr_loc3 +16
    end
    if done_flag == false then
        -- overflow of ids
        return 6
    end
    return 0
end
deregister_device = function(id)
    local reg_addr_loc3= 0x0000
    local c
    for i=0,7 do 
        c= read_reg(eeprom_addr, reg_addr_loc3,16)
        if string.match (c, id) ~= nil then
            write_reg(eeprom_addr, reg_addr_loc3, 'N' )
            device_ids [id] = nil
            break
        end           
        reg_addr_loc3= reg_addr_loc3 +16
    end
    return 0
end

register_var = function (var_name)
    local reg_addr_loc3= 0x0080
    local done_flag = false   
    local c, s2, s, adrH, adrL
    for i=0,14 do
        c= read_reg(eeprom_addr, reg_addr_loc3, 8)
        if string.sub (c,1,1)  =='N' then
            s2= string.sub (c,4,5)
            s= 'Y'.. var_name 
            write_reg(eeprom_addr, reg_addr_loc3, s)
            write_reg(eeprom_addr, reg_addr_loc3+6, s2)
            done_flag = true
			adrH= (string.byte(string.sub(s2,1,1)))
			adrL= (string.byte(string.sub(s2,2,2)))	
			
            end_address [var_name ] =  bit.lshift(adrH, 8) + adrL 
			addr_loc [var_name ] = reg_addr_loc3 + 5
			origin_address [var_name  ] = bit.lshift(adrH, 8) + adrL 
            break
        end
        reg_addr_loc3= reg_addr_loc3 +8
     end
    if done_flag == false then
        -- overflow of ids
        return 6
    end
    return 0
    
end

deregister_var = function (var_name)
    local reg_addr_loc3= 0x0080
    local c,s
    for i=0,14 do
        c= read_reg(eeprom_addr, reg_addr_loc3, 1)
        s= read_reg(eeprom_addr, reg_addr_loc3+1, 1)
        if s== var_name and c ~= 'N' then
            write_reg(eeprom_addr, reg_addr_loc3, 'N')
            break
        end
        reg_addr_loc3= reg_addr_loc3 +8
     end
    end_address [var_name ] = nil
    addr_loc [var_name ] = nil
    origin_address [var_name  ] = nil     
    return 0
end



--parse_ids()
--parse_vars()

--see

--add_device()
--deregister_device()
--register_var()
--deregister_var()

--eeprom_addr 
--device_ids ={}  
--end_address = {}  
--origin_address  = {} 
--addr_loc = {}    -- where the """latest"""   address is stored ?