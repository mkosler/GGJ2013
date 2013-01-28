local Manager = class('Manager')

local explosion = love.graphics.newImage("assets/art/stock_explosion.png")
local explosionsound = love.audio.newSource("assets/sound/Sound_Gun_Bazooka_Explosion.mp3")
local makeExplosion = false
local explodey
local exxplodex

function Manager:initialize()
  self.player = {}
  self.objects = {}
  self.blocks = {}

  self.zombieTimerMax = 5
  self.zombieTimer = self.zombieTimerMax
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
  if self.objects[i].clean then 
    self.objects[i]:clean() 
    if(instanceOf(Bullet,self.objects[i]) and self.objects[i].shouldExplode) then
      makeExplosion = true
      explodex = self.objects[i].centerx
      explodey = self.objects[i].centery
    end
  end
  table.remove(self.objects, i)
end

function Manager:cleanBlock(i)
  if self.blocks[i].clean then self.blocks[i]:clean() end
  table.remove(self.blocks, i)
end

local function sign()
  return math.random() < 0.5 and -1 or 1
end

function Manager:update(dt)
  if self.zombieTimer > 0 then
    self.zombieTimer = self.zombieTimer - dt*(level*2)
    if self.zombieTimer <= 0 then
      local halfwidth, halfheight =
        love.graphics.getWidth() / 2,
        love.graphics.getHeight() / 2
      local x, y = self.player.centerx + halfwidth * sign(), self.player.centery + halfheight * sign()
      self:add(Zombie:new(x, y, 10, 2))
      self.zombieTimer = self.zombieTimerMax
    end
  end
  if self.player then self.player:update(dt) end

  for _,v in pairs(self.objects) do
    if v.update then v:update(dt, self.player:getPosition()) end
  end

  for shape in pairs(HC:shapesInRange(self.player.centerx - 300, self.player.centery - 300, self.player.centerx + 300, self.player.centery + 300)) do
    if instanceOf(Building, shape.parent) then
      local l,t,r,b = shape.parent.left, shape.parent.top, shape.parent.left + 320, shape.parent.top + 160
      if l <= self.player.centerx and self.player.centerx <= r and
         t - 80 <= self.player.centery and self.player.centery <= b - 80 then
        shape.parent.transparent = true
      else
        shape.parent.transparent = false
      end
    end
  end

  for i,v in pairs(self.objects) do
    if v.canRemove and v:canRemove() then self:clean(i) end
  end
end

function Manager:draw()
  for _,v in pairs(self.blocks) do
    if v.draw then v:draw() end
  end

  for _,v in pairs(self.objects) do
    if v.draw then v:draw() end
  end

  if self.player then self.player:draw() end
  
  if(makeExplosion and explosionx and explosiony) then
    love.graphics.draw(explosion,explosionx,explosiony)
    makeExplosion = false
    explosionx = nil
    explosiony = nil
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

  self.player = {}
  self.objects = {}
  self.blocks = {}
end

local singleton = Manager:new()
return singleton
