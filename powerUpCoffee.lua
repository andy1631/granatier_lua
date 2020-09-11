PowerUp = require "powerUp"

local PowerUpCoffee = {}
PowerUpCoffee.__index = PowerUpCoffee

function PowerUpCoffee.new()
  local self = setmetatable({
      print("Das Power-Up Kaffee erscheint!")
  }, PowerUpCoffee)
  return self
end

function PowerUpCoffee:usePowerUp()
  print("Das Power-Up Kaffee wird benutzt!")
end

return PowerUpCoffee

--[[
PowerUpCoffee = inheritedFrom()
PowerUpCoffee = PowerUp:new()
p = PowerUpCoffee:new()
PowerUpCoffee = Class {
  init = function(self)
  end,
  self.use = PowerUp:
  PowerUpCoffee = PowerUp:new()
  
  
}--]]