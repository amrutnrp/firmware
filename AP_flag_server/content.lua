scan_i2c()
eeprom_addr = 0x50




read_ids = function ()
    reg_addr= 0x0000
    for i=0,7 do
        c= read_reg(eeprom_addr, reg_addr, 16)
        print(c,reg_addr )
        reg_addr= reg_addr +16
     end
end

read_vars = function ()
    reg_addr= 0x0080
    for i=0,14 do
        c= read_reg(eeprom_addr, reg_addr, 8)
        print(c,reg_addr  )
        reg_addr= reg_addr +8
     end
end
--print (string.byte())
--print (string.char(98))
read_base_addr_only = function ()
    reg_addr= 0x0080
    for i=0,14 do
        c= read_reg(eeprom_addr, reg_addr+3, 8)
        print(c,reg_addr  )
        reg_addr= reg_addr +8
     end
end
--formatting device id space
insert_id_formatting = function()
    reg_addr= 0x0000
    for i=0,7 do
    c= write_reg (eeprom_addr,reg_addr, "N<Name-><Purpos>")
        print (c, reg_addr)
        reg_addr= reg_addr +16
     end
end
-- formatting variable space
insert_var_formatting  = function()
    reg_addr= 0x0080
    for i=1,15 do
        isodd = math.floor(i/ 2)
        isodd2 = (i - 2 * isodd ) * 0x8
        adr= isodd* 16 + isodd2
        print (reg_addr , adr)
        c= write_reg(eeprom_addr, reg_addr, "N--")
        tmr.delay(10000)
        reg_addr=reg_addr+3    
        c= write_reg(eeprom_addr, reg_addr, adr)
        tmr.delay(10000)
        reg_addr=reg_addr+1
        c= write_reg(eeprom_addr, reg_addr, 0x00)
        tmr.delay(10000)
        reg_addr=reg_addr+1
        c= write_reg(eeprom_addr, reg_addr, adr)
        tmr.delay(10000)
        reg_addr=reg_addr+1
        c= write_reg(eeprom_addr, reg_addr, 0x00)
        reg_addr=reg_addr+2
     end
end

reset_content = function()
    reg_addr= 0x0000
    for i=1,64 do
        c= write_reg(eeprom_addr, reg_addr, '----------------')
        tmr.delay(10000)
        reg_addr= reg_addr +16
    end
end



--read_ids()
--read_vars()
--read_base_addr_only()
--insert_id_formatting()
--insert_var_formatting()
 --print (read_reg(eeprom_addr, 128, 64))
--reset_content()