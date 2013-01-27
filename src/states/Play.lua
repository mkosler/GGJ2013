local Play = GS.new()

local Manager = require 'src.Manager'

local m = Map()

function Play:enter(prev)
  Manager:add(Zombie:new(500,500,10,2))
  Manager:add(Zombie:new(400,500,10,2))
  Manager:add(Zombie:new(200,500,10,2))
  Manager:add(Zombie:new(300,500,10,2))
  Manager:add(Zombie:new(100,500,10,2))
  Manager:addPlayer(Player:new(350,20,10))
end

function Play:update(dt)
  HC:update(dt)-- if collision is weird, put this at end
  Manager:update(dt)
   
end

function Play:draw()
  love.graphics.setColor(255,255,255)
  m:draw()
  Manager:draw()
end

function Play:keypressed(key, code)
  Manager:keypressed(key, code)
end

function Play:keyreleased(key, code)
  Manager:keyreleased(key,code)
end

function Play:mousepressed(x, y, button)
  Manager:mousepressed(x, y, button)
end

function Play:mousereleased(x, y, button)
  Manager:mousereleased(x, y, button)
end

function Play:leave()
end

return Play
