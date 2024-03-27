-----------------------------------------
-- Scores
-----------------------------------------
local composer = require( "composer" )
local scene = composer.newScene()
local sqlite = require( "sqlite3" ) --for data through DB
local json = require( "json" ) --for data through DB
local widget = require( "widget" ) --For scrollview widget
--init varibales 
local background
local board
local backButton
local rowText = ""
--sound effects
local chalkSound = audio.loadSound( "Audio/chalk-tap.mp3" )
local chalkButton = nil
--invoque DB
local path = system.pathForFile( "data.db", system.DocumentsDirectory ) --path for DB
local db = sqlite.open( path ) --opening DB 
--in case there's no table it creates it 
local createTable = [[ 
CREATE TABLE IF NOT EXISTS scores (
id INTEGER PRIMARY KEY, 
score INTEGER NOT NULL,
time_spend VARCHAR(10) NOT NULL,
_date VARCHAR(15) NOT NULL);
]]
db:exec( createTable )
--Create data report
local function createReport()
	local path = system.pathForFile( "data_report.csv", system.DocumentsDirectory )
	local file = io.open( path, "w" )
	local i = 1 
	if( file ~= nil )then
		for data in db:nrows("SELECT * FROM scores") do
			if( i == 1 )then
				file:write( "Date, Time spend, Total score \n" )
			end
			file:write( data._date .. ", " 
			.. data.time_spend .. ", " .. data.score .. "\n")
			i = i + 1
		end
	end
end
--Create table view for scores
local function onRowRender( event )
	-- Get reference to the row group
    local row = event.row
    -- Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
    local rowHeight = row.contentHeight
    local rowWidth = row.contentWidth
 	
    local rowTitle = display.newText( row, rowText, 0, 0, nil, 14 )
    rowTitle:setFillColor( 0 )
    -- Align the label left and vertically centered
    rowTitle.anchorX = 0
    rowTitle.x = 20
    rowTitle.y = rowHeight * 0.5
end
local tableView = widget.newTableView(
    {
        left = 65,
        top = 45,
        height = 225,
        width = 350,
        sampleInt = 1,
        onRowRender = onRowRender,
        onRowTouch = onRowTouch,
        listener = scrollListener,
        scrollBarOptions = {
            -- sheet = scrollBarSheet,
            -- topFrame = 1,
            -- middleFrame = 2,
            -- bottomFrame = 3
        }
    }
)
--inserting rows throught db data

local function insertRows() --function for inserting rows 	
	for row in db:nrows("SELECT * FROM scores") do -- DB output
	    -- Insert a row into the tableView
	    rowText = "Date: " .. row._date .. ", Time Elapse: " .. row.time_spend
	    .. ", Score: " .. row.score
	    tableView:insertRow(
	        {
	        	isCategory = false,
	            rowHeight = 36,
	            params = {
	            	id = row.id,
	            	score = row.score,
	            	time = row.time_spend
	            }
	        }
	    )
	end
end
--button control
local function gotoMenu()
	chalkButton = audio.play( chalkSound )
	composer.gotoScene( "Scenes.main_menu", { time=350, effect="slideDown" } )
end
-----------------------------------------
-- Scene
-----------------------------------------
--create()
function scene:create( event )
	local sceneGroup = self.view
	--groups
	local mainGroup = display.newGroup()
	sceneGroup:insert( mainGroup )

	

	background = display.newImageRect( sceneGroup, "Assets/Background/main.png", 900, 520 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	board = display.newImageRect( sceneGroup, "Assets/Background/board.png", 600, 315 )
	board.x = display.contentCenterX
	board.y = display.contentCenterY + 5

	backButton = display.newImageRect( sceneGroup, "Assets/Buttons/back.png", 50, 25 )
	backButton.x = 0
	backButton.y = 20

	local reportButton = display.newImageRect( sceneGroup, "Assets/Buttons/report.png", 100, 50 ) --level 2 button (level 2 not yet implemented)
	reportButton.x = display.contentCenterX
	reportButton.y = 305

	local reportText = display.newText( sceneGroup, "Create report!", display.contentCenterX + 10, 303, "Fonts/FORTE.TTF", 10 )
	reportText.font = native.newFont( "Fonts.FORTE", 16 )
	reportText:setTextColor( 0.34, 0.27, 0.46  )

	insertRows() 
	sceneGroup:insert( tableView )
	backButton:addEventListener( "tap", gotoMenu )
	reportButton:addEventListener( "tap", createReport )
end
--hide()
function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if( phase == "will" )then
	elseif( phase == "did" )then
		if (chalkButton ~= nil)then audio.stop( chalkButton ) end
		chalkButton = nil
		db:close()
		if(file~=nil)then io.close( file ) end
		composer.removeScene( "Scenes.scores" )
	end
end
scene:addEventListener( "create", scene )
scene:addEventListener( "hide", scene )
return scene