-----------------------------------------
-- Victory Overlay
-----------------------------------------
--libraries
local composer = require( "composer" )
local scene = composer.newScene()
--for email sending = load the smtp and ltn12
local smtp = require("socket.smtp")
local mime = require("mime")
local ltn12 = require("ltn12")
local openssl = require( "plugin.openssl" )
local plugin_luasec_ssl = require('plugin_luasec_ssl')
local path = system.pathForFile( "data_report.csv", system.DocumentsDirectory )
--sound handling (currently there's no need to create a soud table. might need if more resources are added)
local winAudio = audio.loadSound( "Audio/win.mp3" ) --audio file
local playWinAudio = nil --to save audio player and control its deletion

local chalkSound = audio.loadSound( "Audio/chalk-tap.mp3" ) --back button chalk sound
local playChalk = nil
--functions
local function onAccept() --continue menu handler 
	playButtonSound = audio.play( chalkSound )
	composer.hideOverlay( "slideUp", 175 )
end

local function onSend()
	local emailOptions = {
		subject = "Data Report",
		attachment = {
			{
				baseDir= system.DocumentsDirectory, 
			 	filename= "data_report.csv",
			 	type="text/csv"
		 	},
		 	{
		 		baseDir = system.DocumentsDirectory,
		 		filename= "activity_report.csv",
		 		type="text/csv"
	 		}
		}
	}
	native.showPopup( "mail", emailOptions )
    -- print("send")
    -- playButtonSound = audio.play(chalkSound)

	-- -- creates a source to send a message with two parts. The first part is 
	-- -- plain text, the second part is a PNG image, encoded as base64.
	-- source = smtp.message{
	--   headers = {
	--      -- Remember that headers are *ignored* by smtp.send. 
	--      from = "Sicrano de Oliveira <@gmail.com>",
	--      to = "Fulano da Silva <@gmail.com>",
	--      subject = "Here is a message with attachments"
	--   },
	--   body = {
	--     preamble = "If your client doesn't understand attachments, \r\n" ..
	--                "it will still display the preamble and the epilogue.\r\n" ..
	--                "Preamble will probably appear even in a MIME enabled client.",
	--     -- first part: no headers means plain text, us-ascii.
	--     -- The mime.eol low-level filter normalizes end-of-line markers.
	--     [1] = { 
	--       body = mime.eol(0, [[
	--         Lines in a message body should always end with CRLF. 
	--         The smtp module will *NOT* perform translation. However, the 
	--         send function *DOES* perform SMTP stuffing, whereas the message
	--         function does *NOT*.
	--       ]])
	--     },
	--     -- second part: headers describe content to be a png image, 
	--     -- sent under the base64 transfer content encoding.
	--     -- notice that nothing happens until the message is actually sent. 
	--     -- small chunks are loaded into memory right before transmission and 
	--     -- translation happens on the fly.
	--     [2] = { 
	--       headers = {
	--         ["content-type"] = 'text/csv; name="data_report.csv"',
	--         ["content-disposition"] = 'attachment; filename="data_report.csv"',
	--         ["content-description"] = 'a beautiful image',
	--         ["content-transfer-encoding"] = "BASE64"
	--       },
	--       body = ltn12.source.chain(
	--         ltn12.source.file(io.open(path, "rb")),
	--         ltn12.filter.chain(
	--           mime.encode("base64"),
	--           mime.wrap()
	--         )
	--       )
	--     },
	--     epilogue = "This might also show up, but after the attachments"
	--   }
	-- }

	-- -- finally send it
	-- r, e = smtp.send{
	--     from = "<@gmail.com>",
	--     rcpt = "<t@gmail.com>",
	--     source = source,
	--     user = "@gmail.com",
  	-- 	password = "",
  	-- 	server = "smtp.gmail.com",
  	-- 	port = 25,
  	-- 	domain = "mail.google.com",
	-- }
end
-----------------------------------------
-- Scenes
-----------------------------------------
function scene:create( event )
	local sceneGroup = self.view

	local mainGroup = display.newGroup()
	sceneGroup:insert( mainGroup ) 

	local background = display.newImageRect( mainGroup, "Assets/Background/pause.jpg", 700, 375 ) --background
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	local notificationText = display.newText( mainGroup, "Report successfully created!", display.contentCenterX, 90, "Fonts/FORTE.TTF", 35 )
	notificationText.font = native.newFont( "Fonts.FORTE", 16 )
	notificationText:setTextColor( 1 )	

	local confirmText = display.newText( mainGroup, "Confirm", display.contentCenterX, display.contentCenterY, "Fonts/FORTE.TTF", 35 )
	confirmText.font = native.newFont( "Fonts.FORTE", 16 )
	confirmText:setTextColor( 1 )	

	local sendData = display.newText( mainGroup, "Send", display.contentCenterX, display.contentCenterY + 35, "Fonts/FORTE.TTF", 35 )
	sendData.font = native.newFont( "Fonts.FORTE", 16 )
	sendData:setTextColor( 1 )	

	confirmText:addEventListener( "tap", onAccept )	
	sendData:addEventListener( "tap", onSend )		
end
--show()
function scene:show( event )
	local sceneGroup = self.view 
	local phase = event.phase
	local parent  = event.parent

	if( phase == "will" )then
	elseif( phase == "did" )then
	end
end
--hide()
function scene:hide( event )
	local sceneGroup = self.view 
	local phase = event.phase
	local parent = event.parent
	if( phase == "will" )then
	elseif( phase == "did" )then
		if(playChalk~=nil)then audio.stop( playChalk ) end--stop audio player
		playChalk = nil 			--delete audio player from memory
		audio.dispose( chalkSound )	--dispose audio file (shouldn't be use if the scene is gonna repeat)
		chalkSound = nil				--set audio file to null
		 --this function reset the timer in the parent element 
		composer.hideOverlay( "Scenes.Overlay.report_notification" )	--Remove scene when scene goes away	end
	end
end
--scenes listeners
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
return scene