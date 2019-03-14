function love.load()
	board = love.graphics.newImage('gfx/nmm_board.png')
	pieces = {}
	phase = 1 -- phases are (1) placing pieces, (2) moving placed pieces, (3) Flying- for more info see the wikipedia page for NMM
	mouseaction = ""
	local i = 50
	for it = 1,9 do
		local piece = {x = 225, y = i, r = 25, owner = "red", id = it, placement = "bank", state = "static"}
		i = i+50
		table.insert(pieces, piece)
	end
	i = 50
	for it = 1,9 do
		local piece = {x = 1075, y = i, r = 25, owner = "blue", id = 9+it, placement = "bank", state = "static"}
		i = i+50
		table.insert(pieces, piece)
	end
	turn = "red"
	spots = {
		{x = 300+16, y = 16, id = 1, w = 32, h = 32, resident = "neutral"},
		{x = 300+334, y = 16, id = 2, w = 32, h = 32, resident = "neutral"},
		{x = 300+652, y = 16, id = 3, w = 32, h = 32, resident = "neutral"},
		{x = 300+122, y = 122, id = 4, w = 32, h = 32, resident = "neutral"},
		{x = 300+334, y = 122, id = 5, w = 32, h = 32, resident = "neutral"},
		{x = 300+546, y = 122, id = 6, w = 32, h = 32, resident = "neutral"},
		{x = 300+228, y = 228, id = 7, w = 32, h = 32, resident = "neutral"},
		{x = 300+334, y = 228, id = 8, w = 32, h = 32, resident = "neutral"},
		{x = 300+440, y = 228, id = 9, w = 32, h = 32, resident = "neutral"},
		{x = 300+16, y = 334, id = 10, w = 32, h = 32, resident = "neutral"},
		{x = 300+122, y = 334, id = 11, w = 32, h = 32, resident = "neutral"},
		{x = 300+228, y = 334, id = 12, w = 32, h = 32, resident = "neutral"},
		{x = 300+440, y = 334, id = 13, w = 32, h = 32, resident = "neutral"},
		{x = 300+546, y = 334, id = 14, w = 32, h = 32, resident = "neutral"},
		{x = 300+652, y = 334, id = 15, w = 32, h = 32, resident = "neutral"},
		{x = 300+228, y = 440, id = 16, w = 32, h = 32, resident = "neutral"},
		{x = 300+334, y = 440, id = 17, w = 32, h = 32, resident = "neutral"},
		{x = 300+440, y = 440, id = 18, w = 32, h = 32, resident = "neutral"},
		{x = 300+122, y = 546, id = 19, w = 32, h = 32, resident = "neutral"},
		{x = 300+334, y = 546, id = 20, w = 32, h = 32, resident = "neutral"},
		{x = 300+546, y = 546, id = 21, w = 32, h = 32, resident = "neutral"},
		{x = 300+16, y = 652, id = 22, w = 32, h = 32, resident = "neutral"},
		{x = 300+334, y = 652, id = 23, w = 32, h = 32, resident = "neutral"},
		{x = 300+652, y = 652, id = 24, w = 32, h = 32, resident = "neutral"}
	}
	
end


function love.update(dt)
	mx, my = love.mouse.getPosition()
	
	for i,v in ipairs(pieces) do
		if phase == 1 then
			if v.placement == "bank" and turn == v.owner then
				if mx < v.x + v.r and mx > v.x - v.r and my < v.y + v.r and my > v.y - v.r then
					if love.mouse.isDown(1) and mouseaction == "" then
						v.state = "moving"
						mouseaction = "moving"
					end
				end
				if v.state == "moving" then
					v.x = mx
					v.y = my
					if love.mouse.isDown(1) then
						for ii,b in ipairs(spots) do
							if mx < b.x + b.w and mx > b.x and my < b.y + b.h and my > b.y then
								v.x = b.x + 15
								v.y = b.y + 15
								v.state = "static"
								mouseaction = ""
								v.placement = "board"
								b.resident = v.owner
								flipturn()
							end
						end
					end
				end	
			end
		end
	end
		
	
	if love.keyboard.isDown("space") then
		print("  ")
	end
	
	if spots[1].resident == spots[2].resident and spots[1].resident == spots[3].resident and spots[1].resident ~= "neutral" then
		print(spots[1].resident .. " wins!")
	elseif spots[1].resident == spots[10].resident and spots[1].resident == spots[22].resident and spots[1].resident ~= "neutral" then
		print(spots[1].resident .. " wins!")
	elseif spots[4].resident == spots[5].resident and spots[4].resident == spots[6].resident and spots[4].resident ~= "neutral" then
		print(spots[4].resident .. " wins!")
	elseif spots[7].resident == spots[8].resident and spots[7].resident == spots[9].resident and spots[7].resident ~= "neutral" then
		print(spots[7].resident .. " wins!")
	elseif spots[11].resident == spots[10].resident and spots[11].resident == spots[12].resident and spots[10].resident ~= "neutral" then
		print(spots[11].resident .. " wins!")
	elseif spots[13].resident == spots[14].resident and spots[13].resident == spots[15].resident and spots[13].resident ~= "neutral" then
		print(spots[13].resident .. " wins!")
	elseif spots[4].resident == spots[11].resident and spots[4].resident == spots[19].resident and spots[4].resident ~= "neutral" then
		print(spots[4].resident .. " wins!")
	elseif spots[3].resident == spots[15].resident and spots[3].resident == spots[24].resident and spots[3].resident ~= "neutral" then
		print(spots[3].resident .. " wins!")
	elseif spots[22].resident == spots[23].resident and spots[22].resident == spots[24].resident and spots[22].resident ~= "neutral" then
		print(spots[22].resident .. " wins!")
	elseif spots[6].resident == spots[14].resident and spots[6].resident == spots[21].resident and spots[6].resident ~= "neutral" then
		print(spots[6].resident .. " wins!")
	elseif spots[19].resident == spots[20].resident and spots[19].resident == spots[21].resident and spots[19].resident ~= "neutral" then
		print(spots[19].resident .. " wins!")
	elseif spots[16].resident == spots[17].resident and spots[16].resident == spots[18].resident and spots[16].resident ~= "neutral" then
		print(spots[16].resident .. " wins!")
	elseif spots[17].resident == spots[20].resident and spots[17].resident == spots[23].resident and spots[17].resident ~= "neutral" then
		print(spots[17].resident .. " wins!")
	elseif spots[2].resident == spots[5].resident and spots[2].resident == spots[8].resident and spots[2].resident ~= "neutral" then
		print(spots[2].resident .. " wins!")
	elseif spots[1].resident == spots[4].resident and spots[1].resident == spots[7].resident and spots[1].resident ~= "neutral" then
		print(spots[1].resident .. " wins!")
	elseif spots[3].resident == spots[6].resident and spots[3].resident == spots[9].resident and spots[3].resident ~= "neutral" then
		print(spots[3].resident .. " wins!")
	elseif spots[16].resident == spots[19].resident and spots[16].resident == spots[22].resident and spots[16].resident ~= "neutral" then
		print(spots[16].resident .. " wins!")
	elseif spots[18].resident == spots[21].resident and spots[18].resident == spots[24].resident and spots[18].resident ~= "neutral" then
		print(spots[18].resident .. " wins!")
	elseif spots[7].resident == spots[12].resident and spots[7].resident == spots[16].resident and spots[7].resident ~= "neutral" then
		print(spots[7].resident .. " wins!")
	elseif spots[9].resident == spots[13].resident and spots[9].resident == spots[18].resident and spots[9].resident ~= "neutral" then
		print(spots[9].resident .. " wins!")
	end
	
	
end

function flipturn()
	if turn == "red" then
		turn = "blue"
	else
		turn = "red"
	end
end

function love.draw()
	love.graphics.setColor(1, 1, 1)					--color to white
	love.graphics.draw(board, 300, 0)				--draw board
	for i,v in ipairs(pieces) do
		if v.owner == "red" then
			love.graphics.setColor(0.827, 0.235, 0.258)
			love.graphics.circle("fill", v.x, v.y, v.r)
		else
			love.graphics.setColor(0.235, 0.564, 0.827)
			love.graphics.circle("fill", v.x, v.y, v.r)
		end
	end
	--[[for i,v in ipairs(spots) do						--draws squares around the spots tokens are placable
		love.graphics.rectangle("line", v.x, v.y, 32, 32)
	end]]--
	love.graphics.print("It's " .. turn .. "'s turn", 100, 675)
end