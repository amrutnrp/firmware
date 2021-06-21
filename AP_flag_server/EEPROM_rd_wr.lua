
scan_i2c = function ()
    id  = 0
    sda = 2
    scl = 1
    --dev_addr = 0x50
    --reg_addr = 77
    -- initialize i2c, set pin 1 as sda, set pin 2 as scl
    i2c.setup(id, sda, scl, i2c.SLOW)
    for i=0,127 do
        i2c.start(id)
        resCode = i2c.address(id, i, i2c.TRANSMITTER)
        i2c.stop(id)
        --print (i, resCode)
        if resCode == true then print("We have a device on address 0x" .. string.format("%02x", i) .. " (" .. i ..")") end
    end
end


i2c_init= function()
    id  = 0
    sda = 2
    scl = 1
    dev_addr = 0x50
    reg_addr = 0x00
    -- initialize i2c, set pin 1 as sda, set pin 2 as scl
    i2c.setup(id, sda, scl, i2c.SLOW)
end

read_reg = function (dev_addr, reg_addr)
    i2c.start(id)
    i2c.address(id, dev_addr, i2c.TRANSMITTER)
    i2c.write(id, reg_addr)
    i2c.write(id, reg_addr)
    i2c.stop(id)
	
    i2c.start(id)
    i2c.address(id, dev_addr, i2c.RECEIVER)
    c = i2c.read(id, 1)
    i2c.stop(id)
    return c
end



function write_reg(dev_addr, reg_addr, data)

	-- make write protect off,  turn GPIO low
    i2c.start(id)
    ret= i2c.address(id, dev_addr, i2c.TRANSMITTER)
    i2c.write(id, reg_addr)
    i2c.write(id, reg_addr)
    c = i2c.write(id, data)
    print (c)
    i2c.stop(id) 
    return c
end


print (reg)
--data = "s"
-- AX  = A1, A2, A3, RW
reg = read_reg(0x58, 0x00)
count = write_reg(0x58, 0x00, "Y")

--i2c_init()
--scan_i2c()

--print (bit.rshift(0x156, 8))

