Lot = class('Lot')

function Lot:initialize(left, top, image, quad)
  self.left = left
  self.top = top

  self.image = image
  self.quad = quad
end

function Lot:draw()
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
    love.graphics.setColor(255,255,255,75)
  else
    love.graphics.setColor(255,255,255)
  end
  love.graphics.drawq(self.image, self.quad, self.left, self.top - 80)
end

function Building:clean()
  HC:remove(self.polygon)
end

Hospital = class('Hospital', Building)

function Hospital:initialize(left, top, width, height, image, quad)
  Building.initialize(self, left, top, width, height, image, quad)
end
