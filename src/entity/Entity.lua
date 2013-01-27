Entity = class('Entity')

function Entity:initialize(centerx, centery, radius)
  self.centerx = centerx
  self.centery = centery
  self.radius = radius

  self.removable = false
end

function Entity:collision(o, dx, dy, dt)
end

function Entity:endCollision(o, dt)
end

function Entity:update(dt)
end

function Entity:draw()
end

function Entity:canRemove()
  return self.removable
end

function Entity:clean()
  --print(self.hitcircle)
  HC:remove(self.hitcircle)
end

function Entity:mousepressed(x, y, button)
end

function Entity:mousereleased(x, y, button)
end
