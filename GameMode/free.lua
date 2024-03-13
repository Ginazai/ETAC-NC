-----------------------------------------
-- Free
-----------------------------------------
local composer = require( "composer" )
local scene = composer.newScene()
--initializing variables
local background
local backButton
local ball
local box
local score = 0
local scoreText
local isSet = false
--setting screen boundaries (not working)
local DECLARED_SCREEN_WIDTH = display.contentWidth
local DECLARED_SCREEN_WIDTH = display.contentHeight
local TOTAL_SCREEN_WIDTH	= display.actualContentWidth
local TOTAL_SCREEN_HEIGHT   = display.actualContentHeight
local CENTER_X 		      	= display.contentCenterX
local CENTER_Y		      	= display.contentCenterY
local UNUSED_WIDTH	      	= display.actualContentWidth - display.contentWidth
local UNUSED_HEIGHT	      	= display.actualContentHeight - display.contentHeight
local LEFT		          	= display.contentCenterX - display.actualContentWidth * 0.5
local TOP	                = display.contentCenterY - display.actualContentHeight * 0.5
local RIGHT 		        = display.contentCenterX + display.actualContentWidth * 0.5
local BOTTOM 		        = display.contentCenterY + display.actualContentHeight * 0.5

local leftWall  = display.newLine ( LEFT, TOP, LEFT, BOTTOM )
local rightWall = display.newLine ( RIGHT, TOP, RIGHT, BOTTOM )
local ceiling = display.newLine ( LEFT, TOP, RIGHT, TOP )
local bottom = display.newLine ( LEFT, BOTTOM, RIGHT, BOTTOM )	
--events
local function updateText()
    scoreText.text = "Score: " .. score
end
local function gotoPlayMenu() --go back to previous screen
	composer.gotoScene( "Scenes.play_menu", { time=500, effect="slideRight" } )
end
local function onBox( event ) 		--object1 / object2 collision detector
	local phase = event.phase 		--get the event phase
	local objt1 = event.object1 	--object 1
	local objt2 = event.object2 	--object 2

	if ( (objt1.name == "box" and objt2.name == "ball") or    --set variables based in the objects 
		(objt2.name == "box" and objt1.name == "ball") ) then
		scoreText.text = "nailed (go back and then come back to do it again)"
		display.remove( objt2 )
	end
	if( phase == "ended" )then 								--check the objects colliding when the collision ends
		if ( (objt1.name ~= "box" and objt2.name ~= "ball") or 
		(objt2.name ~= "box" and objt1.name ~= "ball") ) then
			scoreText.text = "not set"
		end
	end
end
local function drag( event ) --drag: touch detector + collision detector
	local object = event.target
	local phase = event.phase

	if (phase == "began")then 					--transforming positions
		object.touchOffsetX = event.x - object.x
		object.touchOffsetY = event.y - object.y
	elseif (phase == "moved") then
		object.x = event.x - object.touchOffsetX
		object.y = event.y - object.touchOffsetY
	elseif (phase == "ended" or phase == "cancelled") then
		display.currentStage:setFocus( nil )
	end
	Runtime:addEventListener( "collision", onBox ) 	-- collision listener
	return true 									-- Prevents touch propagation to underlying objects
end
-----------------------------------------
-- Coding playground
-----------------------------------------
local backgroundSet = { "Assets/Background/kinder.png", "Assets/Background/kitchen.png", "Assets/Background/jungle.png",
"Assets/Background/living.png", "Assets/Background/bedroom.png", }
--trying to implement DB
local sqlite = require( "sqlite3" )
local path = system.pathForFile( "data.db", system.DocumentsDirectory ) --path for DB
local db = sqlite.open( path ) 											--opening DB 
local testing = [[ DROP TABLE IF EXISTS test;]] --WARNING!! Disable on production. Will drop the table on scene refresh
local createTable = [[
CREATE TABLE IF NOT EXISTS test (
id INTEGER PRIMARY KEY, 
score INTEGER);
]]
db:exec( testing ) 		--DISABLE!!
db:exec( createTable )	--executin tanle creation query
-----------------------------------------
-- Scene
-----------------------------------------
--create()
function scene:create( event )

	local sceneGroup = self.view 		--scene view

	local physics = require( "physics" ) --implementing physics
	physics.start()
	physics.setGravity( 0,0 )
	--prevent objects from going out of the screen (not working)
	physics.addBody( leftWall, 'static', { density=1.0, friction=0.3, bounce=0.2 } )
	physics.addBody( rightWall, 'static', {density=1.0, friction=0.3, bounce=0.2 } )
	physics.addBody( ceiling, 'static', { density=1.0, friction=0.3, bounce=0.2 } )
	physics.addBody( bottom, 'static', { density=1.0, friction=0.3, bounce=0.2 } )

	local backGroup = display.newGroup() -- background elements group
	sceneGroup:insert( backGroup ) 

	local mainGroup = display.newGroup() -- game objects group
	sceneGroup:insert( mainGroup ) 

	local uiGroup = display.newGroup() 	-- UI elements group
	sceneGroup:insert( uiGroup ) 

	local selectedBg = math.random( 1,5 )
	background = display.newImageRect( backGroup, backgroundSet[selectedBg], 700, 425 ) --background
	--applying blur to background
	background.fill.effect = 'filter.blurGaussian'
	background.fill.effect.horizontal.blurSize = 20
	background.fill.effect.horizontal.sigma = 175
	background.fill.effect.vertical.blurSize = 20
	background.fill.effect.vertical.sigma = 175
	
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	scoreText = display.newText( uiGroup, "", display.contentCenterX, 20, native.systemFont, 15 )
	scoreText:setFillColor( 0,0,0 )	

	box = display.newImageRect( mainGroup, "Assets/Toys/box.png", 90, 90 ) --toys box
	box.name = "box"
	local box_outline = graphics.newOutline( 3, "Assets/Toys/box.png" )
	box.x = 500
	box.y = 265
	physics.addBody( box, "static", { radius=23, outline=box_outline } ) --box physics box

	ball = display.newImageRect( mainGroup, "Assets/Toys/ball.png", 40, 40 ) --ball
	ball.name = "ball"
	ball.x = display.contentCenterX
	ball.y = display.contentCenterY
	ball:addEventListener( "touch", drag )
	physics.addBody( ball, "dynamic", { radius=50, bounce=0.3, isSensor=true } ) --adding physics to ball object


	backButton = display.newImageRect( backGroup, "Assets/Buttons/back.png", 50, 25 ) --go back button
	backButton.x = 0
	backButton.y = 16

	backButton:addEventListener( "tap", gotoPlayMenu )
end
--hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if (phase == "will") then
	elseif (phase == "did") then
		physics.stop() -- stopping physics when scene stops
		--inserting into DB
		local insertToDb = [[
		INSERT INTO test VALUES ( NULL, "]]..score..[[" );
		]]
		db:exec( insertToDb )

		for row in db:nrows("SELECT * FROM test") do -- testing DB output
		    print( "row id: "..row.id )
		    print( "score: "..row.score )
		end
		db:close() --close DB
		Runtime:removeEventListener( "tap", gotoPlayMenu ) 	--Go Back button listener
		composer.removeScene( "GameMode.free" )				--Remove scene when scene goes away
	end
end
scene:addEventListener( "create", scene ) --Create scene listener
scene:addEventListener( "hide", scene )	--hide scene listener

return scene