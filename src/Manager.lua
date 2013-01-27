local Manager = class('Manager')

function Manager:initialize()
  self.player = {}
  self.objects = {}
  self.blocks = {}
end

function Manager:add(o)
  table.insert(self.objects, o)
end

function Manager:addPlayer(p)
  self.player = p
end

function Manager:addBlock(b)
  print('Adding block')
  table.insert(self.blocks, b)
end

function Manager:remove(o)
  for i,v in pairs(self.objects) do
    if v == o then
      self:clean(i)
    end
  end
end

function Manager:clean(i)
  print(i, self.objects[i])
  if self.objects[i].clean then self.objects[i]:clean() end
  table.remove(self.objects, i)
end

function Manager:cleanBlock(i)
  if self.blocks[i].clean then self.blocks[i]:clean() end
  table.remove(self.blocks, i)
end

function Manager:update(dt)
  if self.player then self.player:update(dt) end

  for _,v in pairs(self.objects) do
    if v.update then v:update(dt, self.player:getPosition()) end
  end

  for i,v in pairs(self.objects) do
    if v.canRemove and v:canRemove() then self:clean(i) end
  end
end

function Manager:draw()
  if self.player then self.player:draw() end
  for _,v in pairs(self.objects) do
    if v.draw then v:draw() end
  end
end

function Manager:mousepressed(x, y, button)
  if self.player then self.player:mousepressed(x, y, button) end
end

function Manager:mousereleased(x, y, button)
  if self.player then self.player:mousereleased(x, y, button) end
end

function Manager:keypressed(key, code)
  if self.player then self.player:keypressed(key, code) end
end

function Manager:keyreleased(key, code)
  if self.player then self.player:keyreleased(key, code) end
end

function Manager:clear()
  if self.player.clean then self.player:clean() end
  for i,v in pairs(self.objects) do
    self:clean(i)
  end
  for i,v in pairs(self.blocks) do
    self:cleanBlock(i)
  end
end

local singleton = Manager:new()
return singleton
