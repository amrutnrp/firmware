master_table = {}

handle_client = function (text_inp)
    local  got_table= {}
    local  query= ''
    local flag= 1
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

        if ( got_table[ 2] ==  RD_key  ) then  -- check password
            if  ( got_table[ 3] == '0'  ) then -- read 
                if master_table [got_table[ 5] ] == nil then
                    flag= 0
                    query = query .. 'X '--invalid reading
                else
                    query= query ..  master_table [got_table[ 5] ] ..' '
                end
            elseif  ( got_table[ 3] == '1'  )  then -- write 
                if master_table [got_table[ 4] ] == 1 then  -- save as history
                    local s= master_table [got_table[ 3] ]   
                end
                master_table [got_table[ 5] ] = got_table[ 6]
            else  -- it's not valid
                flag= 0
            end
        else
            flag= 0
        end
	end
    return tostring(flag)..' '.. query
end

print ('Handler declared')

