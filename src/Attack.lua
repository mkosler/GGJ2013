Attack = class('Attack')

function Attack:initialize(left, top, right, bottom)
  self.left = left
  self.top = top
  self.right = right
  self.bottom = bottom
end

function Attack:collision(o, dx, dy, dt)
   if not instanceOf(Player, o) then
      self.removable = true
   end
end

function Attack:endCollision(o, dt)
end

function Attack:update(dt)
   sum = sum + 1/dt;
   if sum == 2/dt then
      self.removable = true
   end
end

function Attack:draw()
end
