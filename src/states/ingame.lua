return function (state)

  function state:init()
    self.drawGrid = false

    self.colors = require 'lib.colors'
    self.gui = require 'lib.quickie'
    self.grid = require 'lib.quickie.grid'

    self.shader = {}
    self.shader.source = love.filesystem.read("/shaders/noise.frag")
    self.shader.effect = love.graphics.newPixelEffect(self.shader.source)

    self.view = love.graphics.newCanvas(812, 764)
  end


  function state:enter(previous)
    local gridschema = {

      columns = { 20, 200, 10, 100, 10, 812 },
      rows = { 20, 20, 10, 20, 10, 20, 10, 538 },
      alignment = {
        horizontal = "left",
        vertical = "top"
      },
      margin = { left = 0, top = 0, right = 0, bottom = 0 }
    }
    local width = self.grid:init(self.gui, gridschema)

    self.sliders = {
      x = {value = self.view:getHeight() / 1024},
      y = {value = self.view:getWidth() / 1024},
      z = {value = 2.5}
    }
    self.shader.effect:send("xOffset", self.sliders.x.value)
    self.shader.effect:send("yOffset", self.sliders.y.value)
    self.shader.effect:send("zOffset", self.sliders.z.value)
  end


  function state:leave(previous)
    self.doExit = nil
  end


  function state:update(dt)
    if self.doExit then
      -- love.event.push("quit")
      return self.parent
    end


    if self.grid:Slider(self.sliders.x, 2, 2, 1, 1, false) then
      self.shader.effect:send("xOffset", self.sliders.x.value)
    end

    self.grid:Label("x", 4, 2, 1, 1, "left", "menu")

    if self.grid:Slider(self.sliders.y, 2, 4, 1, 1, false) then
      self.shader.effect:send("yOffset", self.sliders.y.value)
    end

    self.grid:Label("y", 4, 4, 1, 1, "left", "menu")

    if self.grid:Slider(self.sliders.z, 2, 6, 1, 1, false) then
      self.shader.effect:send("zOffset", self.sliders.z.value)
    end

    self.grid:Label("z", 4, 6, 1, 1, "left", "menu")

    self.grid:Canvas(self.view, 6, 1, 1, 8, "center", self.shader.effect)

  end


  function state:draw()
    if self.resetView then
      love.graphics.setCanvas(self.view)
      self.view:clear()
      self.colors:pushRandom()
      love.graphics.rectangle("fill", 0, 0, self.view:getWidth(), self.view:getHeight())
      self.colors:pop()
      love.graphics.setCanvas()
      self.resetView = false
    end


    self.gui.core.draw()

    if self.drawGrid then self.grid:TestDrawGrid() end
  end


  function state:keypressed(key, code)
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

  return state

end
