local M = {}
local widget = require "widget"
local _W, _H = display.contentWidth, display.contentHeight

local path = system.pathForFile( "userData.txt", system.DocumentsDirectory )

local statusBar, statusBar_content
local pop, pop_bg, pop_button, pop_content, pop_type -- 1 : myInfo / 2 : bag
local button_bag, button_myInfo

-- money hp maxHP weight attack int beauty luck
-- mirror book drink snack lamen steak
local userData =
{
	["money"] = 20000,
	["hp"] = 100,
	["maxHP"] = 100,
	["weight"] = 70,
	["attack"] = 0,
	["int"] = 0,
	["beauty"] = 0,
	["luck"] = 0,
	["mirror"] = 0,
	["book"] = 0,
	["drink"] = 0,
	["ramen"] = 0,
	["drink"] = 0,
	["snack"] = 0,
	["steak"] = 0,
	["type"] = 1,
	["name"] = "길동이",
	["state"] = 1
}

function showPop()
	local basicTop = _H*0.3875
	-- set button false
	button_bag:setEnabled( false )
	button_myInfo:setEnabled( false )

	-- create pop
	pop_bg = display.newRect( 0, 97, _W, _H-97 )
	pop_bg.anchorX, pop_bg.anchorY = 0, 0
	pop_bg:setFillColor( 1, 1, 1, 0.5 )
	pop = display.newImage("image/popup.png", _W*0.5, _H*0.5 )
	pop:scale(0.7, 0.7)

	pop_button = widget.newButton(
	{
		width = 43,
		height = 43,
		top = _H*0.3,
		left = pop.x + pop.contentWidth*0.5 - 45,
		top = pop.y - pop.contentHeight*0.5 + 2,
		defaultFile = "image/popup_button.png",
		overFile = "image/popup_button.png",
		onRelease = closePop
	})
	--print(pop.anchorX + pop.contentWidth*0.5 - 43)

	pop_content = {}

	if pop_type == 1 then --myInfo
		pop_content[1] = display.newText( "내 정보", _W*0.5, _H*0.25, native.newFont( "NanumSquareB.ttf" ), 30 )
		pop_content[1]:setFillColor( 0 )

		-- name
		pop_content[2] = display.newText( "이름", _W*0.275, basicTop, native.newFont("NanumSquareB.ttf"), 25 )
		pop_content[2]:setFillColor( 0 )
		pop_content[3] = display.newText( userData.name, _W*0.4, basicTop, native.newFont("NanumSquareB.ttf"), 25 )
		pop_content[3]:setFillColor( 0 )

		-- state
		pop_content[4] = display.newText( "상태", _W*0.6, basicTop, native.newFont("NanumSquareB.ttf"), 25 )
		pop_content[4]:setFillColor( 0 )
		pop_content[5] = display.newText( ( userData.hp <= 15 ) and "저체력" or ( ( userData.weight <= 40 ) and "저체중" or "정상" ), _W*0.7, basicTop, native.newFont("NanumSquareB.ttf"), 25 )
		pop_content[5]:setFillColor( 0 )


		-- hp/maxHP
		pop_content[2] = display.newText( "현재 체력", _W*0.275, basicTop+_H*0.1, native.newFont("NanumSquareB.ttf"), 25 )
		pop_content[2]:setFillColor( 0 )
		pop_content[3] = display.newText( userData.hp.."/"..userData.maxHP, _W*0.4, basicTop+_H*0.1, native.newFont("NanumSquareB.ttf"), 25 )
		pop_content[3]:setFillColor( 0 )

		-- weight
		pop_content[4] = display.newText( "현재 체중", _W*0.6, basicTop+_H*0.1, native.newFont("NanumSquareB.ttf"), 25 )
		pop_content[4]:setFillColor( 0 )
		pop_content[5] = display.newText( userData.weight, _W*0.7, basicTop+_H*0.1, native.newFont("NanumSquareB.ttf"), 25 )
		pop_content[5]:setFillColor( 0 )


		-- attack
		pop_content[2] = display.newText( "현재 공격력", _W*0.275, basicTop+_H*0.2, native.newFont("NanumSquareB.ttf"), 25 )
		pop_content[2]:setFillColor( 0 )
		pop_content[3] = display.newText( userData.attack, _W*0.4, basicTop+_H*0.2, native.newFont("NanumSquareB.ttf"), 25 )
		pop_content[3]:setFillColor( 0 )

		-- int
		pop_content[4] = display.newText( "현재 지능", _W*0.6, basicTop+_H*0.2, native.newFont("NanumSquareB.ttf"), 25 )
		pop_content[4]:setFillColor( 0 )
		pop_content[5] = display.newText( userData.int, _W*0.7, basicTop+_H*0.2, native.newFont("NanumSquareB.ttf"), 25 )
		pop_content[5]:setFillColor( 0 )


		-- beauty
		pop_content[2] = display.newText( "현재 매력", _W*0.275, basicTop+_H*0.3, native.newFont("NanumSquareB.ttf"), 25 )
		pop_content[2]:setFillColor( 0 )
		pop_content[3] = display.newText( userData.beauty, _W*0.4, basicTop+_H*0.3, native.newFont("NanumSquareB.ttf"), 25 )
		pop_content[3]:setFillColor( 0 )

		-- luck
		pop_content[4] = display.newText( "현재 운", _W*0.6, basicTop+_H*0.3, native.newFont("NanumSquareB.ttf"), 25 )
		pop_content[4]:setFillColor( 0 )
		pop_content[5] = display.newText( userData.luck, _W*0.7, basicTop+_H*0.3, native.newFont("NanumSquareB.ttf"), 25 )
		pop_content[5]:setFillColor( 0 )

	elseif pop_type == 2 then --myBag
		-- beef
		pop_content[1] = display.newImageRect( userData.steak == 0 and "image/button_beef.png" or "image/button_beef_c.png" , 100, 100 )
		pop_content[1].x, pop_content[1].y = _W*0.23, _H*0.3

		pop_content[2] = display.newText( userData.steak.."개", pop_content[1].x, pop_content[1].y + 90, native.newFont( "NanumSquareB.ttf" ), 25 )
		pop_content[2]:setFillColor( 0 )

		-- drink
		pop_content[3] = display.newImageRect(  userData.drink == 0 and "image/button_drink.png" or "image/button_drink_c.png " , 60, 100 )
		pop_content[3].x, pop_content[3].y = _W*0.47, _H*0.3

		pop_content[4] = display.newText( userData.drink.."개", pop_content[3].x, pop_content[3].y + 90, native.newFont( "NanumSquareB.ttf" ), 25 )
		pop_content[4]:setFillColor( 0 )

		-- ramen
		pop_content[5] = display.newImageRect( userData.ramen == 0 and "image/button_ramen_b.png" or "image/button_ramen.png", 100, 100 )
		pop_content[5].x, pop_content[5].y = _W*0.35, _H*0.3

		pop_content[6] = display.newText( userData.ramen.."개", pop_content[5].x, pop_content[5].y + 90, native.newFont( "NanumSquareB.ttf" ), 25 )
		pop_content[6]:setFillColor( 0 )

		-- snack
		pop_content[7] = display.newImageRect( userData.snack == 0 and "image/button_snack.png" or "image/button_snack_c.png", 95, 100 )
		pop_content[7].x, pop_content[7].y = _W*0.575, _H*0.3

		pop_content[8] = display.newText( userData.snack.."개", pop_content[7].x, pop_content[7].y + 90, native.newFont( "NanumSquareB.ttf" ), 25 )
		pop_content[8]:setFillColor( 0 )

		-- mirror
		pop_content[9] = display.newImageRect( userData.mirror == 0 and "image/button_mirror.png" or "image/button_mirror_c.png", 75, 100 )
		pop_content[9].x, pop_content[9].y = _W*0.23, _H*0.63

		pop_content[10] = display.newText( userData.mirror.."개", pop_content[9].x, pop_content[9].y + 90, native.newFont( "NanumSquareB.ttf" ), 25 )
		pop_content[10]:setFillColor( 0 )

		-- book
		pop_content[11] = display.newImageRect( userData.book == 0 and "image/button_book.png" or "image/button_book_c.png", 100, 100 )
		pop_content[11].x, pop_content[11].y = _W*0.34, _H*0.63

		pop_content[12] = display.newText( userData.book.."개", pop_content[11].x, pop_content[11].y + 90, native.newFont( "NanumSquareB.ttf" ), 25 )
		pop_content[12]:setFillColor( 0 )


	end
end

function closePop()
	-- set button true
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

function createUI()
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
	    onRelease = function() pop_type = 1 showPop() end
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
	    onRelease = function() pop_type = 2 showPop() end
	})
	button_bag:scale(0.8, 0.8)

	statusBar_content = {}

	-- money
	statusBar_content[1] = display.newText( userData.money, _W*0.125, _H*0.065, native.newFont( "NanumSquareB.ttf" ), 23 )
	
	-- hp
	statusBar_content[2] = display.newText( userData.hp, _W*0.293, _H*0.0685, native.newFont( "NanumSquareB.ttf" ), 23 )

	-- weight
	statusBar_content[3] = display.newText( userData.weight, _W*0.387, _H*0.0685, native.newFont( "NanumSquareB.ttf" ), 23 )

	-- attack
	statusBar_content[4] = display.newText( userData.attack, _W*0.499, _H*0.0685, native.newFont( "NanumSquareB.ttf" ), 23 )

	-- int
	statusBar_content[5] = display.newText( userData.int, _W*0.592, _H*0.0685, native.newFont( "NanumSquareB.ttf" ), 23 )

	-- beauty
	statusBar_content[6] = display.newText( userData.beauty, _W*0.687, _H*0.0685, native.newFont( "NanumSquareB.ttf" ), 23 )

	-- luck
	statusBar_content[7] = display.newText( userData.luck, _W*0.763, _H*0.0685, native.newFont( "NanumSquareB.ttf" ), 23 )

end

function M.loadData()
	local file, errorString = io.open( path "r" )

	if not file then
	else
		local decoded, pos, msg = json.decodeFile( path )

		if not decoded then
		else
			userData.money = decoded.money
			userData.hp = decoded.hp
			userData.maxHP = decoded.maxHP
			userData.weight = decoded.weight
			userData.attack = decoded.attack
			userData.int = decoded.int
			userData.beauty = decoded.beauty
			userData.luck = decoded.luck
			userData.mirror = decoded.mirror
			userData.book = decoded.book
			userData.drink = decoded.drink
			userData.ramen = decoded.ramen
			userData.steak = decoded.steak
			userData.name = decoded.name
			userData.state = userData.state
		end
	end
end

function M.saveData()
	local encoded = json.encode( userData )

	local file, errorString = io.open( path, "w" )

	if not file then
	else
		file:write( encoded )

		io.close( file )
		print("Save Data Successful.");
	end

	file = nil
end

function M.init()
	createUI()
end


return M