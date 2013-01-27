local title = GS.new()

  function title:init()
    self.drawGrid = false

    self.colors = require 'lib.colors'
    self.gui = require 'lib.quickie'
    self.grid = require 'lib.quickie.grid'
	
	background=love.graphics.newImage("assets/art/title_screen_0.png")
  
	timer = 2

    self.debugName = "Title"
    -- print("init:\t\t " .. self.debugName)
  end

  function title:enter(previous)
	background=love.graphics.newImage("assets/art/title_screen_0.png")

    local gridschema = {
      columns = {150, 10, 300, 10, 150, 10, 150 },
      rows = {20, 60, 10, 30, 10, 30, 10, 30, 10, 30 },
      alignment = {
        horizontal = "center",
        vertical = "top"
      },
      margin = { left = 0, top = 275, right = 0, bottom = 0 }
    }
    self.grid:init(self.gui, gridschema)
    -- print("enter:\t\t " .. self.debugName)
  end

  function title:leave(previous)
    self.doExit = nil
    -- print("leave:\t\t " .. self.debugName .. "\n")
  end

  function title:update(dt)
    if self.doExit then return self.doExit() end

    local top = 50

	if(timer > 0) then
    timer = timer - dt
  end


    if self.grid:Button("Start Game", 3, 2, 1, 1, "menu") then
    	GS.switch(Play)
	end

    if self.grid:Button("Options", 3, 4, 1, 1, "menu") then
      GS.switch(TitleOptions)
    end

    if self.grid:Button("About", 3, 6, 1, 1, "menu") then
print(Credits)
      GS.switch(Credits)
    end

   if self.grid:Button("Instructions", 3, 8, 1, 1, "menu") then
print(Instructions)
      GS.switch(Instructions)
    end

  end

  function title:draw()
  love.graphics.draw(background)

if(timer < 0) then
love.graphics.setBackgroundColor(0,0,0) 
background=love.graphics.newImage("assets/art/mainlogo.png")

    self.gui.core.draw()
end

    if self.drawGrid then self.grid:TestDrawGrid() end
  end

  function title:keypressed(key, code)
    self.gui.core.keyboard.pressed(key, code)

    if key == "g" then
      self.drawGrid = not self.drawGrid
    end

    if key == "c" then
      self.doExit = function () return "credits" end
    end

    if key == "o" then
      self.doExit = function () return "titleoptions" end
    end

    if key == "escape" then
      love.event.push("quit")
    end

    -- print("keypressed:\t " .. self.debugName, key, code)
  end

  return title

