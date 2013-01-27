local Play = GS.new()

local Manager = require 'src.Manager'

local Camera = require 'lib.camera'
cam = Camera()


function Play:enter(prev)
  HC:clear()
  Manager:clear()

  m = Map()

  Manager:add(Zombie:new(500,500,10,2))
  Manager:add(Zombie:new(400,500,10,2))
  Manager:add(Zombie:new(200,500,10,2))
  Manager:add(Zombie:new(300,500,10,2))
  Manager:add(Zombie:new(100,500,10,2))
  local sx, sy = m:getSource()
  local dx, dy = m:getDestination()

  Manager:addPlayer(Player:new(sx, sy, 10, dx, dy))
end

function Play:update(dt)
  HC:update(dt)-- if collision is weird, put this at end
  Manager:update(dt)
   
  cam:lookAt(Manager.player:getPosition())
end

function Play:draw()
  cam:attach()
  love.graphics.setColor(255,255,255)
  m:draw()
  Manager:draw()
  cam:detach()
end

function Play:keypressed(key, code)
  Manager:keypressed(key, code)
end

function Play:keyreleased(key, code)
  Manager:keyreleased(key,code)
end

function Play:mousepressed(x, y, button)
  x, y = cam:worldCoords(x, y)
  Manager:mousepressed(x, y, button)
end

function Play:mousereleased(x, y, button)
  Manager:mousereleased(x, y, button)
end

function Play:leave()
end

return Play
