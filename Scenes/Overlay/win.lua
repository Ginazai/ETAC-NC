-----------------------------------------
-- Victory Overlay
-----------------------------------------
--libraries
local json = require( "json" )
local composer = require( "composer" )
local scene = composer.newScene()
--functions
local function onExit()
	composer.gotoScene( "Scenes.play_menu" )
end
local function onContinue()
	composer.hideOverlay()
end
-----------------------------------------
-- Scenes
-----------------------------------------
function scene:create( event )
	local sceneGroup = self.view 
	local selectedBackground = event.params.background

	local mainGroup = display.newGroup()
	sceneGroup:insert( mainGroup )

	local uiGroup = display.newGroup()
	sceneGroup:insert( uiGroup )

	local background = display.newImageRect( mainGroup, selectedBackground, 700, 375 ) --background
	--applying blur to background
	background.fill.effect = 'filter.blurGaussian'
	background.fill.effect.horizontal.blurSize = 10
	background.fill.effect.horizontal.sigma = 150
	background.fill.effect.vertical.blurSize = 10
	background.fill.effect.vertical.sigma = 150
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	board = display.newImageRect( mainGroup, "Assets/Background/win.png", 600, 315 )
	board.x = display.contentCenterX
	board.y = display.contentCenterY

	prize = display.newImageRect( mainGroup, "Assets/Background/prize.png", 580, 315 )
	prize.x = display.contentCenterX
	prize.y = display.contentCenterY 

	-- local exitButton = display.newImageRect( uiGroup, "Assets/Buttons/exit.png", 50, 25 )
	-- exitButton.x = 0
	-- exitButton.y = 16

	backButton = display.newImageRect( uiGroup, "Assets/Buttons/back.png", 50, 25 ) --go back button
	backButton.x = 0
	backButton.y = 16

	local continueButton = display.newImageRect( uiGroup, "Assets/Buttons/continue.png", 50, 25 ) --go back button
	continueButton.x = 500
	continueButton.y = 300

	backButton:addEventListener( "tap", onExit )
	continueButton:addEventListener( "tap", onContinue )
end
function scene:show( event )
	local sceneGroup = self.view 
	local phase = event.phase
	local parent  = event.parent

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