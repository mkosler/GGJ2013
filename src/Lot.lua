Lot = class('Lot')

function Lot:initialize(left, top)
  self.left = left
  self.top = top
end

Building = class('Building', Lot)

function Building:initialize(left, top, width, height)
  print('Building:initialize')
  Lot.initialize(self, left, top)

  self.polygon = HC:addPolygon(
    left, top + (height / 2),
    left + (width / 2), top,
    left + width, top + (height / 2),
    left + (width / 2), top + height)
  HC:setPassive(self.polygon)
  self.polygon.parent = self
end

function Building:clean()
  HC:remove(self.polygon)
end

Hospital = class('Hospital', Building)

function Hospital:initialize(left, top, width, height)
  Building.initialize(self, left, top, width, height)
end
