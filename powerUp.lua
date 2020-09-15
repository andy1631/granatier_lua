Player = require "player"
Vector = require 'lib.hump.vector'
Class = require 'lib.hump.class'

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

local PowerUp = Class{}

function PowerUp:init(cords)
  position = Vector.new(x, y),
  -- print("Ein neues Power-Up erscheint!")
  self.Texture = nil
end

function PowerUp:usePowerUp()
  print("Ein Power-Up wird benutzt!")
end

function PowerUp:draw()
  if self.Texture ~= nil then
    self.Texture:draw()
  end
end

return PowerUp