-----------------------------------------
-- Main Menu
-----------------------------------------
--system.activate( "multitouch" ) --(not needed)
local composer = require( "composer" )
local scene = composer.newScene()
local json = require( "json" )
--DB resources
local sqlite = require( "sqlite3" )
local path = system.pathForFile( "data.db", system.DocumentsDirectory ) --path for DB
local db = sqlite.open( path ) 											--opening DB 
--initializing variables
local background
local backButton
local ball
local box
local selectedBasket = {}
--variables for control
local score = 0
local scoreText
local isSet = false
local timeSpend = 0
--load sheets
local fSheet = 
{	--Food sheet frames
	frames = 
	{
		{ --frame 1
			x = 0,
			y = 0,
			width = 295,
			height = 293
		},
		{ --frame 2
			x = 296,
			y = 0,
			width = 295,
			height = 293
		},
		{ --frame 3
			x = 591,
			y = 0,
			width = 291,
			height = 293
		},
		{ --frame 4
			x = 882,
			y = 0,
			width = 291,
			height = 293
		},
		{ --frame 5
			x = 1173,
			y = 0,
			width = 293,
			height = 293
		},
		{ --frame 6
			x = 1466,
			y = 0,
			width = 293,
			height = 293
		},
		{ --frame 7
			x = 1759,
			y = 0,
			width = 290,
			height = 293
		},
		{ --frame 8
			x = 2051,
			y = 0,
			width = 292,
			height = 293
		},
		{ --frame 9
			x = 2341,
			y = 0,
			width = 295,
			height = 293
		},
		{ --frame 10
			x = 2636,
			y = 0,
			width = 295,
			height = 293
		}
	},
	numframes = 10,
	sheetContentWidth = 2931,
	sheetContentHeight = 293
}
local ASheet = 	
{	--Animals sheet frames
	frames = 
	{
		{ --frame 1
			x = 0,
			y = 0,
			width = 295,
			height = 293
		},
		{ --frame 2
			x = 296,
			y = 0,
			width = 292,
			height = 293
		},
		{ --frame 3
			x = 591,
			y = 0,
			width = 291,
			height = 293
		},
		{ --frame 4
			x = 882,
			y = 0,
			width = 291,
			height = 293
		},
		{ --frame 5
			x = 1173,
			y = 0,
			width = 293,
			height = 293
		},
		{ --frame 6
			x = 1466,
			y = 0,
			width = 293,
			height = 293
		},
		{ --frame 7
			x = 1759,
			y = 0,
			width = 290,
			height = 293
		},
		{ --frame 8
			x = 2049,
			y = 0,
			width = 292,
			height = 293
		},
		{ --frame 9
			x = 2343,
			y = 0,
			width = 295,
			height = 293
		},
		{ --frame 10
			x = 2636,
			y = 0,
			width = 295,
			height = 293
		}
	},
	numframes = 10,
	sheetContentWidth = 2931,
	sheetContentHeight = 293
}
foodSheet = graphics.newImageSheet( "Assets/Food/food-sheet.png", fSheet )
animalSheet = graphics.newImageSheet( "Assets/Animals/animals-sheet.png", ASheet )
--scene button handler
local function gotoPlayMenu() --go back to previous screen
	composer.gotoScene( "Scenes.play_menu", { time=500, effect="slideRight" } )
end
--timer
local function timeCounter( event )
	timeSpend = timeSpend + 1
	-- Time is tracked in seconds; convert it to minutes and seconds
    local minutes = math.floor( timeSpend / 60 )
    local seconds = timeSpend % 60
    -- Make it a formatted string
    saveTime = string.format( "%02d:%02d", minutes, seconds )
end
--Main collision function
local function collisionOcurred( event, typeName, boxName ) --Objects collision handler (for inserting in basket)
	local phase = event.phase 		--get the event phase
	local objt1 = event.object1 	--object 1
	local objt2 = event.object2 	--object 2

	local category = boxName --get variable 1 locally (not doing this causes the function not to recognize the variables)
	local name = typeName --get variable 2 locally (not doing this causes the function not to recognize the variables)
	if ( phase == "began" )then
		if ( (objt1.name == category and objt2.name == name) or    --set variables based in the objects 
		(objt2.name == category and objt1.name == name) ) then
			display.remove( objt1 )
			score = score + 1
			print( score )
		end
	end
	if( phase == "ended" )then 								--check the objects colliding when the collision ends
		if ( (objt1.name ~= category and objt2.name ~= name) or 
		(objt2.name ~= category and objt1.name ~= name) ) then
		end
	end
end
--Handlers for all collision types
local function collisionWithin( event )
	collisionOcurred( event, "animal", "animalBasket" )
	collisionOcurred( event, "food", "foodBasket" )
end
-- Activate multitouch (not currently needed)
local function dragItem( event ) --drag: touch detector + collision detector
	local target = event.target
	local id = event.id
	local phase = event.phase	
	
	if (phase == "began")then --transforming positions	
		startingTarget = event.target --for overlaping of events prevention 
									--since Solar2d doesn't end the event when
									--switching too fast within targets
		--print( startingTarget.name )
		event.target.alpha = 0.8 --change transparency on touc
		display.getCurrentStage():setFocus(  target, id ) --prevent objects from overlaping
		--calculate difference within event and object axis
		target.touchOffsetX = event.x - target.x
		target.touchOffsetY = event.y - target.y
		--save the initial target position
		defaultX = target.x
		defaultY = target.y
	elseif (phase == "moved") then
		display.getCurrentStage():setFocus(  target, id ) --prevent objects from overlaping
		if(target.touchOffsetX ~= nil and target == startingTarget)then --"startingTarget" is saved at the 
			target.x = event.x - target.touchOffsetX					--beggining of the function while
			target.y = event.y - target.touchOffsetY					--the "event.target" can vary due 
		end 															--to conflict with times causing 
	elseif (phase == "ended" or phase == "cancelled") then				--undesired effects
		event.target.alpha = 1
		--reset the initial target position
		if(target == startingTarget)then
			target.x = defaultX
			target.y = defaultY
		end
		display.getCurrentStage():setFocus(  target, nil )
	end
	return true -- Prevents touch propagation to underlying objects
end
--spawn handler
function spawnRow( group, rowX, rowY )
	local options = { foodSheet, animalSheet }
	local group = group
	local initX = rowX
	local rowY = rowY

	for i = 1, 5 do
		local typeSelector = math.random( 1, 2 )	--random selectors for spawming
		local objectSelector = math.random( 1, 10 )
		--categorizing the objects 
		local frame = display.newImageRect( group, options[typeSelector], objectSelector, 50, 50 )
		if(options[typeSelector] == foodSheet)then		--Assigning names to each element within
			frame.name = "food"						--the loop for categorizing them		
			selectedBasket = {
				name = "foodBasket",
				src = "Assets/Food/food-basket.png"
			}
		elseif(options[typeSelector] == animalSheet)then
			frame.name = "animal"
			selectedBasket = {
				name = "animalBasket",
				src = "Assets/Animals/animals-basket.png"
			}			
		end
		frame.x = initX 
		frame.y = rowY
		frame.isBullet = true
		physics.addBody( frame, "dynamic", { radius=50, isSensor=true } )
		initX = initX + 60
		frame:addEventListener( "touch", dragItem )
	end
end
local function respawn( group )
	local group = group
	local elem_amount = group.numChildren
	print( elem_amount)

	for i = 1, elem_amount do
		group:remove( i )
	end
	for i = 1, elem_amount do
		group:remove( i )
	end
	for i = 1, elem_amount do
		group:remove( i )
	end
	for i = 1, elem_amount do
		group:remove( i )
	end
	for i = 1, elem_amount do
		group:remove( i )
	end
	spawnRow( group, 35, 110 )
	spawnRow( group, 35, 185 )
	spawnRow( group, 35, 260 )
end
-----------------------------------------
-- Coding playground
-----------------------------------------
local backgroundSet = { "Assets/Background/kinder.png", "Assets/Background/kitchen.png", "Assets/Background/jungle.png",
"Assets/Background/living.png", "Assets/Background/bedroom.png", } --random background list for random selection
-----------------------------------------
-- Scene Handling
-----------------------------------------
--create()
function scene:create( event )
	currentTime = timer.performWithDelay( 1000, timeCounter, timeSpend )
	local sceneGroup = self.view 		--scene view
	local physics = require( "physics" ) --implementing physics
	physics.start()
	physics.setGravity( 0,0 )
	local backGroup = display.newGroup() -- background elements group
	sceneGroup:insert( backGroup ) 
	local mainGroup = display.newGroup() -- game objects group
	sceneGroup:insert( mainGroup ) 

	local categoriesGroup = display.newGroup() --for spawm objects
	sceneGroup:insert( categoriesGroup )

	local uiGroup = display.newGroup() 	-- UI elements group
	sceneGroup:insert( uiGroup ) 


	local selectedBg = math.random( 1,5 )
	background = display.newImageRect( backGroup, backgroundSet[selectedBg], 700, 375 ) --background
	--applying blur to background
	background.fill.effect = 'filter.blurGaussian'
	background.fill.effect.horizontal.blurSize = 10
	background.fill.effect.horizontal.sigma = 150
	background.fill.effect.vertical.blurSize = 10
	background.fill.effect.vertical.sigma = 150
	
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	--Score Text
	scoreText = display.newText( uiGroup, "", display.contentCenterX, 20, native.systemFont, 15 )
	scoreText:setFillColor( 0,0,0 )	
	--Box
	-- box = display.newImageRect( mainGroup, "Assets/Toys/box.png", 90, 90 ) --toys box
	-- box.name = "foodBox"
	-- local box_outline = graphics.newOutline( 10, "Assets/Toys/box.png" )
	-- box.x = 500
	-- box.y = 265
	-- physics.addBody( box, "static", { radius=1, outline=box_outline } ) --box physics box
	--Back Button
	backButton = display.newImageRect( backGroup, "Assets/Buttons/back.png", 50, 25 ) --go back button
	backButton.x = 0
	backButton.y = 16

	local secondBoard = display.newImageRect( mainGroup, "Assets/Background/board-2.png", 515, 325 )
	secondBoard.x = 160
	secondBoard.y = 200
	--for trying spreadsheet crop
	-- local testImage = display.newImageRect( mainGroup, animalSheet, 10, 50, 50 ) 
	-- testImage.x = display.contentCenterX
	-- testImage.y = display.contentCenterY

	local basketBoard = display.newImageRect( mainGroup, "Assets/Background/board-2.png", 250, 150 )
	basketBoard.x = 475
	basketBoard.y = 260

	spawnRow( categoriesGroup, 35, 110 )
	spawnRow( categoriesGroup, 35, 185 )
	spawnRow( categoriesGroup, 35, 260 )

	print( selectedBasket["name"] )
	local basket = display.newImageRect( mainGroup, selectedBasket["src"], 200, 100 )
	basket.name = selectedBasket["name"]
	basket.x = 475
	basket.y = 260
	physics.addBody( basket, "static", { radius=1, outline=box_outline } ) --physics box

	local respawnButton = display.newImageRect( backGroup, "Assets/Buttons/respawn.png", 50, 25 )
	respawnButton.x = 475
	respawnButton.y = 50

	local function respawnGroup( event )
		respawn( categoriesGroup )
	end

	Runtime:addEventListener( "collision", collisionWithin )
	backButton:addEventListener( "tap", gotoPlayMenu )

	respawnButton:addEventListener( "tap", respawnGroup )

	print( categoriesGroup.numChildren )
	print( json.prettify( categoriesGroup ) )
end
--show()
function scene:show( event )
	local phase = event.phase

	if(phase == "will")then
		--DB implementation
		local testing = [[ DROP TABLE IF EXISTS scores;]] --WARNING!! Disable on production. Will drop the table on scene refresh
		local createTable = [[
		CREATE TABLE IF NOT EXISTS scores (
		id INTEGER PRIMARY KEY, 
		score INTEGER NOT NULL,
		time_spend TEXT NOT NULL);
		]] --query
		db:exec( testing ) 		--DISABLE!!
		db:exec( createTable )	--executing table creation query
	elseif(phase == "did")then
	end
end
--hide()
function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if (phase == "will") then
		timer.cancel( currentTime ) --stop time counter
	elseif (phase == "did") then
		--inserting into DB 
		if( saveTime ~= nil )then
			local insertToDb = [[INSERT INTO scores VALUES ( NULL, "]]..score..[[", "]]..saveTime..[[" );]]
			db:exec( insertToDb )
			for row in db:nrows("SELECT * FROM scores") do -- testing DB output
			    print( "row id: "..row.id )
			    print( "score: "..row.score )
			    print( "total time: "..row.time_spend )
			end
		end
		db:close() --close DB
		physics.stop() -- stopping physics when scene stops
		Runtime:removeEventListener( "tap", gotoPlayMenu ) 	--Go Back button listener
		Runtime:removeEventListener( "collision", collisionWithin ) -- Remove collision event listener
		composer.removeScene( "GameMode.categorize" )		--Remove scene when scene goes away
	end
end
scene:addEventListener( "create", scene ) --Create scene listener
scene:addEventListener( "show", scene ) --Show scene listener
scene:addEventListener( "hide", scene )	--Hide scene listener
return scene