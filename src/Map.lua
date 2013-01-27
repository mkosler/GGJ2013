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

  for i = 1, numBlockTypes do
    local row, col = 0, 0
    repeat
      row, col = math.random(size), math.random(size)
    until base[row][col] ~= 3
    base[row][col] = 3
  end

  --for _,v in ipairs(base) do print(table.concat(v, ' ')) end

  return base
end

local function setSprite(sb, x, y, quad)
  if quad then
    sb:addq(quad, x, y)
  else
    sb:add(x, y)
  end
end

local function setBuildingSpriteBatch(size, image, tw, th, data, quad)
  local sb = love.graphics.newSpriteBatch(image)

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
      setSprite(sb, x, y, quad[index])

      if index == 1 then
        Manager:add(Lot:new(x, y + 80))
      elseif index == 2 then
        Manager:add(Building:new(x, y + 80, tw, th))
      elseif index == 3 then
        Manager:add(Hospital:new(x, y + 80, tw, th))
      end
    end
  end

  return sb
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

  self.bsb = setBuildingSpriteBatch(self.size, bImg, 320, 160, self.data, self.quad)
  self.isb = setInterSpriteBatch(self.size, iImg, data)
end

function Map:draw()
  love.graphics.draw(self.isb)
  love.graphics.draw(self.bsb)
end

--Map = class('Map')

--local function buildSpriteBatches(data, size, lotImage, lotWidth, lotHeight, interImage, interWidth, interHeight)
  --local buildingSB = love.graphics.newSpriteBatch(lotImage)
  --local interSB = love.graphics.newSpriteBatch(interImage)

  --local hospitals = {}

  --for r = 0, size - 1 do
    --for c = 0, size - 1 do
      --if r % 2 == 0 then
        --if instanceOf(Hospital, data[r+1][c+1]) then
          --table.insert(hospitals, {
            --x = c * (lotWidth + interWidth),
            --y = r * (lotHeight + interHeight) / 2
          --})
        --end
        --buildingSB:addq(
          --data[r+1][c+1].quad,
          --c * (lotWidth + interWidth),
          --r * (lotHeight + interHeight) / 2)
        --interSB:add(
          --c * (lotWidth + interWidth),
          --r * (lotHeight + interHeight) / 2)
      --else
        --if instanceOf(Hospital, data[r+1][c+1]) then
          --table.insert(hospitals, {
            --x = c * (lotWidth + interWidth) - ((lotWidth + interWidth) / 2),
            --y = r * (lotHeight + interHeight) / 2
          --})
        --end
        --buildingSB:addq(
          --data[r+1][c+1].quad,
          --c * (lotWidth + interWidth) - ((lotWidth + interWidth) / 2),
          --r * (lotHeight + interHeight) / 2)
        --interSB:add(
          --c * (lotWidth + interWidth) - ((lotWidth + interWidth) / 2),
          --r * (lotHeight + interHeight) / 2)
      --end
    --end
  --end

  --return { buildingSB, interSB }, hospitals
--end

--function Map:initialize(size)
  --self.size = size or DEFAULT_SIZE
  --local buildingImage, interImage = IMAGES.BACKGROUND.BUILDINGS, IMAGES.BACKGROUND.INTERSECTION
  --self.data = randomize(self.size, buildQuads(buildingImage, NUMBER_OF_TILES, TILE_WIDTH, 240), TILE_WIDTH, TILE_HEIGHT)
  --self.sbs, self.hospitals = buildSpriteBatches(
    --self.data,
    --self.size,
    --buildingImage,
    --TILE_WIDTH,
    --TILE_HEIGHT,
    --interImage,
    --INTERSECTION_WIDTH,
    --INTERSECTION_HEIGHT)
--end

--function Map:getSource()
  --return self.hospitals[1]
--end

--function Map:getDestination()
  --return self.hospitals[2]
--end

--function Map:draw()
  --love.graphics.draw(self.sbs[2], 240, 0)
  --love.graphics.draw(self.sbs[1], 0, -80)
--end
