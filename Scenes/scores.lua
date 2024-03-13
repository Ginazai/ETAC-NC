-----------------------------------------
-- Scores
-----------------------------------------
local composer = require( "composer" )
local scene = composer.newScene()
--init varibales 
local background
local board
local backButton
--button control
local function gotoMenu()
	composer.gotoScene( "Scenes.main_menu", { time=500, effect="slideRight" } )
end
-----------------------------------------
-- Scene
-----------------------------------------
function scene:create( event )
	local sceneGroup = self.view

	background = display.newImageRect( sceneGroup, "Assets/Background/main.png", 900, 520 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	board = display.newImageRect( sceneGroup, "Assets/Background/board.png", 600, 315 )
	board.x = display.contentCenterX
	board.y = display.contentCenterY + 5

	backButton = display.newImageRect( sceneGroup, "Assets/Buttons/back.png", 50, 25 )
	backButton.x = 0
	backButton.y = 20

	backButton:addEventListener( "tap", gotoMenu )
end
scene:addEventListener( "create", scene )
return scene