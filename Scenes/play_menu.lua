-----------------------------------------
-- Play Menu
-----------------------------------------
local composer = require( "composer" )
local scene = composer.newScene()
--init variables
local background
local backButton
local option1
local option2
local option3
--button control functions
local function gotoMenu()
	composer.gotoScene( "Scenes.main_menu", { time=500, effect="slideRight" } )
end

local function gotoFree()
	composer.gotoScene( "GameMode.free", { time=500, effect="slideLeft" } )
end

local function gotoSelect()
	composer.gotoScene( "GameMode.select_right_one", { time=500, effect="slideLeft" } )
end

local function gotoCategorize()
	composer.gotoScene( "GameMode.categorize", { time=500, effect="slideLeft" } )
end
-----------------------------------------
-- Scene
-----------------------------------------
function scene:create( event )
	local sceneGroup = self.view

	background = display.newImageRect( sceneGroup, "Assets/Background/play.png", display.actualContentWidth, display.actualContentHeight )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	option1 = display.newImageRect( sceneGroup, "Assets/Buttons/libre.png", 100, 125 )
	option1.x = 120
	option1.y = 100

	option2 = display.newImageRect( sceneGroup, "Assets/Buttons/categorizar.png", 100, 125 )
	option2.x = 360
	option2.y = 113

	option3 = display.newImageRect( sceneGroup, "Assets/Buttons/seleccion.png", 175, 100 )
	option3.x = display.contentCenterX
	option3.y = 225
	
	backButton = display.newImageRect( sceneGroup, "Assets/Buttons/back.png", 50, 25 )
	backButton.x = 0
	backButton.y = 16

	option1:addEventListener( "tap", gotoFree )
	option2:addEventListener( "tap", gotoCategorize )
	option3:addEventListener( "tap", gotoSelect )
	backButton:addEventListener( "tap", gotoMenu )
end
scene:addEventListener( "create", scene )
return scene 