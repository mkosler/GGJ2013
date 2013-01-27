Zombie = class('Zombie', Entity)
local speed=30
local spritesheet = love.graphics.newImage("assets/art/sheet_sprite_zombie_walk.png")
local down = love.graphics.newQuad(0, 40, 20, 40, 80, 80)
local up = love.graphics.newQuad(20, 40, 20, 40, 80, 80)
local left = love.graphics.newQuad(40, 40, 20, 40, 80, 80)
local right = love.graphics.newQuad(60, 40, 20, 40, 80, 80)
local down2 = love.graphics.newQuad(0, 0, 20, 40, 80, 80)
local up2 = love.graphics.newQuad(20, 0, 20, 40, 80, 80)
local left2 = love.graphics.newQuad(40, 0, 20, 40, 80, 80)
local right2 = love.graphics.newQuad(60, 0, 20, 40, 80, 80)

function Zombie:initialize(centerx, centery, radius, lives)
  Entity.initialize(self,centerx,centery,radius)
  self.lives = lives
  self.speed = speed * lives
  
  self.left = self.centerx - radius
  self.right = self.centerx + radius
  self.bottom = self.centery + radius
  self.top = self.bottom + 40
  self.imageCenterX = self.left + ((self.right - self.left)/2)
  self.imageCenterY = self.top + ((self.bottom - self.top)/2)
  
  self.timer = 0
  self.frameTimer = 0
  self.stunned = false
  
  self.facing = 'd'
  
  self.hitcircle = HC:addCircle(self.centerx,self.centery,self.radius)
  --HC:addRectangle(self.left,self.top,self.right,self.bottom)
  self.hitcircle.parent = self
  self.vx = 0
  self.vy = 0
  
  self.angle = 0

  self.quad = down
end

function Zombie:collision(o, dx, dy, dt)
  if not(self.stunned) then
    if(instanceOf(Zombie,o)) then
      o.stunned = true
      o.timer = 0.5
      o.vx = 0
      o.vy = 0
    elseif not(instanceOf(Bullet,o) or instanceOf(Building, o)) then
    self.timer = 0.5
    self.stunned = true
    self.vx = 0
    self.vy = 0
    end
  end
  
  if(instanceOf(Bullet, o) and not(o.hasDamaged)) then
    o.hasDamaged = true
    self.lives=self.lives-o.damage
  end

  if self.lives<=0 then
    self.removable=true
  end

  self.centerx = self.centerx + dt * dx * 4
  self.centery = self.centery + dt * dy * 4
end

function Zombie:endCollision(o, dt)
end

function Zombie:update(dt, playerX, playerY)

  if (self.frameTimer > (1/6)) then
    self.frameTimer = 0
  else
    self.frameTimer = self.frameTimer + dt
  end

  if(self.timer > 0) then
    self.timer = self.timer - dt
    if(self.timer <= 0 ) then
      self.stunned = false
    end
  end

  if not(self.stunned) then
    local diffX= playerX-self.centerx
    local diffY = playerY-self.bottom
    self.angle = math.atan2(diffY,diffX)
    self.vx = self.speed * math.cos(self.angle)
    self.vy = self.speed * math.sin(self.angle)
  end
  
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
  
 
  local angleDeg = math.deg(self.angle)
  if(-135 <= angleDeg and angleDeg < -45) then
    self.facing = 'u'
  end
  if(-45 <= angleDeg and angleDeg  < 45) then
    self.facing = 'r'
  end
  if(45 <= angleDeg and angleDeg < 135) then
    self.facing = 'd'
  end
  if((135 < angleDeg and angleDeg <= 180) or (-180 <= angleDeg and angleDeg < -135)) then
    self.facing = 'l'
  end
      
  if(self.facing == "u") then
    if(self.quad == up  and self.frameTimer==0 and ((math.abs(self.vx) > 0) or (math.abs(self.vy) > 0))) then
      self.quad = up2
    else
      if(self.frameTimer == 0) then
        self.quad = up
      end
    end
    if(self.vx == 0 and self.vy == 0) then
      self.quad = up
    end
  end
  if(self.facing == 'r') then
    if(self.quad == right and self.frameTimer==0 and ((math.abs(self.vx) > 0) or (math.abs(self.vy) > 0))) then
      self.quad = right2
    else
      if(self.frameTimer == 0) then
        self.quad = right
      end
    end
    if(self.vx == 0 and self.vy == 0) then
      self.quad = right
    end
  end
  if(self.facing == 'd') then
    if(self.quad == down and self.frameTimer==0 and ((math.abs(self.vx) > 0) or (math.abs(self.vy) > 0))) then
      self.quad = down2
    else
      if(self.frameTimer == 0) then
        self.quad = down
      end
    end
    if(self.vx == 0 and self.vy == 0) then
      self.quad = down
    end
  end
  if(self.facing == 'l') then
    if(self.quad == left and self.frameTimer==0 and ((math.abs(self.vx) > 0) or (math.abs(self.vy) > 0))) then
      self.quad = left2
    else
      if(self.frameTimer == 0) then
        self.quad = left
      end
    end
    if(self.vx == 0 and self.vy == 0) then
      self.quad = left
    end
  end
  
end

function Zombie:draw()
  love.graphics.drawq(spritesheet,self.quad,self.left,self.top,0,1,1,0,0)
end
