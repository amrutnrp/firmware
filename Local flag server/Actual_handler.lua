
handle_client = function (text_inp)
	if string.sub (text_inp,1,3) == 'GET' 
	then

        print ('coming from Browser!! ')
	-- browser

	else 
	-- other ESP
	-- ask for password
		local token
		for token in string.gmatch( text_inp, "[^%s]+") do
		print(token)
		end
	end
end

print ('Handler declared')