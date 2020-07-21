local HC = require "HC"

local Player = {}

setmetatable(Player, {
    __index=function(cls, key)
      return getmetatable(cls)[key]
    end,
    __call=function(cls, ...)
      return getmetatable(cls).new(...)
    end,
    new = function(x, y)
      self = setmetatable({}, getmetatable(Player))
      self.x, self.y = x, y
      self.hitbox = HC.rectangle(self.x, self.y, 30, 30)
      return self
    end,
    __tostring = function(p)
      return string.format("(%.16g, %.16g)", p.x, p.y)
    end,
    draw = function()
      self.hitbox:draw('fill')
    end,
    move = function(x, y)
      self.hitbox:move(x, y)
    end
  })




return Player