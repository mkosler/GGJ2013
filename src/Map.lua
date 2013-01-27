require 'src.Lot'

local Manager = require 'src.Manager'

Map = class('Map')

local function buildQuads(image, number, tw, th)
  local quads = {}

  for i = 0, number - 1 do
    table.insert(quads,
      love.graphics.newQuad(
        i * tw,
        0,
        tw,
        th,
        image:getWidth(),
        image:getHeight()))
  end

  return quads
end

local function randomize(size, numBlockTypes)
  local base = {}

  for r = 1, size do
    base[r] = {}
    for c = 1, size do
      base[r][c] = math.random(numBlockTypes - 1)
    end
  end

  for i = 1, 2 do
    local row, col = 0, 0
    repeat
      row, col = math.random(size), math.random(size)
    until base[row][col] ~= 3 and 3 < row and row < 17 and 3 < col and col < 17
    base[row][col] = 3
  end

  return base
end

local function setSprite(sb, x, y, quad)
  if quad then
    sb:addq(quad, x, y)
  else
    sb:add(x, y)
  end
end

local function setBuildings(size, image, tw, th, data, quad)
  local hospitals = {}

  for r = 0, size - 1 do
    for c = 0, size - 1 do
      local x, y = 0, 0
      if r % 2 == 0 then
        x = (c * 480)
        y = (r * 120)
      else
        x = 240 + (c * 480)
        y = (r * 120)
      end

      local index = data[r+1][c+1]

      if index == 1 then
        Manager:addBlock(Lot:new(x, y + 80, image, quad[index]))
      elseif index == 2 then
        Manager:addBlock(Building:new(x, y + 80, tw, th, image, quad[index]))
      elseif index == 3 then
        table.insert(hospitals, { x = x, y = y + 80 })
        local hospital = Hospital:new(x, y + 80, tw, th, image, quad[index])
        Manager:addBlock(hospital)
        if #hospitals == 1 then
          hospital:setName('Source')
        elseif #hospitals == 2 then
          hospital:setName('Destination')
        end
      end
    end
  end

  return hospitals
end

local function setInterSpriteBatch(size, image, data)
  local sb = love.graphics.newSpriteBatch(image)

  for r = 0, size - 1 do
    for c = 0, size - 1 do
      local x, y = 0, 0
      if r % 2 == 0 then
        x = 240 + (c * 480)
        y = (r * 120)
      else
        x = (c * 480)
        y = (r * 120)
      end
      setSprite(sb, x, y + 80)
    end
  end

  return sb
end

function Map:initialize(size)
  self.size = size or 20

  local bImg, iImg = IMAGES.BACKGROUND.BUILDINGS, IMAGES.BACKGROUND.INTERSECTION

  self.quad = buildQuads(bImg, 3, 320, 240)
  self.data = randomize(self.size, 3)

  self.hospitals = setBuildings(self.size, bImg, 320, 160, self.data, self.quad)
  self.isb = setInterSpriteBatch(self.size, iImg, data)
end

function Map:draw()
  love.graphics.draw(self.isb)
end

function Map:getSource()
  return self.hospitals[1].x, self.hospitals[1].y
end

function Map:getDestination()
  return self.hospitals[2].x, self.hospitals[2].y
end
