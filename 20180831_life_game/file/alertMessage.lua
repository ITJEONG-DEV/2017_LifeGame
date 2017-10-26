local M = {}

function M.alertMessage(text, speed)
	---speed
	-- s : slow
	-- f : fast
	local createMessageBox, deleteMessageBox, start

	local messageBox, messageText

	function createMessageBox()
		messageBox = display.newRoundedRect( display.contentWidth*0.5, display.contentHeight*0.5, display.contentWidth*0.7, display.contentHeight*0.1, display.contentHeight*0.03 )
		messageBox:setFillColor( 0 )
		messageBox.alpha = 0

		messageText = display.newText( text, display.contentWidth*0.5, display.contentHeight*0.5, native.newFont("NanumSquareB.ttf"), 30 )
		messageText.alpha = 0

		transition.to( messageBox, { time = 400, alpha = 0.7, transition = easing.outSine } )
		transition.to( messageText, { time = 400, alpha = 1.0, transition = easing.outSine } )

		transition.to( messageBox, { delay = 700, time = 350, alpha = 0, trnasition = easing.inSine } )
		transition.to( messageText, { delay = 700, time = 350, alpha = 0, transition = easing.inSine, onComplete = deleteMessageBox } )
	end

	function deleteMessageBox()
		messageBox:removeSelf()
		messageText:removeSelf()

		messageBox = nil
		messageText = nil
	end

	function start()
		createMessageBox()
	end

	start()
end


return M