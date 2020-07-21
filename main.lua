Player = require "player"

local player

function love.load()
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  --love.window.setMode(1200, 800, {resizable = true})
  player = Player(0, 0)
  --print(player)
end

function love.update(dt)
  player.move(100 * dt, 100 * dt)

end

function love.draw()
  player.draw()
  end

  function love.keypressed(key, sc, isr)
    Entities.clear()
  end
