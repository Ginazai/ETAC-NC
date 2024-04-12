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
--sound handling (currently there's no need to create a soud table. might need if more resources are added)
local chalkSound = audio.loadSound( "Audio/chalk-tap.mp3" )
local chalkButton = nil
local blocksSound = audio.loadSound( "Audio/blocks-falling.mp3" )
local blocksPlay = nil

--button control functions
local function gotoMenu()
	chalkButton = audio.play( chalkSound )
	composer.gotoScene( "Scenes.main_menu", { time=700, effect="slideRight" } )
end

local function gotoFree()
	chalkButton = audio.play( chalkSound )
	local free_options = {
		time=700, 
		effect="slideLeft"
	}
	composer.gotoScene( "GameMode.free_es", free_options )
end

local function gotoSelect()
	chalkButton = audio.play( chalkSound )
	composer.gotoScene( "GameMode.select_right_one", { time=700, effect="slideLeft" } )
end

local function gotoCategorize()
	blocksPlay = audio.play( blocksSound )
	composer.gotoScene( "GameMode.categorize_es", { time=700, effect="slideLeft" } )
end
-----------------------------------------
-- Scene
-----------------------------------------
function scene:create( event )
	local sceneGroup = self.view

	background = display.newImageRect( sceneGroup, "Assets/Background/play.png", display.actualContentWidth, display.actualContentHeight )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	local textBox = display.newImageRect( sceneGroup, "Assets/Background/text-box.png", 275, 100 )
	textBox.x = display.contentCenterX
	textBox.y = 60

	local textCategory = display.newText( sceneGroup, "Modo de Juego", display.contentCenterX, 65, "Fonts/FORTE.TTF", 30 )
	textCategory.font = native.newFont( "Fonts.FORTE", 16 )
	textCategory:setTextColor( 1, 0.85, 0.31 )

	local firstBoard = display.newImageRect( sceneGroup, "Assets/Background/board-2.png", 240, 140 )
	firstBoard.x = display.contentCenterX - 105
	firstBoard.y = display.contentCenterY + 40

	local secondBoard = display.newImageRect( sceneGroup, "Assets/Background/board-2.png", 240, 140 )
	secondBoard.x = display.contentCenterX + 105
	secondBoard.y = display.contentCenterY + 40

	option1 = display.newImageRect( sceneGroup, "Assets/Buttons/libre.png", 130, 95 )
	option1.x = 135
	option1.y = display.contentCenterY + 45

	local textFree = display.newText( sceneGroup, "Libre", 135, 285, "Fonts/FORTE.TTF", 25 )
	textFree.font = native.newFont( "Fonts.FORTE", 16 )
	textFree:setTextColor( 0.35, 0.27, 0.46 )

	option2 = display.newImageRect( sceneGroup, "Assets/Buttons/categorizar.png", 130, 95 )
	option2.x = 345
	option2.y = display.contentCenterY + 45

	local textCat = display.newText( sceneGroup, "Categorizar", 345, 285, "Fonts/FORTE.TTF", 25 )
	textCat.font = native.newFont( "Fonts.FORTE", 16 )
	textCat:setTextColor( 0.35, 0.27, 0.46 )
	
	backButton = display.newImageRect( sceneGroup, "Assets/Buttons/back.png", 50, 25 )
	backButton.x = 0
	backButton.y = 16

	option1:addEventListener( "tap", gotoFree )
	option2:addEventListener( "tap", gotoCategorize )
	backButton:addEventListener( "tap", gotoMenu )
end
function scene:show( event )
	local phase = event.phase

	if( phase == "will" )then
	elseif( phase == "did" )then
		 activeVoice("Audio/voice/ES/modo_juego.mp3")
	end
end
function scene:hide( event )
	local phase = event.phase

	if( phase == "will" )then
	elseif( phase == "did" )then
		if (chalkButton ~= nil)then audio.stop( chalkButton ) end
		if (blocksPlay ~= nil)then audio.stop( blocksPlay ) end
		chalkButton = nil
		blocksPlay = nil
		composer.removeScene("Scenes.play_menu_es")
	end
end
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
return scene 