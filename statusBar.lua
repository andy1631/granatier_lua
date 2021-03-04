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
  -- Darstellung des Restrain-Power-Ups:
  self.RestrainTex = love.filesystem.read("resources/SVG/bonus_bad_restrain.svg")
  self.RestrainTex = Tove.newGraphics(self.RestrainTex)
end

function StatusBar:draw()
  -- love.graphics.setColor(unpack(self.textbox.colors.background))
  -- love.graphics.printf(self.textbox.text, self.textbox.x, self.textbox.y, self.textbox.width, 'left')
  -- Spieler 1 mit Text und Power-Ups:
  self.Player1Tex:draw(150, 270) -- x, y
  love.graphics.printf({{0, 0, 255, 255}, "Spieler 1"}, 152, 262, 100, 'center') -- Farbe auf Blau setzen
  -- Zeichnen der Power-Ups unterhalb von Spieler 1:
  self.ShieldTex:draw(148, 310)
  self.ThrowTex:draw(178, 310)
  self.KickTex:draw(208, 310)
  self.RestrainTex:draw(238, 310)
  -- love.graphics. -- Rechteck der Text-Box
  -- Spieler 2 mit Text und Power-Ups:
  self.Player2Tex:draw(150, 348)
  love.graphics.printf({{255, 0, 0, 255}, "Spieler 2"}, 152, 340, 100, 'center')
  -- Zeichnen der Power-Ups unterhalb von Spieler 2:
  self.ShieldTex:draw(148, 388)
  self.ThrowTex:draw(178, 388)
  self.KickTex:draw(208, 388)
  self.RestrainTex:draw(238, 388)
end

function StatusBar:update()
  love.graphics.printf('Update-Methode', 50, 50, 400)
end

return StatusBar