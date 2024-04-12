-----------------------------------------
-- Main Menu
-----------------------------------------
local composer = require( "composer" )
local scene = composer.newScene()

langScene = nil
langScene2 = nil
--initializing variables
local background
local board
local logo
local playButton
local scoreButton

local chalkSound = audio.loadSound( "Audio/chalk-tap.mp3" )
local chalkButton = nil
--buttons events
local function showMenu()
	composer.showOverlay("Scenes.Overlay.menu")
end
local function langHandle()
	print( lang )
	if( lang == "ES" )then
		langScene = "Scenes.play_menu_es"
		langScene2 = "Scenes.scores_es"
	elseif( lang == "EN" )then
		langScene = "Scenes.play_menu"
		langScene2 = "Scenes.scores"
	else
		langScene = "Scenes.play_menu"
		langScene2 = "Scenes.scores"
	end
end
local function gotoPlay()
	chalkButton = audio.play( chalkSound )
	local play_options = {
		time=700, 
		effect="slideLeft"
	}
	composer.gotoScene( langScene, play_options )
end
local function gotoScore()
	chalkButton = audio.play( chalkSound )
	composer.gotoScene( langScene2, { time=700, effect="slideUp" } )
end
-----------------------------------------
-- Scene
-----------------------------------------
function scene:create( event )
	local sceneGroup = self.view
	langHandle()
	-- local permissionOptions = {
	-- 	appPermission = "Storage",
	-- 	urgency = "Critical",
	-- 	rationaleTitle = "Storage permission required"
	-- }
	-- native.showPopup( "requestAppPermission", permissionOptions )

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

	local menuButton = display.newImageRect( sceneGroup, "Assets/Buttons/menu.png", 80, 40 )
	menuButton.x = 545
	menuButton.y = 25

	menuButton:addEventListener( "tap", showMenu )
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
		composer.removeScene("Scenes.main_menu")
	end
end
scene:addEventListener( "create", scene )
scene:addEventListener( "hide", scene )
return scene