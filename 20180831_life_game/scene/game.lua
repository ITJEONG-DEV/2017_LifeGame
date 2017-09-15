local composer = require( "composer" )
local widget = require "widget"
local stBar = require "scene.statusBar"

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

local bg, bg_content
local bg_height = 720 - 96
local pop, pop_content, pop_button

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

-- 0X : pop-up
-- 00 : bus-stop
-- 01 : sink
-- 02 : book
-- 03 : notebook

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
		if bg_content[i].isEnabled then
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
	--print(pop.anchorX + pop.contentWidth*0.5 - 43)

	pop_content = {}

	-- sink
	if popNum == 1 then
		-- steak
		pop_content[1] = display.newImage( stBar.getData("steak") == 0 and "image/button_beef.png" or "image/button_beef_c.png" )
		pop_content[1].x, pop_content[1].y = _W*0.3, _H*0.42
		pop_content[2] = display.newText( "남은 개수 : "..stBar.getData("steak").."개", pop_content[1].x, pop_content[1].y + 140, native.newFont( "NanumSquareB.ttf"), 25 )
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
				if stBar.getData("steak") > 0 then
					stBar.setData( "steak", stBar.getData("steak") - 1 )
					stBar.setData( "hp", stBar.getData("hp") + 50 < stBar.getData("maxHP") and stBar.getData("hp") + 50 or stBar.getData("maxHP") )
					stBar.setData( "weight", stBar.getData("weight") + 5 )
					stBar.refresh()
					pop_content[2].text = "남은 개수 : "..stBar.getData("steak").."개"

					if stBar.getData("steak") == 0 then
						pop_content[1]:removeSelf( )
						pop_content[1] = display.newImage( "image/button_beef.png" )
						pop_content[1].x, pop_content[1].y = _W*0.3, _H*0.375
					end
				end
			end
		})


		-- ramen
		pop_content[4] = display.newImage( stBar.getData("ramen") == 0 and "image/button_ramen_b.png" or "image/button_ramen.png" )
		pop_content[4].x, pop_content[4].y = _W*0.5, _H*0.42
		pop_content[5] = display.newText( "남은 개수 : "..stBar.getData("ramen").."개", pop_content[4].x, pop_content[4].y + 140, native.newFont( "NanumSquareB.ttf"), 25 )
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
				if stBar.getData("ramen") > 0 then
					stBar.setData( "ramen", stBar.getData("ramen") - 1 )
					stBar.setData( "hp", stBar.getData("hp") + 15 < stBar.getData("maxHP") and stBar.getData("hp") + 15 or stBar.getData("maxHP") )
					stBar.setData( "weight", stBar.getData("weight") + 2 )
					stBar.refresh()
					pop_content[5].text = "남은 개수 : "..stBar.getData("ramen").."개"

					if stBar.getData("ramen") == 0 then
						pop_content[4]:removeSelf()
						pop_content[4] = display.newImage( "image/button_ramen_b.png" )
						pop_content[4].x, pop_content[4].y = _W*0.5, _H*0.375
					end
				end
			end
		})

		-- snack
		pop_content[7] = display.newImage( stBar.getData("snack") == 0 and "image/button_snack.png" or "image/button_snack_c.png" )
		pop_content[7].x, pop_content[7].y = _W*0.7, _H*0.42
		pop_content[7]:scale(1.5,1.5)
		pop_content[8] = display.newText( "남은 개수 : "..stBar.getData("snack").."개", pop_content[7].x, pop_content[7].y + 140, native.newFont( "NanumSquareB.ttf"), 25 )
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
				if stBar.getData("snack") > 0 then
					stBar.setData( "snack", stBar.getData("snack") - 1 )
					stBar.setData( "hp", stBar.getData("hp") + 7 < stBar.getData("maxHP") and stBar.getData("hp") + 7 or stBar.getData("maxHP") )
					stBar.setData( "weight", stBar.getData("weight") + 0.5 )
					stBar.refresh()
					pop_content[8].text = "남은 개수 : "..stBar.getData("snack").."개"

					if stBar.getData("snack") == 0 then
						pop_content[7]:removeSelf( )
						pop_content[7] = display.newImage( "image/button_snack.png" )
						pop_content[7].x, pop_content[7].y = _W*0.7, _H*0.375
						pop_content[7]:scale(1.5,1.5)
					end
				end
			end
		})
	else
	end
end

function closePop()
	-- set button true
	for i = 1, table.maxn(bg_content), 1 do
		if bg_content[i].isEnabled then
			bg_content[i]:setEnabled(true)
		end
	end

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
	if place < 10 then
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
				onRelease = function()
				end
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
			end
		})
	elseif place == 10 then
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
	elseif place == 11 then
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
	elseif place == 12 then
	elseif place == 13 then

	end
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

		-- music?
		stBar.init()		
		createActivity(1)
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
