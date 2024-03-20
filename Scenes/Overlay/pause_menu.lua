-----------------------------------------
-- Pause Menu
-----------------------------------------
--libraries
local composer = require( "composer" )
local scene = composer.newScene()
--Sounds
local chalkSound = audio.loadSound( "Audio/chalk-tap.mp3" ) --back button chalk sound
local playChalk = nil
--functions
local function gotoMenu()
	playChalk = audio.play( chalkSound )
	composer.gotoScene( "Scenes.play_menu", { time=100, effect="slideUp" } ) 
end
local function onResume()
	playChalk = audio.play( chalkSound )
	composer.hideOverlay( "slideUp", 175 )
end
-----------------------------------------
-- Scenes
-----------------------------------------
function scene:create( event )
	local sceneGroup = self.view 

	local mainGroup = display.newGroup()
	sceneGroup:insert( mainGroup )

	local uiGroup = display.newGroup()
	sceneGroup:insert( uiGroup )

	local background = display.newImageRect( mainGroup, "Assets/Background/pause.jpg", 700, 375 ) --background
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	local pauseText = display.newImageRect( uiGroup, "Assets/Background/pause-font.png", 325, 100 ) --pause question
	pauseText.x = display.contentCenterX
	pauseText.y = 100

	local option1 = display.newImageRect( uiGroup, "Assets/Background/pause-option-1.png", 50, 29 ) --yes
	option1.x = display.contentCenterX
	option1.y = 190

	local option2 = display.newImageRect( uiGroup, "Assets/Background/pause-option-2.png", 50, 29 ) --no
	option2.x = display.contentCenterX
	option2.y = 240

	option1:addEventListener( "tap", gotoMenu )
	option2:addEventListener( "tap", onResume )
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