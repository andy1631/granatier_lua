Gamestate = require 'lib.hump.gamestate'

local menu = {}

local menuengine = require "lib.menuengine.menuengine"
menuengine.stop_on_nil_functions = true

local text = "Nothing was selected."

-- Mainmenu
local mainmenu

-- Start Game
local function start_game()
    Gamestate.switch(game)
end

-- Options
local function options()
    text = "Options was selected!"
end

-- Quit Game
local function quit_game()
    text = "Quit Game was selected!"
end

function menu:enter()
    -- many lines of code
    --love.window.setMode(600, 400)
    --love.graphics.setFont(love.graphics.newFont(20))

    mainmenu = menuengine.new(200, 100)
    mainmenu:addEntry("Start Game", start_game)
    mainmenu:addEntry("Options", options)
    mainmenu:addSep()
    mainmenu:addEntry("Quit Game", quit_game)
end

function menu:update(dt)
    -- many lines of code
    mainmenu:update()
end

function menu:draw()
    -- many lines of code
    love.graphics.clear()
    love.graphics.print(text)
    mainmenu:draw()
end

function menu:keypressed(key, scancode, isrepeat)
    menuengine.keypressed(scancode)

    if scancode == "escape" then
        love.event.quit()
    end
end

function menu:mousemoved(x, y, dx, dy, istouch)
    menuengine.mousemoved(x, y)
end

return menu
