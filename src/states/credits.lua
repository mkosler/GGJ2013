local title = GS.new()

  function title:init()
    self.drawGrid = false

    self.colors = require 'lib.colors'
    self.gui = require 'lib.quickie'
    self.grid = require 'lib.quickie.grid'
	background=love.graphics.newImage("assets/art/mainlogo.png")

    self.debugName = "Credits"
  end

  function title:enter(previous)
	background=love.graphics.newImage("assets/art/mainlogo.png")

    local gridschema = {
      columns = { 200, 230, 200 },
      rows = { 100, 20, 60, 60, 30, 10, 30, 10, 30 },
      alignment = {
        horizontal = "center",
        vertical = "top"
      },
      margin = { left = 0, top = 130, right = 0, bottom = 0 }
    }
    self.grid:init(self.gui, gridschema)

  end

  function title:leave(previous)
    self.doExit = nil
  end

  function title:update(dt)
    if self.doExit then return self.doExit() end

	local top=50
	
	if self.grid:Button("Done", 2, 9, 1, 1, "menu") then
     GS.switch(Title)
    end
  end

  function title:draw()
  love.graphics.draw(background)
    self.gui.core.draw()
	love.graphics.setColor( 255, 255, 255)
	love.graphics.printf("Contributors:", 0, 255, 800, "center")
	love.graphics.printf("Anesh Patel: Programmer, Jonathan Williamson: Game Sound/Art, Marley Rainey: Game Art,\nMichael Kosler: Programmer, Nate Giles: Programmer, Niraj Patel: Programmer", 0, 275, 800, "center")
	
	love.graphics.printf("Created for: Global Game Jam 2013", 0, 330, 800, "center")
	love.graphics.printf("Theme: Heartbeat Sound", 0, 350, 800, "center")
	love.graphics.printf("Programming Language: Lau", 0, 370, 800, "center")
	
	love.graphics.printf("Documentation: http://goo.gl/dvvwz", 0, 405, 800, "center")


    if self.drawGrid then self.grid:TestDrawGrid() end
  end


  function title:keypressed(key, code)
    self.gui.core.keyboard.pressed(key, code)
    if key == "escape" then
      GS.switch(Title)
    end

    if key == "g" then
      self.drawGrid = not self.drawGrid
    end
  end

  return title
