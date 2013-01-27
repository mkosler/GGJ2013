local Manager = require 'src.Manager'

Player = class('Player',Entity)
local speed = 100
local bulletSpeed = 500
local spritesheet = love.graphics.newImage("assets/art/sheet_sprite_hero_walk.png")
local upleft = love.graphics.newQuad(0, 0, 20, 40, 80, 40)
local upright = love.graphics.newQuad(20, 0, 20, 40, 80, 40)
local downleft = love.graphics.newQuad(40, 0, 20, 40, 80, 40)
local downright = love.graphics.newQuad(60, 0, 20, 40, 80, 40)

function Player:initialize(centerx, centery, radius, safespotx, safespoty)
  print('Player:initialize', centerx, centery, radius, safespotx, safespoty)
  Entity.initialize(self, centerx, centery, radius)
  
  self.left = self.centerx - radius
  self.right = self.centerx + radius
  self.bottom = self.centery + radius
  self.top = self.bottom + 40
  self.imageCenterX = self.left + ((self.right - self.left)/2)
  self.imageCenterY = self.top + ((self.bottom - self.top)/2)
  self.angle = 0
  
  self.hitcircle = HC:addCircle(self.centerx,self.centery,self.radius)
  self.hitcircle.parent = self
  
  self.weapon = "pistol"
  
  self.bulletTimer = 0
  
  self.panic = 100
  
  self.heartbeatPace = 2
  self.heartbeatTimer = 0
  self.heartbeatSound = love.audio.newSource("assets/sound/Sound_Heartbeat_Single_Speed_1.mp3")
  self.heartbeat1 = self.heartbeatSound
  self.heartbeat2 = love.audio.newSource("assets/sound/Sound_Heartbeat_Single_Speed_2.mp3")
  self.heartbeat3 = love.audio.newSource("assets/sound/Sound_Heartbeat_Single_Speed_3.mp3")
  self.heartbeat4 = love.audio.newSource("assets/sound/Sound_Heartbeat_Single_Speed_4.mp3")
  self.heartFlash = false
  self.flashThreshold = 0.1
  
  self.nearbyEnemies = {}
  
  self.vx = 0
  self.vy = 0
  self.leftMouseHeld = false
  self.handleCollision = false
  px = self.imageCenterX
  py = self.imageCenterY
  
  self.safespotx = safespotx or 340
  self.safespoty = safespoty or 500
  
  self.arrowpointer = love.graphics.newImage("assets/art/ui_arrow.png")
  self.heroquad = downright
end

function Player:collision(o, dx, dy, dt)
  print(o)
  if (not(instanceOf(Bullet,o)) and (self.vx > 0 or self.vy > 0)) then
  self.centerx = self.centerx + dx
  self.centery = self.centery + dy
  -- self.vx = -100*dx
  -- self.vy = -100*dy
  -- self.handleCollision = true
  -- self.bulletTimer = 0.1
  end
end

function Player:endCollision(o, dt)
end

function Player:getPosition() 
  return self.imageCenterX, self.bottom
end

function Player:update(dt)
  if(self.panic < 0) then -- PLAYER DIES!
    self.heartbeatSound = nil
    self.removable = true
  end

  if(self.panic >= 75) then
    self.heartbeatSound = self.heartbeat1
  end
  
  if(self.panic >= 50 and self.panic < 75) then
    self.heartbeatSound = self.heartbeat2
  end
  
  if(self.panic >= 25 and self.panic < 50) then
    self.heartbeatSound = self.heartbeat3
  end
  
  if(self.panic < 25) then
    self.heartbeatSound = self.heartbeat4
  end
  
  
  if((self.panic/100) > 0.2) then
    self.heartbeatPace = 2 * (self.panic/100)
  else
    self.heartbeatPace = 0.45
  end
  
  local angleDeg = math.deg(self.angle)
  if(-180 <= angleDeg and angleDeg < -90) then
    self.heroquad = upleft
  end
  if(-90 <= angleDeg and angleDeg  < 0) then
    self.heroquad = upright
  end
  if(0 <= angleDeg and angleDeg < 90) then
    self.heroquad = downright
  end
  if(90 <= angleDeg and angleDeg < 180) then
    self.heroquad = downleft
  end
    
  
  
 -- print("heartbeat cap", self.heartbeatPace)
  --print("heartbeat timer", self.heartbeatTimer)
  
  if(self.heartbeatTimer < self.heartbeatPace) then
    self.heartbeatTimer = self.heartbeatTimer + dt
  else 
    self.heartbeatTimer = 0
    if(self.heartbeatSound) then love.audio.play(self.heartbeatSound) end
    self.heartFlash = true
  end
  
  if(self.heartbeatTimer > self.flashThreshold) then
    self.heartFlash = false
  end
  
  if(self.panic > 0) then
    for shape in pairs(HC:shapesInRange(self.centerx-100,self.centery-100,self.centerx+100,self.centery+100)) do
      if(instanceOf(Zombie,shape.parent)) then
        local a = math.abs(self.centerx - shape.parent.centerx)
        a = a*a
        local b = math.abs(self.centery - shape.parent.centery)
        b = b*b
        local distance = math.sqrt(a+b)
        --print("distance ",distance)
        --print("panic influence", (100/distance) * dt)
        self.panic = self.panic - ((100/distance) * dt)
      end
    end
  end
 -- print("Panic ", self.panic)

  if(self.bulletTimer > 0) then
    self.bulletTimer = self.bulletTimer - dt
  else 
    if(self.fireHeld) then
      local cameracenterx, cameracentery = cam:cameraCoords(self.centerx,self.centery)
      local xdiff =  love.mouse.getX() - cameracenterx
      local ydiff = love.mouse.getY() - cameracentery
      print(love.mouse.getX(), love.mouse.getY(), xdiff, ydiff)
      local angle = math.atan2(ydiff,xdiff)
      local vx = bulletSpeed * math.cos(angle)
      local vy = bulletSpeed * math.sin(angle)
      if(self.weapon == 'pistol') then
        Manager:add(Bullet:new(self.centerx,self.centery,vx,vy,1))
        self.bulletTimer = 0.25
        self.fireHeld = false
      end
      if(self.weapon == 'smg') then
        Manager:add(Bullet:new(self.centerx,self.centery,vx,vy,1))
        self.bulletTimer = 0.07
      end
      if(self.weapon == 'shotgun') then
        self.fireHeld = false
        self.bulletTimer = 0.4
        Manager:add(Bullet:new(self.centerx,self.centery,vx,vy,1,0.5))
        local origangle = angle
        angle = origangle + math.rad(5)
        vx = bulletSpeed * math.cos(angle)
        vy = bulletSpeed * math.sin(angle)
        Manager:add(Bullet:new(self.centerx,self.centery,vx,vy,1,0.5))
        angle = origangle + math.rad(10)
        vx = bulletSpeed * math.cos(angle)
        vy = bulletSpeed * math.sin(angle)
        Manager:add(Bullet:new(self.centerx,self.centery,vx,vy,1,0.5))
        angle = origangle - math.rad(10)
        vx = bulletSpeed * math.cos(angle)
        vy = bulletSpeed * math.sin(angle)
        Manager:add(Bullet:new(self.centerx,self.centery,vx,vy,1,0.5))
        angle = origangle - math.rad(5)
        vx = bulletSpeed * math.cos(angle)
        vy = bulletSpeed * math.sin(angle)
        Manager:add(Bullet:new(self.centerx,self.centery,vx,vy,1,0.5))
      end
      if(self.weapon == 'flame') then
        Manager:add(Bullet:new(self.centerx,self.centery,vx,vy,0.1,0.3))
        self.bulletTimer = 0.03
      end
      if(self.weapon == 'rifle') then
        Manager:add(Bullet:new(self.centerx,self.centery,3*vx,3*vy,10))
        self.bulletTimer = 1.5
      end
      if(self.weapon == 'bazooka') then
        Manager:add(Bullet:new(self.centerx,self.centery,0.75*vx,0.75*vy,10,10,7,love.mouse.getX(),love.mouse.getY()))
        self.bulletTimer = 2.5
      end
    end
  end

  if(self.leftMouseHeld) then
      px, py = cam:worldCoords(love.mouse.getPosition())
  end
  if not px or not py or not (200 <= px and px <= 8800 and 200 <= py and py <= 2200) then
    self.vx, self.vy = 0, 0
    return
  end
  if(px and py and (math.abs(px - self.imageCenterX) > 5 or math.abs(py - self.imageCenterY) > 5)) then
    local xdiff =  px - self.imageCenterX
    local ydiff = py - self.imageCenterY
    self.angle = math.atan2(ydiff,xdiff)
    self.vx = speed * math.cos(self.angle)
    self.vy = speed * math.sin(self.angle)
  else
    self.vx = 0
    self.vy = 0
    px = nil
    py = nil
  end
  
  --print(self.angle)
  local xshift = (self.vx * dt)
  local yshift = (self.vy * dt)
  self.centerx = self.centerx + xshift
  self.centery = self.centery + yshift
  self.left = self.centerx - self.radius
  self.right = self.centerx + self.radius
  self.bottom = self.centery
  self.top = self.bottom - 40
  self.imageCenterX = self.left + ((self.right - self.left)/2)
  self.imageCenterY = self.top + ((self.bottom - self.top)/2)
  self.hitcircle:moveTo(self.centerx,self.centery)
end

function Player:draw()
  love.graphics.setColor(255,255,255)
  local angleToSafe = math.atan2((self.safespoty - self.centery),(self.safespotx - self.centerx))
  --love.graphics.rectangle("fill",self.left,self.top,self.right-self.left,self.bottom-self.top)
  --love.graphics.setColor(255,0,0)
  --love.graphics.circle("fill",self.hitcircle:outcircle())
  love.graphics.draw(self.arrowpointer,self.imageCenterX,self.imageCenterY,angleToSafe,1,1,0,self.arrowpointer:getWidth()/2)
  if(self.heartFlash) then
    love.graphics.setColor(redscale,0,0)
  else
    love.graphics.setColor(255,255,255)
  end
  love.graphics.drawq(spritesheet,self.heroquad,self.left,self.top,0,1,1,0,0)
  --love.graphics.draw(self.heroimg,self.left,self.top,0,1,1,0,0)
  love.graphics.circle("fill",340,500,10)
  love.graphics.setColor(255,255,255)
end

function Player:mousepressed(x, y, button)
  if(button == 'l') then
    self.leftMouseHeld = true
  end
  
end

function Player:mousereleased(x, y, button)
  if(button == 'l') then
    self.leftMouseHeld = false
  end
end

function Player:keypressed(key,code)
 
  if(key == ' ') then
    self.fireHeld = true
  end
end

function Player:keyreleased(key,code)
  if(key == ' ') then
    self.fireHeld = false
  end
end
