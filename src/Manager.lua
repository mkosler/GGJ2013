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

  for shape in pairs(HC:shapesInRange(self.player.centerx - 300, self.player.centery - 300, self.player.centerx + 300, self.player.centery + 300)) do
    print(shape.parent)
    local l,t,r,b = shape.parent.left, shape.parent.top, shape.parent.left + 320, shape.parent.top + 160
    if l <= self.player.centerx and self.player.centerx <= r and
       t - 80 <= self.player.centery and self.player.centery <= b - 80 then
      shape.parent.transparent = true
    else
      shape.parent.transparent = false
    end
  end

  for i,v in pairs(self.objects) do
    if v.canRemove and v:canRemove() then self:clean(i) end
  end
end

function Manager:draw()
  for _,v in pairs(self.objects) do
    if v.draw then v:draw() end
  end
  for _,v in pairs(self.blocks) do
    if v.draw then v:draw() end
  end
  if self.player then self.player:draw() end
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
