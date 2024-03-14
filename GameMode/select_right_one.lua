-----------------------------------------
-- Select
-----------------------------------------
local composer = require( "composer" )
local scene = composer.newScene()
--initializing variables
local background
local backButton
--buttons events
local function createGraphicElement( group, objectName, scaleX, scaleY, source, x, y )
	local object = objectName
	local scaleX = scaleX
	local scaleY = scaleY
	local x = x 
	local y = y

	object = display.newImageRect( group, source, scaleX, scaleY )
	object.x = x
	object.y = y
end
local function gotoPlayMenu()
	composer.gotoScene( "Scenes.play_menu", { time=500, effect="slideRight" } )
end
-----------------------------------------
-- Scene
-----------------------------------------
function scene:create( event )
	local sceneGroup = self.view

	createGraphicElement( sceneGroup, background, 700, 375, "Assets/Background/select_right_one.png", display.contentCenterX, display.contentCenterY - 25 )

	backButton = display.newImageRect( sceneGroup, "Assets/Buttons/back.png", 50, 25 )
	backButton.x = 0
	backButton.y = 16

	backButton:addEventListener( "tap", gotoPlayMenu )
end
function scene:hide( event )
	local sceneGoup = self.view
	local phase = event.phase

	if( phase == "will")then
	elseif( phase == "did" )then
		backButton:removeEventListener( "tap", gotoPlayMenu )
		composer.removeScene( "GameMode.select_right_one" ) 
	end
end
scene:addEventListener( "create", scene )
scene:addEventListener( "hide", scene )
return scene