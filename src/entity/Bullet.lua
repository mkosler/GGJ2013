Bullet = class('Bullet',Entity)

function Bullet:initialize(startx, starty, vx, vy, damage, decaylimit, splashradius, terminatex, terminatey)
  Entity.initialize(self,startx,starty,3)
  
  self.left = startx - self.radius
  self.right = startx + self.radius
  self.top = starty - self.radius
  self.bottom = starty + self.radius
  
  self.beginx = startx
  self.beginy = starty
  
  self.vx = vx
  self.vy = vy
  
  self.hitcircle = HC:addCircle(self.centerx,self.centery,self.radius)
  self.hitcircle.parent = self
  
  self.decaylimit = decaylimit or 0
  self.decaytimer = 0
  
  self.damage = damage
  
  self.splashradius = splashradius or -1
  
  self.terminatex = terminatex
  self.terminatey = terminatey
  
  self.hasDamaged = false
  
end

function Bullet:collision(o, dx, dy, dt)
  if not(instanceOf(Player,o) or instanceOf(Bullet,o)) then
    self.removable=true
  end
  if(self.splashradius > 0 and (math.abs(self.centerx - self.beginx) > 5) and (math.abs(self.centery - self.beginy) > 5)) then
    for shape in pairs(HC:shapesInRange(self.centerx-self.splashradius,self.centery-self.splashradius,self.centerx+self.splashradius,self.centery+self.splashradius)) do
      if(instanceOf(Zombie,shape.parent)) then
        if((math.abs(self.centerx - shape.parent.centerx) < self.splashradius) and math.abs(self.centery - shape.parent.centery) < self.splashradius) then
          shape.parent.lives = shape.parent.lives - self.damage
        end
      end
    end
  end
end

function Bullet:endCollision(o, dt)
end


function Bullet:update(dt)
  --if (200 <= self.centerx and self.centerx <= 8800 and 200 <= self.centerx and self.centerx <= 2200) then
  topleftx, toplefty = cam:worldCoords(0,0)
  botrightx, botrighty = cam:worldCoords(9000,2400)
  if not(topleftx <= self.centerx and self.centerx <= botrightx and toplefty <= self.centery and self.centery<= botrighty) then
    self.removable=true
  end
  
  if(self.terminatex and self.terminatey) then
    if((math.abs(self.centerx - self.terminatex) < 5) and (math.abs(self.centery - self.terminatey) < 5)) then
      
      self.removable = true
      self:collision(o,0,0,0)
    end
  end
  
  self.decaytimer = self.decaytimer + dt
  if(self.decaylimit > 0 and self.decaytimer >= self.decaylimit) then
    self.removable=true
  end

  local xshift = (self.vx * dt)
  local yshift = (self.vy * dt)
  self.centerx = self.centerx + xshift
  self.centery = self.centery + yshift
  
  self.left = self.centerx - self.radius
  self.right = self.centerx + self.radius
  self.top = self.centery - self.radius
  self.bottom = self.centery + self.radius
  
  self.hitcircle:moveTo(self.centerx,self.centery)

  
  
end

function Bullet:draw()
  love.graphics.setColor(255,255,0)
   love.graphics.circle("fill", self.centerx, self.centery, self.radius)
end
