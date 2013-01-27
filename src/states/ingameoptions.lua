local title = GS.new()

  function title:init()
    self.drawGrid = false

    self.colors = require 'lib.colors'
    self.gui = require 'lib.quickie'
    self.grid = require 'lib.quickie.grid'

    self.view = love.graphics.newCanvas(800, 600)

    self.debugName = "In Game Options"
    -- print("init:\t\t " .. self.debugName)
  end

  function title:enter(previous)
	background=love.graphics.newImage("assets/art/mainlogo.png")

    local gridschema = {

      columns = {20, 200, 30, 200, 30, 200 },
      rows = { 80, 30, 30, 30, 30, 30, 80, 30 },
      alignment = {
        horizontal = "left",
        vertical = "top"
      },
      margin = { left = 55, top = 300, right = 0, bottom = 0 }
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

    self.grid:Label("Current Level: ", 4, 1, 1, 1, "center", "subtitle")
    if self.grid:Button("Upgrades ", 4,2,1,1, 'center', "menu") then
    	GS.switch(Upgrades)
    end
   
    self.grid:Label("Sound", 4, 3, 1, 1, "center", "menu")
    self.grid:Slider(self.sliders.x, 4, 4, 1, 1, false) 

 --   love.audio.setVolume(self.sliders.x.value)

    if self.grid:Button("Main Menu", 2,8,1,1, "menu") then
    	GS.switch(Title)
    end

    if self.grid:Button("Resume Play", 6, 8, 1, 1, "menu") then
      GS.switch(Play)
    end
  end

  function title:draw()
love.graphics.setColor(255, 255, 255)
	love.graphics.draw(background)
    self.gui.core.draw()

    if self.drawGrid then self.grid:TestDrawGrid() end
  end


  function title:keypressed(key, code)
    self.gui.core.keyboard.pressed(key, code)
    if key == "escape" then
      GS.switch(Play)
    end
    if key == "s" then
      print(self.sliders.x.value)
    end


    if key == "g" then
      self.drawGrid = not self.drawGrid
    end
  end

  return title
