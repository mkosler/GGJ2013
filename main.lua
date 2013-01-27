math.randomseed(os.time())
math.random(); math.random(); math.random();

require 'lib.middleclass'
GS = require 'lib.gamestate'

IMAGES = {
  BACKGROUND = {
    BUILDINGS    = love.graphics.newImage('assets/art/sheet_terrain.png'),
    INTERSECTION = love.graphics.newImage('assets/art/street_x.png')
  },
}

local function collision(dt, o1, o2, dx, dy)
  if o1.parent and o1.parent.collision then o1.parent:collision(o2.parent, dx, dy, dt) end
  if o2.parent and o2.parent.collision then o2.parent:collision(o1.parent, dx, dy, dt) end
end 

local function endCollision(dt, o1, o2)
  if o1.parent and o1.parent.endCollision then o1.parent:endCollision(o2, dt) end
  if o2.parent and o2.parent.endCollision then o2.parent:endCollision(o1, dt) end
end

Collider = require 'lib.HardonCollider'
HC = Collider(32)
HC:setCallbacks(collision, endCollision)

-- [[ ALL THE FILES!!!!!!!!!!! ]]
require 'src.Map'
require 'src.Lot'
require 'src.entity.Entity'
require 'src.entity.Zombie'
require 'src.entity.Player'
require 'src.entity.Bullet'
Title = require 'src.states.Title'
Play = require 'src.states.Play'
--Options = require 'src.states.Options'

function love.load()
  love.graphics.setBackgroundColor(104, 104, 104)

  GS.registerEvents()
  GS.switch(Play)
end
