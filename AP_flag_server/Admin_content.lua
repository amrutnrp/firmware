scan_i2c()
eeprom_addr = 0x50




read_ids = function ()
    local reg_addr_loc2= 0x0000
	local c
    for i=0,7 do
        c= read_reg(eeprom_addr, reg_addr_loc2, 16)
        print(c,reg_addr_loc2 )
        reg_addr_loc2= reg_addr_loc2 +16
     end
end

read_vars = function ()
    local reg_addr_loc2= 0x0080
	local c
    for i=0,14 do
        c= read_reg(eeprom_addr, reg_addr_loc2, 8)
        print(c,reg_addr_loc2  )
        reg_addr_loc2= reg_addr_loc2 +8
     end
end
--print (string.byte())
--print (string.char(98))
read_base_addr_only = function ()
    local reg_addr_loc2= 0x0080
	local c
    for i=0,14 do
        c= read_reg(eeprom_addr, reg_addr_loc2+3, 8)
        print(c,reg_addr_loc2  )
        reg_addr_loc2= reg_addr_loc2 +8
     end
end
--formatting device id space
insert_id_formatting = function()
    local reg_addr_loc2= 0x0000
	local c
    for i=0,7 do
		c= write_reg (eeprom_addr,reg_addr_loc2, "N<Name-><Purpos>")
        print (c, reg_addr_loc2)
        reg_addr_loc2= reg_addr_loc2 +16
     end
end
-- formatting variable space
insert_var_formatting  = function()
    local isodd, isodd2, adr, c
	local reg_addr_loc2= 0x0080
    for i=1,15 do
        isodd = math.floor(i/ 2)
        isodd2 = (i - 2 * isodd ) * 0x8
        adr= isodd* 16 + isodd2
        print (reg_addr_loc2 , adr)
        c= write_reg(eeprom_addr, reg_addr_loc2, "N--")
        tmr.delay(10000)
        reg_addr_loc2=reg_addr_loc2+3    
        c= write_reg(eeprom_addr, reg_addr_loc2, adr)
        tmr.delay(10000)
        reg_addr_loc2=reg_addr_loc2+1
        c= write_reg(eeprom_addr, reg_addr_loc2, 0)
        tmr.delay(10000)
        reg_addr_loc2=reg_addr_loc2+1
        c= write_reg(eeprom_addr, reg_addr_loc2, adr)
        tmr.delay(10000)
        reg_addr_loc2=reg_addr_loc2+1
        c= write_reg(eeprom_addr, reg_addr_loc2, 0)
        reg_addr_loc2=reg_addr_loc2+2
     end
end

reset_content = function()
    local reg_addr_loc2= 0x0000
	local c
    for i=1,64 do
        c= write_reg(eeprom_addr, reg_addr_loc2, '----------------')
        tmr.delay(10000)
        reg_addr_loc2= reg_addr_loc2 +16
    end
end



--read_ids()
--read_vars()
--read_base_addr_only()
--insert_id_formatting()
--insert_var_formatting()
 --print (read_reg(eeprom_addr, 128, 64))
--reset_content()
