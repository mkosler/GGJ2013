local Play = GS.new()

local Manager = require 'src.Manager'

local Camera = require 'lib.camera'
cam = Camera()

local gameover = love.graphics.newImage('assets/art/Game_Over_Screen.png')

function Play:enter(prev, lvl)
  level = lvl or 1

  HC:clear()
  Manager:clear()

  m = Map()

  local sx, sy = m:getSource()
  local dx, dy = m:getDestination()

  Manager:addPlayer(Player:new(sx, sy, 10, dx, dy))
end

function Play:update(dt)
  if Manager.player:canRemove() then
    return
  end

  HC:update(dt)-- if collision is weird, put this at end
  Manager:update(dt)
  if Manager.player.finished then
    print('finished')
    GS.switch(InGame, level + 1)
  end
   
  cam:lookAt(Manager.player:getPosition())
end

function Play:draw()
  cam:attach()
  love.graphics.setColor(255,255,255)
  m:draw()
  Manager:draw()
  cam:detach()
  --love.graphics.print(string.format('Memory (MB): %02.5f', collectgarbage('count') / 1024), 10, 10)
  if Manager.player:canRemove() then
    print(Manager.player:canRemove())
    love.graphics.draw(gameover)
  end
end

function Play:keypressed(key, code)
  if key == 'r' and Manager.player:canRemove() then
    GS.switch(Play, level)
  elseif key == 'escape' then
    GS.switch(Title)
  end
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
