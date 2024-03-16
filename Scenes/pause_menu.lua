-----------------------------------------
-- Pause Menu
-----------------------------------------
--libraries
local composer = require( "composer" )
local scene = composer.newScene()
--functions
local function onResume()
	composer.hideOverlay()
end

function scene:create( event )
	local sceneGroup = self.view 

	local uiGroup = display.newGroup()
	sceneGroup:insert( uiGroup )

	local mainGroup = display.newGroup()
	sceneGroup:insert( mainGroup )

	board = display.newImageRect( mainGroup, "Assets/Background/win.png", 600, 315 )
	board.x = display.contentCenterX
	board.y = display.contentCenterY + 5

	local exitButton = display.newImageRect( uiGroup, "Assets/Buttons/exit.png", 50, 25 )
	exitButton.x = 545
	exitButton.y = 16

	exitButton:addEventListener( "tap", onResume )
end
function scene:show( event )
	local sceneGroup = self.view 
	local phase = event.phase

	if( phase == "will" )then
	elseif( phase == "did" )then
	end
end
function scene:hide( event )
	local sceneGroup = self.view 
	local phase = event.phase
	local parent = event.parent

	if( phase == "will" )then
	elseif( phase == "did" )then
	end
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
return scene