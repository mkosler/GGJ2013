Bullet = class('Bullet',Entity)

function Bullet:initialize(startx, starty, vx, vy, damage, decaylimit, splashradius, terminatex, terminatey)
  Entity.initialize(self,startx,starty,4)
  
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
  print("bullet collision")
  if not(instanceOf(Player,o)) then
    self.removable=true
  end
  if(self.splashradius > 0 and (math.abs(self.centerx - self.beginx) > 5) and (math.abs(self.centery - self.beginy) > 5)) then
    print(self.splashradius)
    for shape in pairs(HC:shapesInRange(self.centerx-self.splashradius,self.centery-self.splashradius,self.centerx+self.splashradius,self.centery+self.splashradius)) do
      print("loop reached")
       
      if(instanceOf(Zombie,shape.parent)) then
        print("nearby object is a zombie")
        print(self.centerx)
        print(shape.parent.centerx)
        print(self.splashrdius)
        print(self.centery)
        print(shape.parent.centery)
        if((math.abs(self.centerx - shape.parent.centerx) < self.splashradius) and math.abs(self.centery - shape.parent.centery) < self.splashradius) then
          print("suffering damage")
          shape.parent.lives = shape.parent.lives - self.damage
        end
      end
    end
  end
end

function Bullet:endCollision(o, dt)
end


function Bullet:update(dt)
  if (self.centerx < 0 or self.centerx > love.graphics.getWidth() or self.centery < 0 or self.centery > love.graphics.getHeight()) then
    self.removable=true
  end
  
  if(self.terminatex and self.terminatey) then
    print("termination check reached")
    print(self.centerx)
    print(self.terminatex)
    print(math.abs(self.centerx - self.terminatex))
    print(self.centery)
    print(self.terminatey)
    print(math.abs(self.centery - self.terminatey))
    if((math.abs(self.centerx - self.terminatey) < 50) and (math.abs(self.centery - self.terminatey) < 50)) then
      
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
  
  self.hitcircle:moveTo(self.centerx,self.centery)

  
  
end

function Bullet:draw()
  love.graphics.setColor(255,255,0)
   love.graphics.circle("fill", self.centerx, self.centery, self.radius)
end
