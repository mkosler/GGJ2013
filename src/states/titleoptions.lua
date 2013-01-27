local title = GS.new()

  function title:init()
    self.drawGrid = false

    self.colors = require 'lib.colors'
    self.gui = require 'lib.quickie'
    self.grid = require 'lib.quickie.grid'
    self.view = love.graphics.newCanvas(812, 764)
	background=love.graphics.newImage("assets/art/mainlogo.png")

    self.debugName = "Options"
    -- print("init:\t\t " .. self.debugName)
  end

  function title:enter(previous)
	background=love.graphics.newImage("assets/art/mainlogo.png")

    local gridschema = {

      columns = { 20, 200, 10, 100, 10, 812 },
      rows = { 20, 20, 10, 20, 10, 20, 10, 538 },
      alignment = {
        horizontal = "left",
        vertical = "top"
      },
      margin = { left = 250, top = 300, right = 130, bottom = 130 }
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

    self.grid:Slider(self.sliders.x, 2, 3, 1, 1, false) 
    self.grid:Label("Sound", 2, 1, 1, 1, "center", "menu")
    self.grid:Label("\n\nStart Level: ___", 2, 3, 1, 1, 'center', "menu")

 --   love.audio.setVolume(self.sliders.x)

    if self.grid:Button("Done", 2, 7, 1, 1, "menu") then
      GS.switch(Title)
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
      self.doExit = function () return self.parent end
    end
    if key == "s" then
      print(self.sliders.x.value)
      print(self.sliders.y.value)
      print(self.sliders.z.value)
    end


    if key == "g" then
      self.drawGrid = not self.drawGrid
    end
  end

  return title