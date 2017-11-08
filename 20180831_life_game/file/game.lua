local composer = require( "composer" )
local widget = require "widget"
local userData = require "file.data"
local am = require "file.alertMessage"

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local _W, _H = display.contentWidth, display.contentHeight

local CC = function (hex)
	local r = tonumber( hex:sub(1,2), 16 ) / 255
	local g = tonumber( hex:sub(3,4), 16 ) / 255
	local b = tonumber( hex:sub(5,6), 16 ) / 255
	local a = 255 / 255

	if #hex == 8 then a = tonumber( hex:sub(7,8), 16 ) / 255 end

	return r, g, b, a
end

local statusBar, statusBar_content

local bg, bg_content
local bg_height = 720 - 96
local pop, pop_content, pop_button

local bgm_num = 1
local function playBGM()
	media.playSound( "sound/"..bgm_num..".mp3", playBGM )
	bgm_num = bgm_num % 3 + 1
end

-- -----------------------------------------------------------------------------------
-- basic settttting!
-- -----------------------------------------------------------------------------------
---0X : street
-- 01 : street1
-- 02 : street2
-- 03 : street3
-- 04 : street4
-- 05 : street5
-- 06 : street6
-- 07
-- 08
-- 09
---1X : place
-- 10 : house
-- 11 : room
-- 12 : gym
-- 13 : mart

-- -X : statusbar pop-up
-- -1 : myInfo
-- -2 : bag

-- 0X : pop-up
-- 00 : bus-stop
-- 01 : sink
-- 02 : book
-- 03 : notebook
-- 04 : run
-- 05 : ben
-- 06 : san

function checkUserState()
	if userData.getData("hp") < 15 then
		-- go hospital
		am.alertMessage("저체력 상태가 되어 병원으로 이동합니다.")
	end

	if userData.getData("weight") < 30 then
	elseif userData.getData("weight") < 40 then
	end
end

function removeContent()
	bg:removeSelf()
	for i = 1, table.maxn(bg_content), 1 do
		bg_content[i]:removeSelf( )
		bg_content[i] = nil
	end
	bg_content = nil
end

function showPop(popNum)
	-- set button false
	for i = 1, table.maxn(bg_content), 1 do
		if bg_content[i].id == 'widget_button' then
			bg_content[i]:setEnabled(false)
		end
	end

	-- create pop
	pop_bg = display.newRect( 0, 97, _W, _H-97 )
	pop_bg.anchorX, pop_bg.anchorY = 0, 0
	pop_bg:setFillColor( 1, 1, 1, 0.5 )
	pop = display.newImage("image/popup.png", _W*0.5, 48+_H*0.5 )
	pop:scale(0.7, 0.7)

	pop_button = widget.newButton(
	{
		width = 43,
		height = 43,
		top = _H*0.3,
		left = pop.x + pop.contentWidth*0.5 - 44,
		top = pop.y - pop.contentHeight*0.5 + 2,
		defaultFile = "image/popup_button.png",
		overFile = "image/popup_button.png",
		onRelease = closePop
	})
	-- print(pop.anchorX + pop.contentWidth*0.5 - 43)

	pop_content = {}

	if popNum < 0 then -- statusbar
		local basicTop = _H*0.47

		-- set button false
		button_bag:setEnabled( false )
		button_myInfo:setEnabled( false )

		if popNum == -1 then --myInfo
			pop_content[1] = display.newText( "내 정보", _W*0.5, _H*0.35, native.newFont( "NanumSquareB.ttf" ), 30 )
			pop_content[1]:setFillColor( 0 )

			-- name
			pop_content[2] = display.newText( "이름", _W*0.275, basicTop, native.newFont("NanumSquareB.ttf"), 25 )
			pop_content[2]:setFillColor( 0 )
			pop_content[3] = display.newText( userData.getData("name"), _W*0.4, basicTop, native.newFont("NanumSquareB.ttf"), 25 )
			pop_content[3]:setFillColor( 0 )

			-- state
			pop_content[4] = display.newText( "상태", _W*0.6, basicTop, native.newFont("NanumSquareB.ttf"), 25 )
			pop_content[4]:setFillColor( 0 )
			pop_content[5] = display.newText( ( userData.getData("hp") <= 15 ) and "저체력" or ( ( userData.getData("weight") <= 40 ) and "저체중" or "정상" ), _W*0.7, basicTop, native.newFont("NanumSquareB.ttf"), 25 )
			pop_content[5]:setFillColor( 0 )


			-- hp/maxHP
			pop_content[6] = display.newText( "현재 체력", _W*0.275, basicTop+_H*0.1, native.newFont("NanumSquareB.ttf"), 25 )
			pop_content[6]:setFillColor( 0 )
			pop_content[7] = display.newText( userData.getData("hp").."/"..userData.getData("maxHP"), _W*0.4, basicTop+_H*0.1, native.newFont("NanumSquareB.ttf"), 25 )
			pop_content[7]:setFillColor( 0 )

			-- weight
			pop_content[8] = display.newText( "현재 체중", _W*0.6, basicTop+_H*0.1, native.newFont("NanumSquareB.ttf"), 25 )
			pop_content[8]:setFillColor( 0 )
			pop_content[9] = display.newText( userData.getData("weight"), _W*0.7, basicTop+_H*0.1, native.newFont("NanumSquareB.ttf"), 25 )
			pop_content[9]:setFillColor( 0 )


			-- attack
			pop_content[10] = display.newText( "현재 공격력", _W*0.275, basicTop+_H*0.2, native.newFont("NanumSquareB.ttf"), 25 )
			pop_content[10]:setFillColor( 0 )
			pop_content[11] = display.newText( userData.getData("attack"), _W*0.4, basicTop+_H*0.2, native.newFont("NanumSquareB.ttf"), 25 )
			pop_content[11]:setFillColor( 0 )

			-- int
			pop_content[12] = display.newText( "현재 지능", _W*0.6, basicTop+_H*0.2, native.newFont("NanumSquareB.ttf"), 25 )
			pop_content[12]:setFillColor( 0 )
			pop_content[13] = display.newText( userData.getData("int"), _W*0.7, basicTop+_H*0.2, native.newFont("NanumSquareB.ttf"), 25 )
			pop_content[13]:setFillColor( 0 )


			-- beauty
			pop_content[14] = display.newText( "현재 매력", _W*0.275, basicTop+_H*0.3, native.newFont("NanumSquareB.ttf"), 25 )
			pop_content[14]:setFillColor( 0 )
			pop_content[15] = display.newText( userData.getData("beauty"), _W*0.4, basicTop+_H*0.3, native.newFont("NanumSquareB.ttf"), 25 )
			pop_content[15]:setFillColor( 0 )

			-- luck
			pop_content[16] = display.newText( "현재 운", _W*0.6, basicTop+_H*0.3, native.newFont("NanumSquareB.ttf"), 25 )
			pop_content[16]:setFillColor( 0 )
			pop_content[17] = display.newText( userData.getData("luck"), _W*0.7, basicTop+_H*0.3, native.newFont("NanumSquareB.ttf"), 25 )
			pop_content[17]:setFillColor( 0 )
		elseif popNum == -2 then --bag
			-- beef
			pop_content[1] = display.newImageRect( userData.getData("steak") == 0 and "image/button_beef.png" or "image/button_beef_c.png" , 100, 100 )
			pop_content[1].x, pop_content[1].y = _W*0.23, _H*0.4

			pop_content[2] = display.newText( userData.getData("steak").."개", pop_content[1].x, pop_content[1].y + 90, native.newFont( "NanumSquareB.ttf" ), 25 )
			pop_content[2]:setFillColor( 0 )

			-- drink
			pop_content[3] = display.newImageRect(  userData.getData("drink") == 0 and "image/button_drink.png" or "image/button_drink_c.png " , 60, 100 )
			pop_content[3].x, pop_content[3].y = _W*0.47, _H*0.4

			pop_content[4] = display.newText( userData.getData("drink").."개", pop_content[3].x, pop_content[3].y + 90, native.newFont( "NanumSquareB.ttf" ), 25 )
			pop_content[4]:setFillColor( 0 )

			-- ramen
			pop_content[5] = display.newImageRect( userData.getData("ramen") == 0 and "image/button_ramen_b.png" or "image/button_ramen.png", 100, 100 )
			pop_content[5].x, pop_content[5].y = _W*0.35, _H*0.4

			pop_content[6] = display.newText( userData.getData("ramen").."개", pop_content[5].x, pop_content[5].y + 90, native.newFont( "NanumSquareB.ttf" ), 25 )
			pop_content[6]:setFillColor( 0 )

			-- snack
			pop_content[7] = display.newImageRect( userData.getData("snack") == 0 and "image/button_snack.png" or "image/button_snack_c.png", 95, 100 )
			pop_content[7].x, pop_content[7].y = _W*0.575, _H*0.4

			pop_content[8] = display.newText( userData.getData("snack").."개", pop_content[7].x, pop_content[7].y + 90, native.newFont( "NanumSquareB.ttf" ), 25 )
			pop_content[8]:setFillColor( 0 )

			-- mirror
			pop_content[9] = display.newImageRect( userData.getData("mirror") == 0 and "image/button_mirror.png" or "image/button_mirror_c.png", 75, 100 )
			pop_content[9].x, pop_content[9].y = _W*0.23, _H*0.7

			pop_content[10] = display.newText( userData.getData("mirror").."개", pop_content[9].x, pop_content[9].y + 90, native.newFont( "NanumSquareB.ttf" ), 25 )
			pop_content[10]:setFillColor( 0 )

			-- book
			pop_content[11] = display.newImageRect( userData.getData("book") == 0 and "image/button_book.png" or "image/button_book_c.png", 100, 100 )
			pop_content[11].x, pop_content[11].y = _W*0.34, _H*0.7

			pop_content[12] = display.newText( userData.getData("book").."개", pop_content[11].x, pop_content[11].y + 90, native.newFont( "NanumSquareB.ttf" ), 25 )
			pop_content[12]:setFillColor( 0 )
		end
	elseif popNum == 0 then
	elseif popNum == 1 then -- sink
		-- steak
		pop_content[1] = display.newImage( userData.getData("steak") == 0 and "image/button_beef.png" or "image/button_beef_c.png" )
		pop_content[1].x, pop_content[1].y = _W*0.3, _H*0.42
		pop_content[2] = display.newText( "남은 개수 : "..userData.getData("steak").."개", pop_content[1].x, pop_content[1].y + 140, native.newFont( "NanumSquareB.ttf"), 25 )
		pop_content[2]:setFillColor( 0 )

		-- button_cook
		pop_content[3] = widget.newButton(
		{
			width = 242*0.7,
			height = 68*0.7,
			y = pop_content[2].y+90,
			x = pop_content[2].x,
			defaultFile = "image/button_cook.png",
			overFile = "image/button_cooko.png",
			onRelease = function()
				if userData.getData("steak") > 0 then
					userData.setData( "steak", userData.getData("steak") - 1 )
					userData.setData( "hp", userData.getData("hp") + 50 < userData.getData("maxHP") and userData.getData("hp") + 50 or userData.getData("maxHP") )
					userData.setData( "weight", userData.getData("weight") + 5 )
					refresh()
					pop_content[2].text = "남은 개수 : "..userData.getData("steak").."개"

					if userData.getData("steak") == 0 then
						pop_content[1]:removeSelf( )
						pop_content[1] = display.newImage( "image/button_beef.png" )
						pop_content[1].x, pop_content[1].y = _W*0.3, _H*0.42
					end
				else
					am.alertMessage("요리할 수 있는 음식이 없습니다.")
				end
			end
		})


		-- ramen
		pop_content[4] = display.newImage( userData.getData("ramen") == 0 and "image/button_ramen_b.png" or "image/button_ramen.png" )
		pop_content[4].x, pop_content[4].y = _W*0.5, _H*0.42
		pop_content[5] = display.newText( "남은 개수 : "..userData.getData("ramen").."개", pop_content[4].x, pop_content[4].y + 140, native.newFont( "NanumSquareB.ttf"), 25 )
		pop_content[5]:setFillColor( 0 )

		print("hi")

		-- button_cook
		pop_content[6] = widget.newButton(
		{
			width = 242*0.7,
			height = 68*0.7,
			y = pop_content[5].y+90,
			x = pop_content[5].x,
			defaultFile = "image/button_cook.png",
			overFile = "image/button_cooko.png",
			onRelease = function()
				if userData.getData("ramen") > 0 then
					userData.setData( "ramen", userData.getData("ramen") - 1 )
					userData.setData( "hp", userData.getData("hp") + 15 < userData.getData("maxHP") and userData.getData("hp") + 15 or userData.getData("maxHP") )
					userData.setData( "weight", userData.getData("weight") + 2 )
					refresh()
					pop_content[5].text = "남은 개수 : "..userData.getData("ramen").."개"

					if userData.getData("ramen") == 0 then
						pop_content[4]:removeSelf()
						pop_content[4] = display.newImage( "image/button_ramen_b.png" )
						pop_content[4].x, pop_content[4].y = _W*0.5, _H*0.42
					end
				else
					am.alertMessage("요리할 수 있는 음식이 없습니다.")
				end
			end
		})

		-- snack
		pop_content[7] = display.newImage( userData.getData("snack") == 0 and "image/button_snack.png" or "image/button_snack_c.png" )
		pop_content[7].x, pop_content[7].y = _W*0.7, _H*0.42
		pop_content[7]:scale(1.5,1.5)
		pop_content[8] = display.newText( "남은 개수 : "..userData.getData("snack").."개", pop_content[7].x, pop_content[7].y + 140, native.newFont( "NanumSquareB.ttf"), 25 )
		pop_content[8]:setFillColor( 0 )

		-- button_cook
		pop_content[9] = widget.newButton(
		{
			width = 242*0.7,
			height = 68*0.7,
			y = pop_content[8].y+90,
			x = pop_content[8].x,
			defaultFile = "image/button_cook.png",
			overFile = "image/button_cooko.png",
			onRelease = function()
				if userData.getData("snack") > 0 then
					userData.setData( "snack", userData.getData("snack") - 1 )
					userData.setData( "hp", userData.getData("hp") + 7 < userData.getData("maxHP") and userData.getData("hp") + 7 or userData.getData("maxHP") )
					userData.setData( "weight", userData.getData("weight") + 0.5 )
					refresh()
					pop_content[8].text = "남은 개수 : "..userData.getData("snack").."개"

					if userData.getData("snack") == 0 then
						pop_content[7]:removeSelf( )
						pop_content[7] = display.newImage( "image/button_snack.png" )
						pop_content[7].x, pop_content[7].y = _W*0.7, _H*0.42
						pop_content[7]:scale(1.5,1.5)
					end
				else
					am.alertMessage("요리할 수 있는 음식이 없습니다.")
				end
			end
		})
	elseif popNum == 2 then -- book

		-- progress_book
		pop_content[1] = widget.newProgressView(
		{
			x = _W * 0.5,
			y = _H * 0.35,
			width = _W * 0.5,
		})

		-- button_book
		pop_content[2] = widget.newButton(
		{
			width = 249,
			height = 240,
			x = _W * 0.5,
			y = _H * 0.65,
			defaultFile = "image/button_book.png",
			overFile = "image/button_booko.png",
			onRelease = function()
				local n = pop_content[1]:getProgress( )
				pop_content[1]:setProgress( n + 0.04 )

				if pop_content[1]:getProgress( ) == 1 then
					userData.setData("int", userData.getData("int") + 1 )
					userData.setData("hp", userData.getData("hp") - 0.5 )
					userData.setData("weight", userData.getData("weight") - 0.1 )
					pop_content[1]:setProgress( 0 )
					refresh()

					checkUserState()
				end
			end
		})

	elseif popNum == 3 then -- notebook
	elseif popNum == 4 then -- run

		-- progress_run
		pop_content[1] = widget.newProgressView(
		{
			x = _W * 0.5,
			y = _H * 0.35,
			width = _W * 0.5,
		})

		-- button_run
		pop_content[2] = widget.newButton(
		{
			width = 159,
			height = 283,
			x = _W * 0.5,
			y = _H * 0.65,
			defaultFile = "image/button_run.png",
			overFile = "image/button_runo.png",
			onRelease = function()
				local n = pop_content[1]:getProgress( )
				pop_content[1]:setProgress( n + 0.04 )

				if pop_content[1]:getProgress( ) == 1 then
					userData.setData("maxHP", userData.getData("maxHP") + 1 )
					userData.setData("hp", userData.getData("hp") - 2 )
					userData.setData("weight", userData.getData("weight") - 0.5 )
					pop_content[1]:setProgress( 0 )
					refresh()

					if userData.getData("hp") < 15 then
						-- go hospital
						am.alertMessage("저체력 상태가 되어 병원으로 이동합니다.")
					end
				end
			end
		})

	elseif popNum == 5 then -- ben

		-- progress_ben
		pop_content[1] = widget.newProgressView(
		{
			x = _W * 0.5,
			y = _H * 0.35,
			width = _W * 0.5,
		})

		-- button_ben
		pop_content[2] = widget.newButton(
		{
			width = 249,
			height = 240,
			x = _W * 0.5,
			y = _H * 0.65,
			defaultFile = "image/button_ben.png",
			overFile = "image/button_beno.png",
			onRelease = function()
				local n = pop_content[1]:getProgress( )
				pop_content[1]:setProgress( n + 0.04 )

				if pop_content[1]:getProgress( ) == 1 then
					userData.setData( "maxHP", userData.getData("maxHP") + 0.5 )
					userData.setData( "hp", userData.getData("hp") - 3 )
					userData.setData( "weight", userData.getData("weight") - 0.5 )
					userData.setData( "attack", userData.getData("attack") + 0.5 )
					pop_content[1]:setProgress( 0 )
					refresh()

					if userData.getData("hp") < 15 then
						-- go hospital
					end
				end
			end
		})

	elseif popNum == 6 then -- san

		-- progress_san
		pop_content[1] = widget.newProgressView(
		{
			x = _W * 0.5,
			y = _H * 0.35,
			width = _W * 0.5,
		})

		-- button_san
		pop_content[2] = widget.newButton(
		{
			width = 136 * 0.6,
			height = 420 * 0.6,
			x = _W * 0.5,
			y = _H * 0.65,
			defaultFile = "image/button_sand.png",
			overFile = "image/button_sando.png",
			onRelease = function()
				local n = pop_content[1]:getProgress( )
				pop_content[1]:setProgress( n + 0.04 )

				if pop_content[1]:getProgress( ) == 1 then
					userData.setData( "maxHP", userData.getData("maxHP") + 0.5 )
					userData.setData( "hp", userData.getData("hp") - 4 )
					userData.setData( "weight", userData.getData("weight") - 1.5 )
					userData.setData( "attack", userData.getData("attack") + 1.5 )
					pop_content[1]:setProgress( 0 )
					refresh()

					if userData.getData("hp") < 15 then
						-- go hospital
					end
				end
			end
		})
	end
end

function closePop()
	-- set button true
	for i = 1, table.maxn(bg_content), 1 do
		if bg_content[i].id == 'widget_button' then
			bg_content[i]:setEnabled(true)
		end
	end


	-- set button false
	button_bag:setEnabled( true )
	button_myInfo:setEnabled( true )


	-- remove pop
	pop:removeSelf( )
	pop_button:removeSelf( )
	pop_bg:removeSelf( )
	pop = nil
	pop_bg = nil
	pop_button = nil

	--remove popContent
	for i = 1, table.maxn(pop_content), 1 do
		pop_content[i]:removeSelf( )
		pop_content[i] = nil
	end
	pop_content = nil
end

function createActivity(place)
	if place < 10 then -- street
		bg = display.newImage( "image/bg_street.png", _W*0.5, bg_height*0.5 + 120 )
		bg.contentHeight = bg_height
		bg:toBack( )

		bg_content = {}

		if place == 1 then
			bg_content[1] = widget.newButton(
			{
				width = 231,
				height = 240,
				x = _W*0.15,
				y = _H*0.5,
				defaultFile = "image/icon_gym.png",
				overFile = "image/icon_gym.png",
				onRelease = function()
					if userData.getData("money") < 3000 then
						am.alertMessage("돈이 부족합니다. 체육관 이용료는 3000원입니다.")
					else
						removeContent() createActivity(12)
					end
				end
			})

			bg_content[2] = widget.newButton(
			{
				width = 240,
				height = 240,
				x = _W*0.42,
				y = _H*0.5,
				defaultFile = "image/icon_home.png",
				overFile = "image/icon_home.png",
				onRelease = function() removeContent() createActivity(10) end
			})

			bg_content[3] = widget.newButton(
			{
				width = 230,
				height = 230,
				x = _W * 0.68,
				y = _H * 0.5,
				defaultFile = "image/icon_mart.png",
				overFile = "image/icon_mart.png",
				onRelease = function() removeContent() createActivity(13) end
			})
		elseif place == 2 then
		end

		bg_content[ table.maxn(bg_content) + 1 ] = widget.newButton(
		{
			width = 78,
			height = 225,
			x = _W * 0.9,
			y = _H * 0.5,
			defaultFile = "image/icon_bus.png",
			overFile = "image/icon_bus.png",
			onRelease = function()
				showPop(0)
			end
		})
	elseif place == 10 then -- house
		bg = display.newImage( "image/bg_home.png", _W*0.5, bg_height*0.5 + 96 )
		bg.contentHeight = bg_height
		bg:toBack( )

		bg_content = {}

		-- button_room
		bg_content[1] = widget.newButton(
		{
			width = 208*0.7,
			height = 344*0.7,
			top = _H*0.265,
			left = _W*0.55,
			defaultFile = "image/button_room.png",
			overFile = "image/button_roomo.png",
			onRelease = function() removeContent() createActivity(11) end
		})

		--button_door
		bg_content[2] = widget.newButton(
		{
			width = 163*0.7,
			height = 479*0.7,
			top = _H * 0.29,
			left = _W * 0.85,
			defaultFile = "image/button_door.png",
			overFile = "image/button_dooro.png",
			onRelease = function() removeContent() createActivity(1) end
		})

		--button_sink
		bg_content[3] = widget.newButton(
		{
			width = 366,
			height = 555 * 0.87,
			top = _H * 0.32,
			left = _W * 0,
			defaultFile = "image/button_sink.png",
			overFile = "image/button_sinko.png",
			onRelease = function() showPop(1) end
		})
	elseif place == 11 then -- room
		bg = display.newImage( "image/bg_room_1.png", _W*0.5, bg_height*0.5 + 96 )
		bg.contentHeight = bg_height
		bg:toBack( )

		bg_content = {}

		-- button_book
		bg_content[1] = widget.newButton(
		{
			width = 180,
			height = 127,
			x = _W*0.37,
			y = _H*0.5,
			defaultFile = "image/button_readBook.png",
			overFile = "image/button_readBook.png",
			onRelease = function() showPop(2) end
		})

		-- button_laptop
		bg_content[2] = widget.newButton(
		{
			width = 180,
			height = 127,
			x = _W*0.62,
			y = _H*0.5,
			defaultFile = "image/button_laptop.png",
			overFile = "image/button_laptop.png",
			onRelease = function() showPop(3) end
		})

		bg_content[3] = widget.newButton(
		{
			width = 127,
			height = 105,
			x = _W*0.93,
			y = _H*0.22,
			defaultFile = "image/button_back.png",
			overFile = "image/button_backo.png",
			onRelease = function() removeContent() createActivity(10) end
		})
	elseif place == 12 then -- gym
		userData.setData("money", userData.getData("money") - 3000 )
		refresh()

		bg = display.newImage( "image/bg_gym.png", _W*0.5, bg_height*0.5 + 96 )
		bg.contentHeight = bg_height
		bg:toBack( )

		bg_content = {}

		-- button_run
		bg_content[1] = widget.newButton(
		{
			width = 319*0.5,
			height = 566*0.5,
			x = _W*0.27,
			y = _H*0.65,
			defaultFile = "image/button_run.png",
			overFile = "image/button_run.png",
			onRelease = function() showPop(4) end
		})

		-- button_ben
		bg_content[2] = widget.newButton(
		{
			width = 360*0.6,
			height = 505*0.6,
			x = _W*0.535,
			y = _H*0.65,
			defaultFile = "image/button_ben.png",
			overFile = "image/button_ben.png",
			onRelease = function() showPop(5) end
		})

		-- button_san
		bg_content[3] = widget.newButton(
		{
			width = 136*0.7,
			height = 420*0.7,
			top = 96,
			left = _W * 0.75,
			defaultFile = "image/button_sand.png",
			overFile = "image/button_sand.png",
			onRelease = function() showPop(6) end
		})

		bg_content[4] = widget.newButton(
		{
			width = 127,
			height = 105,
			x = _W*0.93,
			y = _H*0.22,
			defaultFile = "image/button_back.png",
			overFile = "image/button_backo.png",
			onRelease = function() removeContent() createActivity(1) end
		})

		am.alertMessage("체육관 이용료로 3000원을 지불하였습니다.", 's')
	elseif place == 13 then -- mart
		bg = display.newImage( "image/bg_shop.png", _W*0.5, bg_height*0.5 + 96 )
		bg.contentHeight = bg_height
		bg:toBack( )

		bg_content = {}

		bg_content[1] = widget.newButton(
		{
			width = 145,
			height = 110,
			x = _W*0.162,
			y = _H*0.4,
			defaultFile = "image/button_beef_c.png",
			overFile = "image/button_beef_c_s.png",
			onRelease = function()
				if userData.getData("money") >= 8000 then
					userData.setData("money", userData.getData("money") - 8000 )
					userData.setData("steak", userData.getData("steak") + 1 )
					refresh()
				else
					am.alertMessage("돈이 부족합니다.")
				end
			end
		})

		bg_content[2] = display.newText( "한우", bg_content[1].x - _W*0.02, bg_content[1].y + _H*0.22, native.newFont("NanumSquareB.ttf"), 30, "center" )
		bg_content[2]:setFillColor(0)

		bg_content[3] = display.newText( "5000원", bg_content[1].x - _W*0.02, bg_content[1].y + _H*0.27, native.newFont("NanumSquareB.ttf"), 25, "center" )
		bg_content[3]:setFillColor(0)

		bg_content[4] = widget.newButton(
		{
			width = 110,
			height = 129,
			x = bg_content[1].x + _W*0.135,
			y = _H*0.4,
			defaultFile = "image/button_ramen.png",
			overFile = "image/button_rameno.png",
			onRelease = function()
				if userData.getData("money") >= 4000 then
					userData.setData("money", userData.getData("money") - 4000 )
					userData.setData("ramen", userData.getData("ramen") + 1 )
					refresh()
				else
					am.alertMessage("돈이 부족합니다.")
				end
			end
		})

		bg_content[5] = display.newText( "라면", bg_content[4].x - _W*0.01, bg_content[4].y + _H*0.22, native.newFont("NanumSquareB.ttf"), 30, "center" )
		bg_content[5]:setFillColor(0)

		bg_content[6] = display.newText( "4000원", bg_content[4].x - _W*0.01, bg_content[4].y + _H*0.27, native.newFont("NanumSquareB.ttf"), 25, "center" )
		bg_content[6]:setFillColor(0)

		bg_content[7] = widget.newButton(
		{
			width = 66,
			height = 130,
			x = bg_content[4].x + _W*0.125,
			y = _H*0.4,
			defaultFile = "image/button_drink_c.png",
			overFile = "image/button_drink_c_s.png",
			onRelease = function()
				if userData.getData("money") >= 1500 then
					userData.setData("money", userData.getData("money") - 1500 )
					userData.setData("drink", userData.getData("drink") + 1 )
					refresh()
				else
					am.alertMessage("돈이 부족합니다.")
				end
			end
		})

		bg_content[8] = display.newText( "음료수", bg_content[7].x, bg_content[7].y + _H*0.22, native.newFont("NanumSquareB.ttf"), 30, "center" )
		bg_content[8]:setFillColor(0)

		bg_content[9] = display.newText( "1500원", bg_content[7].x, bg_content[7].y + _H*0.27, native.newFont("NanumSquareB.ttf"), 25, "center" )
		bg_content[9]:setFillColor(0)


		bg_content[10] = widget.newButton(
		{
			width = 121.5,
			height = 130.5,
			x = bg_content[7].x + _W*0.13,
			y = _H*0.4,
			defaultFile = "image/button_snack_c.png",
			overFile = "image/button_snack_c_s.png",
			onRelease = function()
				if userData.getData("money") >= 2500 then
					userData.setData("money", userData.getData("money") - 2500 )
					userData.setData("snack", userData.getData("snack") + 1 )
					refresh()
				else
					am.alertMessage("돈이 부족합니다.")
				end
			end
		})

		bg_content[11] = display.newText( "과자", bg_content[10].x + _W*0.005, bg_content[10].y + _H*0.22, native.newFont("NanumSquareB.ttf"), 30, "center" )
		bg_content[11]:setFillColor(0)

		bg_content[12] = display.newText( "2500원", bg_content[10].x + _W*0.005, bg_content[10].y + _H*0.27, native.newFont("NanumSquareB.ttf"), 25, "center" )
		bg_content[12]:setFillColor(0)

		bg_content[13] = widget.newButton(
		{
			width = 80,
			height = 134,
			x = bg_content[10].x + _W*0.133,
			y = _H*0.4,
			defaultFile = "image/button_mirror_c.png",
			overFile = "image/button_mirror_c_s.png",
			onRelease = function()
				if userData.getData("money") >= 50000 then
					userData.setData("money", userData.getData("money") - 50000 )
					userData.setData("mirror", userData.getData("mirror") + 1 )
					userData.setData("beauty", userData.getData("beauty") + 1 )
					refresh()
				else
					am.alertMessage("돈이 부족합니다.")
				end
			end
		})

		bg_content[14] = display.newText( "거울", bg_content[13].x + _W*0.01, bg_content[13].y + _H*0.22, native.newFont("NanumSquareB.ttf"), 30, "center" )
		bg_content[14]:setFillColor(0)

		bg_content[15] = display.newText( "50000원", bg_content[13].x + _W*0.01, bg_content[13].y + _H*0.27, native.newFont("NanumSquareB.ttf"), 25, "center" )
		bg_content[15]:setFillColor(0)


		bg_content[16] = widget.newButton(
		{
			width = 99.6,
			height = 108,
			x = bg_content[13].x + _W*0.133,
			y = _H*0.4,
			defaultFile = "image/button_book_c.png",
			overFile = "image/button_book_c_s.png",
			onRelease = function()
				if userData.getData("money") >= 30000 then
					userData.setData("money", userData.getData("money") - 30000 )
					userData.setData("book", userData.getData("book") + 1 )
					userData.setData("int", userData.getData("int") + 1 )
					refresh()
				else
					am.alertMessage("돈이 부족합니다.")
				end
			end
		})

		bg_content[17] = display.newText( "책", bg_content[16].x + _W*0.01, bg_content[16].y + _H*0.22, native.newFont("NanumSquareB.ttf"), 30, "center" )
		bg_content[17]:setFillColor(0)

		bg_content[18] = display.newText( "30000원", bg_content[16].x + _W*0.01, bg_content[16].y + _H*0.27, native.newFont("NanumSquareB.ttf"), 25, "center" )
		bg_content[18]:setFillColor(0)


		bg_content[19] = widget.newButton(
		{
			width = 127,
			height = 105,
			x = _W*0.93,
			y = _H*0.22,
			defaultFile = "image/button_back.png",
			overFile = "image/button_backo.png",
			onRelease = function() removeContent() createActivity(1) end
		})

	end
end

function createStatusbar()
	statusBar = display.newImage( "image/bg_statusbar.png" )
	statusBar.anchorX, statusBar.anchorY = 0, 0

	button_myInfo = widget.newButton(
	{
	    width = 97,
	    height = 96,
	    left = _W*0.81,
	    top = _H*0.005,
	    defaultFile = "image/button_myinf.png",
	    overFile = "image/button_myinfo.png",
	    onRelease = function() showPop(-1) end
	})
	button_myInfo:scale(0.8, 0.8)


	button_bag = widget.newButton(
	{
	    width = 97,
	    height = 96,
	    left = _W*0.9,
	    top = _H*0.005,
	    defaultFile = "image/button_bag.png",
	    overFile = "image/button_bago.png",
	    onRelease = function() showPop(-2) end
	})
	button_bag:scale(0.8, 0.8)

	statusBar_content = {}

	-- money
	statusBar_content[1] = display.newText( userData.getData("money"), _W*0.125, _H*0.065, native.newFont( "NanumSquareB.ttf" ), 23 )

	-- hp
	statusBar_content[2] = display.newText( userData.getData("hp"), _W*0.293, _H*0.0685, native.newFont( "NanumSquareB.ttf" ), 23 )

	-- weight
	statusBar_content[3] = display.newText( userData.getData("weight"), _W*0.387, _H*0.0685, native.newFont( "NanumSquareB.ttf" ), 23 )

	-- attack
	statusBar_content[4] = display.newText( userData.getData("attack"), _W*0.499, _H*0.0685, native.newFont( "NanumSquareB.ttf" ), 23 )

	-- int
	statusBar_content[5] = display.newText( userData.getData("int"), _W*0.592, _H*0.0685, native.newFont( "NanumSquareB.ttf" ), 23 )

	-- beauty
	statusBar_content[6] = display.newText( userData.getData("beauty"), _W*0.687, _H*0.0685, native.newFont( "NanumSquareB.ttf" ), 23 )

	-- luck
	statusBar_content[7] = display.newText( userData.getData("luck"), _W*0.763, _H*0.0685, native.newFont( "NanumSquareB.ttf" ), 23 )
end

function refresh()
	statusBar_content[1].text = userData.getData("money")
	statusBar_content[2].text = userData.getData("hp")
	statusBar_content[3].text = userData.getData("weight")
	statusBar_content[4].text = userData.getData("attack")
	statusBar_content[5].text = userData.getData("int")
	statusBar_content[6].text = userData.getData("beauty")
	statusBar_content[7].text = userData.getData("luck")
end
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	-- create & group & addEventListener
end

-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		playBGM()
		createStatusbar()
		createActivity(10)
		--createActivity(13)
	end
end

-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

		-- stop audio

	end
end

-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

	-- audio.dipose( musicTrack )

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
