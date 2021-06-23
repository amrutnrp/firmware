
scan_i2c = function ()
    local id  = 0
    local sda = 2
    local scl = 1
    --dev_addr = 0x50
    --reg_addr = 77
    -- initialize i2c, set pin 1 as sda, set pin 2 as scl
    i2c.setup(id, sda, scl, i2c.SLOW)
    for i=0,127 do
        i2c.start(id)
        local resCode = i2c.address(id, i, i2c.TRANSMITTER)
        i2c.stop(id)
        --print (i, resCode)
        if resCode == true then print("We have a device on address 0x" .. string.format("%02x", i) .. " (" .. i ..")") end
    end
end


i2c_init= function()
    id  = 0
    sda = 2
    scl = 1
    -- initialize i2c, set pin 1 as sda, set pin 2 as scl
    i2c.setup(id, sda, scl, i2c.SLOW)
end

read_reg = function (dev_addr, reg_addr_loc, read_num)
    local addr_H = math.floor(reg_addr_loc/ 256)
    local addr_L = reg_addr_loc - 256 * addr_H
    
    i2c.start(id)
    i2c.address(id, dev_addr, i2c.TRANSMITTER)
    i2c.write(id, addr_H)
    i2c.write(id, addr_L)
    i2c.stop(id)
	
    i2c.start(id)
    i2c.address(id, dev_addr, i2c.RECEIVER)
    local c_local = i2c.read(id, read_num)
    i2c.stop(id)
    return c_local
end



function write_reg(dev_addr, reg_addr_loc, data )
    local addr_H = math.floor(reg_addr_loc/ 256)
    local addr_L = reg_addr_loc - 256 * addr_H
    i2c.start(id)
    i2c.address(id, dev_addr, i2c.TRANSMITTER)
    i2c.write(id, addr_H)
    i2c.write(id, addr_L)
    local c_local = i2c.write(id, data)
    i2c.stop(id) 
    return c_local
end

i2c_init()


