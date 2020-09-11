Player = require "player"
Vector = require 'lib.hump.vector'

local PowerUp = {}
PowerUp.__index = PowerUp

function PowerUp.new(position)
  local self = setmetatable({
      position = Vector.new(x, y)
      print("Ein neues Power-Up erscheint!")
  }, PowerUp)
  return self
end,

function PowerUp:usePowerUp()
  print("Ein Power-Up wird benutzt!")
end,

--Draw-Methode einbinden

return PowerUp

--[[
PowerUp = Class {
  init = function(self)
    self.position = Vector.new(0, 0)
  end,
  function PowerUp:usePowerUp(Player)
    return 0
  end,
}--]]