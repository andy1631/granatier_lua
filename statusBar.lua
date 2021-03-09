Class = require "lib.hump.class"
Tove = require "lib.tove"

StatusBar = Class {}

function StatusBar:init()
  
end

function StatusBar:createTextBox(playerCount)
  self.textbox = {
    x = 1200,
    y = 140,
    width = 400,
    height = 200,
    text = 'Übersicht über Power-Ups der Spieler',
    active = false,
    colors = {
        background = { 255, 255, 255, 255 },
        text = { 40, 40, 40, 255 }
    }
  }
  -- Darstellung des Spieler 1-Bilds:
  self.Player1Tex = love.filesystem.read("resources/player1.svg")
  self.Player1Tex = Tove.newGraphics(self.Player1Tex, 30)
  -- Darstellung des Spieler 2-Bilds:
  self.Player2Tex = love.filesystem.read("resources/player2.svg")
  self.Player2Tex = Tove.newGraphics(self.Player2Tex, 30)
  -- Darstellung des Schild-Power-Ups:
  self.ShieldTex = love.filesystem.read("resources/SVG/bonus_shield.svg")
  self.ShieldTex = Tove.newGraphics(self.ShieldTex)
  -- Darstellung des Throw-Power-Ups:
  self.ThrowTex = love.filesystem.read("resources/SVG/bonus_throw.svg")
  self.ThrowTex = Tove.newGraphics(self.ThrowTex)
  -- Darstellung des Kick-Power-Ups:
  self.KickTex = love.filesystem.read("resources/SVG/bonus_kick.svg")
  self.KickTex = Tove.newGraphics(self.KickTex)
  -- Darstellung des Slow-Power-Ups:
  self.SlowTex = love.filesystem.read("resources/SVG/bonus_bad_slow.svg")
  self.SlowTex = Tove.newGraphics(self.SlowTex)
  -- Darstellung des Hyperactive-Power-Ups:
  self.HyperTex = love.filesystem.read("resources/SVG/bonus_bad_hyperactive.svg")
  self.HyperTex = Tove.newGraphics(self.HyperTex)
  -- Darstellung des Spiegel-Power-Ups:
  self.MirrorTex = love.filesystem.read("resources/SVG/bonus_bad_mirror.svg")
  self.MirrorTex = Tove.newGraphics(self.MirrorTex)
  -- Darstellung des Scatty-Power-Ups:
  self.ScattyTex = love.filesystem.read("resources/SVG/bonus_bad_scatty.svg")
  self.ScattyTex = Tove.newGraphics(self.ScattyTex)
  -- Darstellung des Restrain-Power-Ups:
  self.RestrainTex = love.filesystem.read("resources/SVG/bonus_bad_restrain.svg")
  self.RestrainTex = Tove.newGraphics(self.RestrainTex)
end

function StatusBar:draw()
  -- Variablen für die for-Schleife:
  self.Test = map.playerCount -- Zugriff auf die Anzahl der Spieler aus der Map
  self.x = 152
  self.y = 112
  self.powerUpY = 160
  for i = 1, self.Test, 1
  do
    -- if map.players[i-1].stats.shield == true -> normal -- shield, throw, kick und ein negatives Power-Up
    -- if map.players[i-1].stats.shield == false -> ausgegraut
    -- Spieler anhand der Anzahl erstellen:
    love.graphics.printf({{0, 0, 255, 255}, "Spieler " .. i}, self.x, self.y, 100, 'center') -- Farbe auf Blau setzen
    -- Zeichnen der Power-Ups unterhalb von Spieler 1:
    self.Player1Tex:draw(150, self.y + 7) -- x, y
    if map.players[i-1].stats.shield == true then -- Falls das Schild-Power-Up eingesammelt wurde
      love.graphics.setColor(255, 255, 255, 255) -- Normales Zeichnen
      self.ShieldTex:draw(148, self.powerUpY)
    end
    if map.players[i-1].stats.shield == false then -- Falls das Schild-Power-Up nicht eingesammelt wurde oder die Zeit abgelaufen ist
      love.graphics.setColor(255, 0, 0, 180) -- "Ausgegrautes" Zeichnen
      self.ShieldTex:draw(148, self.powerUpY)
    end
    if map.players[i-1].stats.throw == true then -- Falls das Throw-Power-Up eingesammelt wurde
      love.graphics.setColor(255, 255, 255, 255) -- Normales Zeichnen
      self.ThrowTex:draw(178, self.powerUpY)
    end
    if map.players[i-1].stats.throw == false then -- Falls das Throw-Power-Up nicht eingesammelt wurde oder die Zeit abgelaufen ist
      love.graphics.setColor(255, 0, 0, 180) -- "Ausgegrautes" Zeichnen
      self.ThrowTex:draw(178, self.powerUpY)
    end
    if map.players[i-1].stats.kick == true then -- Falls das Kick-Power-Up eingesammelt wurde
      love.graphics.setColor(255, 255, 255, 255) -- Normales Zeichnen
      self.KickTex:draw(208, self.powerUpY)
    end
    if map.players[i-1].stats.kick == false then -- Falls das Kick-Power-Up nicht eingesammelt wurde oder die Zeit abgelaufen ist
      love.graphics.setColor(255, 0, 0, 180) -- "Ausgegrautes" Zeichnen
      self.KickTex:draw(208, self.powerUpY)
    end
    -- Falls das zuvor eingesammelte Power-Up nicht mehr aktiv ist, muss es weiterhin dargestellt, aber ausgegraut werden
    --[[self.SlowBool = false -- Power-Up wurde mal eingesammelt, ist aber nicht mehr aktiv
    self.HyperBool = false
    self.MirrorBool = false
    self.ScattyBool = false
    self.RestrainBool = false--]]
    -- Ausgabe, ob die Variable true oder false ist:
    love.graphics.printf({{0, 0, 255, 255}, "Variable self.SlowBool vor ifs ist " .. tostring(self.SlowBool)}, self.x, self.y + 150, 100, 'center')
    love.graphics.printf({{0, 0, 255, 255}, "Variable self.HyperBool vor ifs ist " .. tostring(self.HyperBool)}, self.x, self.y + 450, 100, 'center')
    love.graphics.setColor(255, 255, 255, 255)
    if map.players[i-1].stats.slow == true then -- Falls das Slow-Power-Up eingesammelt wurde
      love.graphics.setColor(255, 255, 255, 255)
      love.graphics.printf({{0, 0, 255, 255}, "if slow == true -> " .. tostring(self.SlowBool)}, self.x, self.y + 500, 100, 'center')
      self.SlowTex:draw(238, self.powerUpY)
      self.SlowBool = true
      self.HyperBool = true
      self.MirrorBool = false
      self.ScattyBool = false
      self.RestrainBool = false
    end
    love.graphics.printf({{0, 0, 255, 255}, "Variable self.SlowBool vor if ist " .. tostring(self.SlowBool)}, self.x, self.y + 250, 100, 'center')
    if (map.players[i-1].stats.slow == false and self.SlowBool == true) then -- Falls das Slow-Power-Up eingesammelt wurde, muss es ausgegraut werden
      love.graphics.printf({{0, 0, 255, 255}, "Variable self.SlowBool in if ist " .. tostring(self.SlowBool)}, self.x, self.y + 250, 100, 'center')
      love.graphics.setColor(255, 0, 0, 180)
      self.SlowTex:draw(238, self.powerUpY)
    end
    if map.players[i-1].stats.hyperactive == true then -- Falls das Hyperactive-Power-Up eingesammelt wurde
      love.graphics.setColor(255, 255, 255, 255)
      love.graphics.printf({{0, 0, 255, 255}, "if hyper == true -> " .. tostring(self.HyperBool)}, self.x, self.y + 500, 100, 'center')
      self.HyperTex:draw(238, self.powerUpY)
      self.HyperBool = true
      self.SlowBool = false
      self.MirrorBool = false
      self.ScattyBool = false
      self.RestrainBool = false
      love.graphics.printf({{0, 0, 255, 255}, "Variable self.HyperBool in if ist " .. tostring(self.HyperBool)}, self.x, self.y + 350, 100, 'center')
    end
    --love.graphics.printf({{0, 0, 255, 255}, "stats.hyperactive == false -> "
        --.. tostring(map.players[i-1].stats.hyperactive == false)}, self.x, self.y + 500, 100, 'center')
    -- stats.hyperactive ist false, falls es nicht eingesammelt worden ist, trotzdem wird es nicht angezeigt
    if (map.players[i-1].stats.hyperactive == false and self.HyperBool == true) then -- Falls das Slow-Power-Up eingesammelt wurde, muss es ausgegraut werden
      love.graphics.setColor(255, 0, 0, 180)
      self.SlowTex:draw(238, self.powerUpY)
    end
    if map.players[i-1].stats.mirror == true then -- Falls das Spiegel-Power-Up eingesammelt wurde
      love.graphics.setColor(255, 255, 255, 255)
      love.graphics.printf({{0, 0, 255, 255}, "if mirror == true -> " .. tostring(self.MirrorBool)}, self.x, self.y + 500, 100, 'center')
      self.MirrorTex:draw(238, self.powerUpY)
      self.MirrorBool = true
      self.SlowBool = false
      self.HyperBool = false
      self.ScattyBool = false
      self.RestrainBool = false
    end
    if (map.players[i-1].stats.mirror == false and self.MirrorBool == true) then -- Falls das Slow-Power-Up eingesammelt wurde, muss es ausgegraut werden
      love.graphics.setColor(255, 0, 0, 180)
      self.SlowTex:draw(238, self.powerUpY)
    end
    if map.players[i-1].stats.scatty == true then -- Falls das Scatty-Power-Up eingesammelt wurde
      love.graphics.setColor(255, 255, 255, 255)
      love.graphics.printf({{0, 0, 255, 255}, "if scatty == true -> " .. tostring(self.ScattyBool)}, self.x, self.y + 500, 100, 'center')
      self.ScattyTex:draw(238, self.powerUpY)
      self.ScattyBool = true
      self.SlowBool = false
      self.HyperBool = false
      self.MirrorBool = false
      self.RestrainBool = false
    end
    if (map.players[i-1].stats.scatty == false and self.ScattyBool == true) then -- Falls das Slow-Power-Up eingesammelt wurde, muss es ausgegraut werden
      love.graphics.setColor(255, 0, 0, 180)
      self.SlowTex:draw(238, self.powerUpY)
    end
    if map.players[i-1].stats.restrain == true then -- Falls das Restrain-Power-Up eingesammelt wurde
      love.graphics.setColor(255, 255, 255, 255)
      love.graphics.printf({{0, 0, 255, 255}, "if restrain == true -> " .. tostring(self.RestrainBool)}, self.x, self.y + 500, 100, 'center')
      self.RestrainTex:draw(238, self.powerUpY)
      self.RestrainBool = true
      self.SlowBool = false
      self.HyperBool = false
      self.MirrorBool = false
      self.ScattyBool = false
    end
    love.graphics.printf({{0, 0, 255, 255}, "Variable self.RestrainBool vor ifs ist " .. tostring(self.RestrainBool)} .. " und map.player.restrain == " .. tostring(map.players[i-1].stats.restrain), self.x, self.y + 10, 100, 'center')
    if (map.players[i-1].stats.restrain == false and self.RestrainBool == true) then -- Falls das Slow-Power-Up eingesammelt wurde, muss es ausgegraut werden
      love.graphics.setColor(255, 0, 0, 180)
      self.SlowTex:draw(238, self.powerUpY)
    end
    --[[
    self.ThrowTex:draw(178, self.powerUpY)
    love.graphics.setColor(255, 0, 0, 180) -- 255, 0, 0, 180 = rot
    self.KickTex:draw(208, self.powerUpY)
    self.RestrainTex:draw(238, self.powerUpY)
    love.graphics.setColor(255, 255, 255, 255)
    --]]
    -- Hochzählen der einzelnen Variablen:
    self.y = self.y + 78
    self.powerUpY = self.powerUpY + 78
  end
  -- Altes Zeichnen des Spielers:
  --[[
  love.graphics.printf({{0, 0, 255, 255}, "Spieler 1"}, 152, 262, 100, 'center') -- Farbe auf Blau setzen
  -- Zeichnen der Power-Ups unterhalb von Spieler 1:
  self.ShieldTex:draw(148, 310)
  self.ThrowTex:draw(178, 310)
  love.graphics.setColor(255, 0, 0, 180) -- 255, 0, 0, 180 = rot
  self.KickTex:draw(208, 310)
  self.RestrainTex:draw(238, 310)
  -- Spieler 2 mit Text und Power-Ups:
  self.Player2Tex:draw(150, 348)
  love.graphics.printf({{255, 0, 0, 255}, "Spieler 2"}, 152, 340, 100, 'center')
  -- Zeichnen der Power-Ups unterhalb von Spieler 2:
  self.ShieldTex:draw(148, 388)
  self.ThrowTex:draw(178, 388)
  self.KickTex:draw(208, 388)
  self.RestrainTex:draw(238, 388)
  --]]
end

function StatusBar:update()
  love.graphics.printf('Update-Methode', 50, 50, 400)
end

return StatusBar