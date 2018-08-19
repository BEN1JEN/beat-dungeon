local menu = {}
local logo = love.graphics.newImage("assets/logo.png")
local menuSong = music.loadSong("assets/music/Bensound - Summer.mp3", 1)
local menuFont = love.graphics.newFont("assets/fonts/pixelated.ttf", 36)
local selectSong = false
local selectedSong = "Bensound - House.mp3"
local difficulty = 1
menuSong.play()

function menu.update(delta)
	beatsPassed, hasEnded = menuSong.getBeatsPassed(delta)
	if hasEnded then
		menuSong.play()
	end
	if love.keyboard.isDown("escape") then
		love.event.quit(0)
	end
	if love.mouse.isDown(1) then
		local mouseX, mouseY = love.mouse.getPosition()
		if selectSong then
			if mouseY > 124 and mouseY < 150 then
				selectSong = false
			end
			local songs = love.filesystem.getDirectoryItems("assets/music")
			for i, songName in ipairs(songs) do
				local y = i
				local x = 0
				if y > 14 then
					y = y - 14 - 6
					x = 640
				end
				if mouseY > 168+y*36 and mouseY < 204+y*36 and mouseX > x and mouseX < x+640 then
					selectedSong = songName
				end
			end
		else
			if mouseY > 150 and mouseY < 183 then
				menuSong.stop()
				song = music.loadSong("assets/music/" .. selectedSong, difficulty)
				world.gen(16, song.getSongLength() * 4 + 32)
				song.play()
				mode = "game"
			elseif mouseY > 183 and mouseY < 222 then
				selectSong = true
			elseif mouseY > 222 and mouseY < 258 then
				love.event.quit(0)
			elseif mouseY > 280 and mouseY < 316 then
				difficulty = 0.5
				menuSong.setBpmMultiplier(difficulty)
			elseif mouseY > 316 and mouseY < 352 then
				difficulty = 1
				menuSong.setBpmMultiplier(difficulty)
			elseif mouseY > 352 and mouseY < 388 then
				difficulty = 2
				menuSong.setBpmMultiplier(difficulty)
			end
		end
	end
end

function menu.draw()
	local mouseX, mouseY = love.mouse.getPosition()
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(logo, 0, 0)

	local brightness = menuSong.getBrightness()
	love.graphics.setColor((86 + ((225 - 86) * brightness)) / 256, (152 + ((242 - 152) * brightness)) / 256, (113 + ((235 - 113) * brightness)) / 256)
	if selectSong then
		local songs = love.filesystem.getDirectoryItems("assets/music")
		love.graphics.print("Done", math.max(18-math.abs(mouseY-(132)), 0), 124)
		for i, songName in ipairs(songs) do
			local y = i
			local x = 0
			if y > 14 then
				y = y - 14 - 6
				x = 640
			end
			local xOffset = 0
			if mouseX > x and mouseX < x+640 then
				xOffset = 18-math.abs(mouseY-(186+y*36))
			end
			songName = string.sub(songName, 1, string.len(songName)-4)
			if songName == string.sub(selectedSong, 1, string.len(selectedSong)-4) then
				songName = songName .. "*"
			end
			love.graphics.print(songName, math.max(xOffset+x, x), 168+y*36)
		end
	else
		love.graphics.setFont(menuFont)
		love.graphics.print("Play", math.max(18-math.abs(mouseY-168), 0), 150)
		love.graphics.print("Select Song (" .. string.sub(selectedSong, 1, string.len(selectedSong)-4) .. ")", math.max(18-math.abs(mouseY-204), 0), 186)
		love.graphics.print("Exit", math.max(18-math.abs(mouseY-240), 0), 222)

		local de, dn, dh = "", "", ""
		if difficulty == 0.5 then
			de = "*"
		elseif difficulty == 1 then
			dn = "*"
		elseif difficulty == 2 then
			dh = "*"
		end
		love.graphics.print("Easy" .. de, math.max(18-math.abs(mouseY-298), 0), 280)
		love.graphics.print("Normal" .. dn, math.max(18-math.abs(mouseY-334), 0), 316)
		love.graphics.print("Hard" .. dh, math.max(18-math.abs(mouseY-370), 0), 352)
	end
end

return menu
