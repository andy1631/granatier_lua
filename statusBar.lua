Class = require "lib.hump.class"
Tove = require "lib.tove"

StatusBar = Class {}

function StatusBar:init(playerCount)
    self.playerCount = playerCount
    --self:createTextBox()
    -- Darstellung des Spieler 1-Bilds:
    self.Player1Tex = Tove.newGraphics(Textures["player1"], 30)
    -- Darstellung des Spieler 2-Bilds:
    self.Player2Tex = Tove.newGraphics(Textures["player2"], 30)
    -- Darstellung des Schild-Power-Ups:
    --self.ShieldTex = love.filesystem.read("resources/SVG/bonus_shield.svg")
    self.ShieldTex = Tove.newGraphics(Textures["bonus_shield"])
    -- Darstellung des Throw-Power-Ups:
    --self.ThrowTex = love.filesystem.read("resources/SVG/bonus_throw.svg")
    self.ThrowTex = Tove.newGraphics(Textures["bonus_throw"])
    -- Darstellung des Kick-Power-Ups:
    --self.KickTex = love.filesystem.read("resources/SVG/bonus_kick.svg")
    self.KickTex = Tove.newGraphics(Textures["bonus_kick"])
    -- Darstellung des Slow-Power-Ups:
    --self.SlowTex = love.filesystem.read("resources/SVG/bonus_bad_slow.svg")
    self.SlowTex = Tove.newGraphics(Textures["bonus_bad_slow"])
    -- Darstellung des Hyperactive-Power-Ups:
    --self.HyperTex = love.filesystem.read("resources/SVG/bonus_bad_hyperactive.svg")
    self.HyperTex = Tove.newGraphics(Textures["bonus_bad_hyperactive"])
    -- Darstellung des Spiegel-Power-Ups:
    --self.MirrorTex = love.filesystem.read("resources/SVG/bonus_bad_mirror.svg")
    self.MirrorTex = Tove.newGraphics(Textures["bonus_bad_mirror"])
    -- Darstellung des Scatty-Power-Ups:
    --self.ScattyTex = love.filesystem.read("resources/SVG/bonus_bad_scatty.svg")
    self.ScattyTex = Tove.newGraphics(Textures["bonus_bad_scatty"])
    -- Darstellung des Restrain-Power-Ups:
    --self.RestrainTex = love.filesystem.read("resources/SVG/bonus_bad_restrain.svg")
    self.RestrainTex = Tove.newGraphics(Textures["bonus_bad_restrain"])
end

function StatusBar:createTextBox()
    self.textbox = {
        x = 1200,
        y = 140,
        width = 400,
        height = 200,
        text = "Übersicht über Power-Ups der Spieler",
        active = false,
        colors = {
            background = {255, 255, 255, 255},
            text = {40, 40, 40, 255}
        }
    }
end

function StatusBar:draw()
    -- Variablen für die for-Schleife:
    self.Test = map.playerCount -- Zugriff auf die Anzahl der Spieler aus der Map
    self.x = 152
    self.y = 112
    self.powerUpY = 160
    for i = 1, self.Test, 1 do
        -- Spieler anhand der Anzahl erstellen:
        love.graphics.printf({{0, 0, 255, 255}, "Spieler " .. i}, self.x, self.y, 100, "center") -- Farbe auf Blau setzen
        love.graphics.setColor(255, 255, 255, 255) -- Farbe für das Zeichnen des Spieler-Bilds zurücksetzen
        -- Abwechselnd soll die Textur für Spieler 1 oder Spieler 2 gezeichnet werden:
        if i % 2 == 1 then
            self.Player1Tex:draw(150, self.y + 7) -- x, y
        end
        if i % 2 == 0 then
            self.Player2Tex:draw(150, self.y + 7) -- x, y
        end
        -- Zeichnen der Power-Ups unterhalb des jeweiligen Spielers:
        if map.players[i - 1].stats.shield == true then -- Falls das Schild-Power-Up eingesammelt wurde
            love.graphics.setColor(255, 255, 255, 255) -- Normales Zeichnen
            self.ShieldTex:draw(148, self.powerUpY)
        end
        if map.players[i - 1].stats.shield == false then -- Falls das Schild-Power-Up nicht eingesammelt wurde oder die Zeit abgelaufen ist
            love.graphics.setColor(255, 0, 0, 180) -- "Ausgegrautes" Zeichnen
            self.ShieldTex:draw(148, self.powerUpY)
        end
        if map.players[i - 1].stats.throw == true then -- Falls das Throw-Power-Up eingesammelt wurde
            love.graphics.setColor(255, 255, 255, 255) -- Normales Zeichnen
            self.ThrowTex:draw(178, self.powerUpY)
        end
        if map.players[i - 1].stats.throw == false then -- Falls das Throw-Power-Up nicht eingesammelt wurde oder die Zeit abgelaufen ist
            love.graphics.setColor(255, 0, 0, 180) -- "Ausgegrautes" Zeichnen
            self.ThrowTex:draw(178, self.powerUpY)
        end
        if map.players[i - 1].stats.kick == true then -- Falls das Kick-Power-Up eingesammelt wurde
            love.graphics.setColor(255, 255, 255, 255) -- Normales Zeichnen
            self.KickTex:draw(208, self.powerUpY)
        end
        if map.players[i - 1].stats.kick == false then -- Falls das Kick-Power-Up nicht eingesammelt wurde oder die Zeit abgelaufen ist
            love.graphics.setColor(255, 0, 0, 180) -- "Ausgegrautes" Zeichnen
            self.KickTex:draw(208, self.powerUpY)
        end
        love.graphics.setColor(255, 255, 255, 255)
        -- Slow-Power-Up wird nach Einsammeln noch nicht angezeigt
        if map.players[i - 1].stats.slow == true then -- Falls das Slow-Power-Up eingesammelt wurde
            love.graphics.setColor(255, 255, 255, 255)
            self.SlowTex:draw(238, self.powerUpY)
            self.SlowBool = true
            self.HyperBool = false
            self.MirrorBool = false
            self.ScattyBool = false
            self.RestrainBool = false
        end
        if (map.players[i - 1].stats.slow == false and self.SlowBool == true) then -- Falls das Slow-Power-Up eingesammelt wurde, muss es ausgegraut werden
            love.graphics.setColor(255, 0, 0, 180)
            self.SlowTex:draw(238, self.powerUpY)
        end
        if map.players[i - 1].stats.hyperactive == true then -- Falls das Hyperactive-Power-Up eingesammelt wurde
            love.graphics.setColor(255, 255, 255, 255)
            self.HyperTex:draw(238, self.powerUpY)
            self.HyperBool = true
            self.SlowBool = false
            self.MirrorBool = false
            self.ScattyBool = false
            self.RestrainBool = false
        end
        if (map.players[i - 1].stats.hyperactive == false and self.HyperBool == true) then -- Falls das Slow-Power-Up eingesammelt wurde, muss es ausgegraut werden
            love.graphics.setColor(255, 0, 0, 180)
            self.HyperTex:draw(238, self.powerUpY)
        end
        if map.players[i - 1].stats.mirror == true then -- Falls das Spiegel-Power-Up eingesammelt wurde
            love.graphics.setColor(255, 255, 255, 255)
            self.MirrorTex:draw(238, self.powerUpY)
            self.MirrorBool = true
            self.SlowBool = false
            self.HyperBool = false
            self.ScattyBool = false
            self.RestrainBool = false
        end
        if (map.players[i - 1].stats.mirror == false and self.MirrorBool == true) then -- Falls das Slow-Power-Up eingesammelt wurde, muss es ausgegraut werden
            love.graphics.setColor(255, 0, 0, 180)
            self.MirrorTex:draw(238, self.powerUpY)
        end
        if map.players[i - 1].stats.scatty == true then -- Falls das Scatty-Power-Up eingesammelt wurde
            love.graphics.setColor(255, 255, 255, 255)
            self.ScattyTex:draw(238, self.powerUpY)
            self.ScattyBool = true
            self.SlowBool = false
            self.HyperBool = false
            self.MirrorBool = false
            self.RestrainBool = false
        end
        if (map.players[i - 1].stats.scatty == false and self.ScattyBool == true) then -- Falls das Slow-Power-Up eingesammelt wurde, muss es ausgegraut werden
            love.graphics.setColor(255, 0, 0, 180)
            self.ScattyTex:draw(238, self.powerUpY)
        end
        if map.players[i - 1].stats.restrain == true then -- Falls das Restrain-Power-Up eingesammelt wurde
            love.graphics.setColor(255, 255, 255, 255)
            self.RestrainTex:draw(238, self.powerUpY)
            self.RestrainBool = true
            self.SlowBool = false
            self.HyperBool = false
            self.MirrorBool = false
            self.ScattyBool = false
        end
        if (map.players[i - 1].stats.restrain == false and self.RestrainBool == true) then -- Falls das Slow-Power-Up eingesammelt wurde, muss es ausgegraut werden
            love.graphics.setColor(255, 0, 0, 180)
            self.RestrainTex:draw(238, self.powerUpY)
        end
        -- Hochzählen der einzelnen Variablen:
        self.y = self.y + 78
        self.powerUpY = self.powerUpY + 78
    end
end

function StatusBar:update()
    love.graphics.printf("Update-Methode", 50, 50, 400)
end

return StatusBar
