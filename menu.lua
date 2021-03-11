Gamestate = require 'lib.hump.gamestate'

local menu = {}

local menuengine = require "lib.menuengine.menuengine"
menuengine.stop_on_nil_functions = true

local text = "Nothing was selected."

-- Mainmenu
local mainmenu

-- Start Game
local function join_game()
    Gamestate.switch(game, "127.0.0.1", 12345)
end

-- Options
local function host_game()
    Gamestate.switch(game)
end

-- Quit Game
local function quit_game()
    text = "Quit Game was selected!"
end

function menu:enter()
    -- many lines of code
    --love.window.setMode(600, 400)
    --new Font
    mainfont = love.graphics.newFont("resources/DotGothic16/DotGothic16-Regular.ttf",35)
    love.graphics.setFont(mainfont)

    mainmenu = menuengine.new(600, 250)
    mainmenu:addEntry("Join Game", join_game)
    mainmenu:addEntry("Host Game", host_game)
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
   textFont = love.graphics.newFont("resources/DotGothic16/DotGothic16-Regular.ttf",20)
    love.graphics.setFont(textFont)
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
