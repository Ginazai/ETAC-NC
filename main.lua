-----------------------------------------------------------------------------------------
--
-- Stimulation Game
--
-----------------------------------------------------------------------------------------
local composer = require( "composer" )
--go to menu when back space is selected
local function gotoMenu()
	composer.gotoScene( "Scenes.main_menu", { time=500, effect="slideRight" } )
end

local function onBkPress( event )
	if ( event.keyName == "back" ) then
	    if ( system.getInfo("platform") == "android" ) then
	    	gotoMenu()
	        return true
	    end
	end
	return false
end
--selecting main scene
composer.gotoScene( "Scenes.main_menu" )
Runtime:addEventListener( "key", onBkPress )