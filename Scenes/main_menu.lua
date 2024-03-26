-----------------------------------------
-- Main Menu
-----------------------------------------
local composer = require( "composer" )
local scene = composer.newScene()
--initializing variables
local background
local board
local logo
local playButton
local scoreButton
--sounds
local backgroundOptions = 
{
	loops = -1,
	onComplete = callbackListener
}
local backgroundSound = audio.loadSound( "Audio/background.mp3" )
audio.play( backgroundSound, backgroundOptions )

local chalkSound = audio.loadSound( "Audio/chalk-tap.mp3" )
local chalkButton = nil
--buttons events
local function gotoPlay()
	chalkButton = audio.play( chalkSound )
	composer.gotoScene( "Scenes.play_menu", { time=700, effect="slideLeft" } )
end
local function gotoScore()
	chalkButton = audio.play( chalkSound )
	composer.gotoScene( "Scenes.scores", { time=700, effect="slideUp" } )
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

	logo = display.newImageRect( sceneGroup, "Assets/Background/logo.png", 229, 65 )
	logo.x = display.contentCenterX
	logo.y = 110

	playButton = display.newImageRect( sceneGroup, "Assets/Buttons/start.png",  130, 60 ) 
	playButton.x = display.contentCenterX
	playButton.y = 190

	scoreButton = display.newImageRect( sceneGroup, "Assets/Buttons/score.png", 90, 45 ) 
	scoreButton.x = display.contentCenterX
	scoreButton.y = 255

	playButton:addEventListener( "tap", gotoPlay )
	scoreButton:addEventListener( "tap", gotoScore )
end
--hide()
function scene:hide( event )
	local phase = event.phase

	if( phase == "will" )then
	elseif( phase == "did" )then
		if (chalkButton ~= nil)then audio.stop( chalkButton ) end
		chalkButton = nil
	end
end
scene:addEventListener( "create", scene )
scene:addEventListener( "hide", scene )
return scene