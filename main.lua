function love.load()
	mills = {}
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
	pointerCarrying = "nothing"
	turn = "red"
	spots = {
		{x = 300+16, y = 16, id = 1, w = 32, h = 32, resident = "neutral", cons = {2, 10}},
		{x = 300+334, y = 16, id = 2, w = 32, h = 32, resident = "neutral", cons = {1, 3, 5}},
		{x = 300+652, y = 16, id = 3, w = 32, h = 32, resident = "neutral", cons = {2, 15}},
		{x = 300+122, y = 122, id = 4, w = 32, h = 32, resident = "neutral", cons = {11, 5}},
		{x = 300+334, y = 122, id = 5, w = 32, h = 32, resident = "neutral", cons = {2, 4, 6, 8}},
		{x = 300+546, y = 122, id = 6, w = 32, h = 32, resident = "neutral", cons = {5, 14}},
		{x = 300+228, y = 228, id = 7, w = 32, h = 32, resident = "neutral", cons = {12, 8}},
		{x = 300+334, y = 228, id = 8, w = 32, h = 32, resident = "neutral", cons = {7, 5, 9}},
		{x = 300+440, y = 228, id = 9, w = 32, h = 32, resident = "neutral", cons = {8, 13}},
		{x = 300+16, y = 334, id = 10, w = 32, h = 32, resident = "neutral", cons = {1, 11, 22}},
		{x = 300+122, y = 334, id = 11, w = 32, h = 32, resident = "neutral", cons = {10, 12, 4, 19}},
		{x = 300+228, y = 334, id = 12, w = 32, h = 32, resident = "neutral", cons = {7, 11, 16}},
		{x = 300+440, y = 334, id = 13, w = 32, h = 32, resident = "neutral", cons = {9, 14, 18}},
		{x = 300+546, y = 334, id = 14, w = 32, h = 32, resident = "neutral", cons = {6, 13, 15, 21}},
		{x = 300+652, y = 334, id = 15, w = 32, h = 32, resident = "neutral", cons = {3, 14, 24}},
		{x = 300+228, y = 440, id = 16, w = 32, h = 32, resident = "neutral", cons = {12, 17}},
		{x = 300+334, y = 440, id = 17, w = 32, h = 32, resident = "neutral", cons = {16, 18, 20}},
		{x = 300+440, y = 440, id = 18, w = 32, h = 32, resident = "neutral", cons = {13, 17}},
		{x = 300+122, y = 546, id = 19, w = 32, h = 32, resident = "neutral", cons = {11, 20}},
		{x = 300+334, y = 546, id = 20, w = 32, h = 32, resident = "neutral", cons = {17, 19, 21, 23}},
		{x = 300+546, y = 546, id = 21, w = 32, h = 32, resident = "neutral", cons = {14, 20}},
		{x = 300+16, y = 652, id = 22, w = 32, h = 32, resident = "neutral", cons = {10, 23}},
		{x = 300+334, y = 652, id = 23, w = 32, h = 32, resident = "neutral", cons = {20, 22, 24}},
		{x = 300+652, y = 652, id = 24, w = 32, h = 32, resident = "neutral", cons = {15, 23}}
	}
	inbank = 18
	needToRemove = 0
end

function love.update(dt)
	mx, my = love.mouse.getPosition()
	for i,v in ipairs(pieces) do
		if v.state == "moving" then
			v.x = mx
			v.y = my
		end
	end
end


allmills = { -- fourth val is "has this Mill been already made?"
	{1, 2, 3, false},{1, 10, 22, false},{4, 5, 6, false},{7, 8, 9, false},{10, 11, 12, false},{13, 14, 15, false},{4, 11, 19, false},{3, 15, 24, false},
	{22, 23, 24, false},{6, 14, 21, false},{19, 20, 21, false},{16, 17, 18, false},{17, 20, 23, false},{2, 5, 8, false},{1, 4, 7, false},
	{3, 6, 9, false},{16, 19, 22, false},{18, 21,24, false},{7, 12, 16, false},{9, 13, 18, false}
}

function checkForMills(placedp) --the placed pieces' location (v.placement)
	local continue = false
	for ind,val in ipairs(allmills) do 
		for m =1,3 do --evals if the mill-combo is even where the piece was placed
			if val[m] == placedp and val[4] == false then
				continue = true
			end
		end
		if continue == true then --evals if the mill-combo is a mill
			if spots[val[1]].resident == spots[val[2]].resident and spots[val[1]].resident == spots[val[3]].resident and spots[val[1]].resident ~= "neutral" and val[4] == false then
				print("We've got a mill on our hands" .. " " .. tostring(val[4]))
				val[4] = true
				needToRemove = 1
			end
		end
	end
end



function flipturn()
	if turn == "red" then
		turn = "blue"
	else
		turn = "red"
	end
end

--[[function createdMill(team, millspots) --i literally have no idea what this does anymore
	print("created mill")
	local otherteam = "blue"
	if team == "blue" then otherteam = "red" end
	--print("Player " .. team .. " created a mill! They get to remove one of " .. otherteam .. "'s tokens!")
	local contains = 0
	for i,v in pairs(mills) do
		if i == millspots then
			contains = 1
		end
	end
	if contains == 0 then
		needToRemove = 1
		table.insert(mills, millspots)
	end
end]]--

function love.mousepressed(mousex, mousey)
	if needToRemove == 1 then
		for i,v in ipairs(pieces) do
			if mousex < v.x + v.r and mousex > v.x - v.r and mousey < v.y + v.r and mousey > v.y - v.r and pointerCarrying == "nothing" and turn ~= v.owner then
				if v.state == "static" and v.placement ~= "bank" then
					spots[v.placement].resident = "neutral"
					v.placement = "gone"
					needToRemove = 0
					flipturn()
				end
			end
		end
	end
	if phase == 1 and needToRemove == 0 then
		if pointerCarrying == "nothing" then
			for i,v in ipairs(pieces) do
				if mousex < v.x + v.r and mousex > v.x - v.r and mousey < v.y + v.r and mousey > v.y - v.r and pointerCarrying == "nothing" and turn == v.owner then
					if v.state == "static" and v.placement == "bank" then
						v.state = "moving"
						mouseaction = "picking"
						pointerCarrying = v.id
					end
				end
			end
		else
			local v = pieces[pointerCarrying]
			for i,b in ipairs(spots) do
				if mousex < b.x + b.w and mousex > b.x and mousey < b.y + b.h and mousey > b.y and b.resident == "neutral" then
					v.x = b.x + 15
					v.y = b.y + 15
					v.state = "static"
					v.placement = b.id
					b.resident = v.owner
					pointerCarrying = "nothing"
					checkForMills(v.placement)
					inbank = inbank - 1
					if inbank == 0 then
						phase = 2
					end
					if needToRemove == 0 then
						flipturn()
					end
				end
			end
		end
	elseif phase == 2 and needToRemove == 0 then
		if pointerCarrying == "nothing" then
			for i,v in ipairs(pieces) do
				if mousex < v.x + v.r and mousex > v.x - v.r and mousey < v.y + v.r and mousey > v.y - v.r and turn == v.owner then
					v.state = "moving"
					mouseaction = "picking"
					spots[v.placement].resident = "neutral"
					pointerCarrying = v.id
				end
			end
		else
			local v = pieces[pointerCarrying]
			for i,b in ipairs(spots) do
				if mousex < b.x + b.w and mousex > b.x and mousey < b.y + b.h and mousey > b.y then
					for index,value in ipairs(spots[v.placement].cons) do
						if (value == b.id and b.resident == "neutral") or (b.id == v.placement) then
							v.x = b.x + 15
							v.y = b.y + 15
							v.state = "static"
							v.placement = b.id
							b.resident = v.owner
							pointerCarrying = "nothing"
							checkForMills(v.placement)
							if value == b.id and needToRemove == 0 then
								flipturn()
							end
						end
					end
				end
			end
		end
	end
	
end

function love.draw()
	love.graphics.setColor(1, 1, 1)					--color to white
	love.graphics.draw(board, 300, 0)				--draw board
	for i,v in ipairs(pieces) do
		if v.placement ~= "gone" then
			if v.owner == "red" then
				love.graphics.setColor(0.827, 0.235, 0.258)
				love.graphics.circle("fill", v.x, v.y, v.r)
			else
				love.graphics.setColor(0.235, 0.564, 0.827)
				love.graphics.circle("fill", v.x, v.y, v.r)
			end
		end
	end
	--[[for i,v in ipairs(spots) do						--draws squares around the spots tokens are placable
		love.graphics.rectangle("line", v.x, v.y, 32, 32)
	end]]--
	love.graphics.print("It's " .. turn .. "'s turn", 100, 675)
end
