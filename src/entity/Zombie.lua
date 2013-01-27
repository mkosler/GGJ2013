Zombie = class('Zombie', Entity)
local speed=30
local spritesheet = love.graphics.newImage("assets/art/sheet_sprite_zombie_walk.png")
local down = love.graphics.newQuad(0, 0, 20, 40, 80, 80)
local up = love.graphics.newQuad(20, 0, 20, 40, 80, 80)
local left = love.graphics.newQuad(40, 0, 20, 40, 80, 80)
local right = love.graphics.newQuad(60, 0, 20, 40, 80, 80)

function Zombie:initialize(centerx, centery, radius, lives)
  Entity.initialize(self,centerx,centery,radius)
  self.lives = lives
  
  self.left = self.centerx - radius
  self.right = self.centerx + radius
  self.bottom = self.centery + radius
  self.top = self.bottom + 40
  self.imageCenterX = self.left + ((self.right - self.left)/2)
  self.imageCenterY = self.top + ((self.bottom - self.top)/2)
  
  self.timer = 0
  self.stunned = false
  
  self.hitcircle = HC:addCircle(self.centerx,self.centery,self.radius)
  --HC:addToGroup('Zombies',self.hitcircle)
  self.hitcircle.parent = self
  self.vx = 0
  self.vy = 0
  
  self.angle = 0

	if speed < 80 then
    speed = speed + level*5
	end
  
  self.quad = downright
end

--function Zombie:canRemove()
  --return self.removable
--end

--function Zombie:clean()
  --HC:remove(self.hitcircle)
--end

function Zombie:collision(o, dx, dy, dt)
	--change for building and people if have time	
  if not(self.stunned) then
    if(instanceOf(Zombie,o)) then
      o.stunned = true
      o.timer = 0.5
      o.vx = 0
      o.vy = 0
    elseif not(instanceOf(Bullet,o)) then
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
end

function Zombie:endCollision(o, dt)
end

function Zombie:update(dt, playerX, playerY)

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
    self.vx = speed * math.cos(self.angle)
    self.vy = speed * math.sin(self.angle)
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
    self.quad = up
  end
  if(-45 <= angleDeg and angleDeg  < 45) then
    self.quad = right
  end
  if(45 <= angleDeg and angleDeg < 135) then
    self.quad = down
  end
  if((135 < angleDeg and angleDeg <= 180) or (-180 <= angleDeg and angleDeg < -135)) then
    self.quad = left
  end
  
end

function Zombie:draw()
	-- love.graphics.setColor(168,133,37)
	-- love.graphics.rectangle("fill",self.left,self.top,self.right-self.left,self.bottom-self.top)
  -- love.graphics.circle("fill",self.hitcircle:outcircle())
  love.graphics.drawq(spritesheet,self.quad,self.left,self.top,0,1,1,0,0)
end
