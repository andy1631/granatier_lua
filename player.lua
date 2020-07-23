HC = require 'lib.HC'
vector = require 'lib.hump.vector'

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
      self.position = vector.new(x, y)
      self.hitbox = HC.rectangle(self.position.x, self.position.y, 30, 30)
      self.velocity = vector.new(0, 0)
      self.acceleration = 20
      self.frictionRatio = 0.1
      self.stats = {
        speedBoost = 0, 
        bombs = 1,
        power = 1,
        shield = false,
        throw = false,
        kick = false,
        slow = false,
        hyperactive = false,
        mirror = false,
        scatty = false,
        restrain = false
      }

      return self
    end,
    __tostring = function(p)
      return string.format("(%.16g, %.16g)", self.position:unpack())
    end,
    draw = function()
      love.graphics.setColor(255,255,255,1)
      self.hitbox:draw('line')
    end,
    move = function(x, y)
      self.velocity = (self.velocity + self.acceleration * vector.new(x, y))
    end,
    update = function(dt)

      local frictionVector = self.velocity * self.frictionRatio

      self.velocity = self.velocity - frictionVector

      self.hitbox:move(self.velocity.x * dt, self.velocity.y * dt)
    end
  })


return Player