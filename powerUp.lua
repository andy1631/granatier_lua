Player = require "player"
Vector = require "lib.hump.vector"
Class = require "lib.hump.class"

--local PowerUp = {}
--[[PowerUp.__index = PowerUp

function PowerUp.new(position)
  local self = setmetatable({
      position = Vector.new(x, y),
      print("Ein neues Power-Up erscheint!")
    }, PowerUp)
  return self
end,

function PowerUp:usePowerUp()
  print("Ein Power-Up wird benutzt!")
end,

--Draw-Methode einbinden
]]
local PowerUp = Class {}

function PowerUp:init(pos)
    self.position = pos
    self.Texture:rescale(40)
    -- print("Ein neues Power-Up erscheint!")
end

function PowerUp:draw()
    self.Texture:draw(self.position.x, self.position.y)
end

return PowerUp
