PowerUp = require "powerUp"
Class = require 'lib.hump.class'

--[[local PowerUpCoffee = {}
PowerUpCoffee.__index = PowerUpCoffee

function PowerUpCoffee.new()
  local self = setmetatable({
      print("Das Power-Up Kaffee erscheint!")
  }, PowerUpCoffee)
  powerUpCoffee = love.filesystem.read("resources/SVG/bonus_bad_hyperactive.svg")
  powerUpCoffee = tove.newGraphics(powerUpCoffee)
  powerUpCoffee:rescale(10)
  return self
end

function PowerUpCoffee:usePowerUp()
  print("Das Power-Up Kaffee wird benutzt!")
end
]]

local PowerUpCoffee = Class.include{__includes = PowerUp}

function PowerUpCoffee:init(cords) 
  PowerUp.init(self, cords)
end

function PowerUpCoffee:usePowerUp(player)
  
end

function PowerUpCoffee:draw()
  coffee = love.filesystem.read("resources/SVG/bonus_bad_hyperactive.svg")
  coffee = tove.newGraphics(coffee)
  coffee:draw()
end

return PowerUpCoffee