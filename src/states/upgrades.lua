local title = GS.new()

function title:init()
    self.drawGrid = false

    self.colors = require 'lib.colors'
    self.gui = require 'lib.quickie'
    self.grid = require 'lib.quickie.grid'

    self.view = love.graphics.newCanvas(800, 600)

    self.debugName = "In Game Options"
end

  function title:enter(previous)
    local gridschema = {

      columns = {200, 30, 200, 30, 200 },
      rows = { 30, 30, 30, 30, 30, 30,80,30},
      alignment = {
        horizontal = "left",
        vertical = "top"
      },
      margin = { left = 0, top = 130, right = 0, bottom = 0 }
    }
    self.grid:init(self.gui, gridschema)

    self.sliders = {
      x = {value = self.view:getHeight() / 1024},
    }

    --self.shader.effect:send("xOffset", self.sliders.x.value)


  end

  function title:leave(previous)
    self.doExit = nil
  end

  function title:update(dt)
    if self.doExit then 
      return self.doExit() 
    end 

    self.grid:Button("Pistol", 3, 1, 1, 1, "center", "menu")
      GS.switch(Play, "pistol") 
    self.grid:Button("SMG", 3,2,1,1, "center", "menu")
      GS.switch(Play, "smg") 
    self.grid:Button("Shotgun", 3, 3, 1, 1, "center", "menu")
      GS.switch(Play, "shotgun") 
    self.grid:Button("Bazooka", 3, 4, 1, 1, "center", "menu")
      GS.switch(Play, "bazooka")
    self.grid:Button("Flamethrower", 3, 5, 1, 1, "center", "menu")
      GS.switch(Play, "flame")
    self.grid:Button("Rifle", 3, 6, 1, 1, "center", "menu")
      GS.switch(Play, "rifle")


 --   love.audio.setVolume(self.sliders.x)

    if self.grid:Button("Back", 1,8,1,1, "menu") then
      GS.switch(InGame)
    end
 
  end  

  function title:draw()
    if self.resetView then
      love.graphics.setCanvas(self.view)
      self.view:clear()
      self.colors:pushRandom()
      self.colors:pop()
      love.graphics.setCanvas()
      self.resetView = false
    end
    self.gui.core.draw()

    if self.drawGrid then self.grid:TestDrawGrid() end
  end


  function title:keypressed(key, code)
    self.gui.core.keyboard.pressed(key, code)
    if key == "escape" then
      GS.switch(InGame)
    end

    if key == "g" then
      self.drawGrid = not self.drawGrid
    end
  end

  return title
