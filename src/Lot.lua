Lot = class('Lot')

local Manager = require 'src.Manager'

function Lot:initialize(left, top, image, quad)
  self.left = left
  self.top = top

  self.image = image
  self.quad = quad
end

function Lot:draw()
  --if self.transparent then print('Lot trans!') end
  love.graphics.drawq(self.image, self.quad, self.left, self.top - 80)
end

Building = class('Building', Lot)

function Building:initialize(left, top, width, height, image, quad)
  Lot.initialize(self, left, top, image, quad)

  self.polygon = HC:addPolygon(
    left, top + (height / 2),
    left + (width / 2), top,
    left + width, top + (height / 2),
    left + (width / 2), top + height)
  HC:setPassive(self.polygon)
  self.polygon.parent = self

  self.transparent = false
end

function Building:draw()
  if self.transparent then
    --print('Building trans!')
    love.graphics.setColor(255,255,255,125)
  else
    love.graphics.setColor(255,255,255)
  end
  love.graphics.drawq(self.image, self.quad, self.left, self.top - 80)
end

function Building:clean()
  HC:remove(self.polygon)
end

--Door = class('Door')

--function Door:initialize(left, top)
  --self.polygon = HC:addRectangle(left, top, 64, 70)
  --self.polygon.parent = self

  --HC:setPassive(self.polygon)
--end

--function Door:clean()
  --HC:remove(self.polygon)
--end

Hospital = class('Hospital', Building)

function Hospital:initialize(left, top, width, height, image, quad)
  Building.initialize(self, left, top, width, height, image, quad)

  --Manager:add(Door:new(left + 44, top + 143))
  --Manager:add(Door:new(left + 44 + 106, top + 143))
end
