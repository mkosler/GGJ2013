local Options = GS.new()

function Options:enter(prev)
   //add options?
   Manager:add(Option:new(Sound, 1))
   Manager:add(Option:new(Exit, 2))
end

function Options:update(dt)
  //no update because just a menu...nothing moving??
end

function Options:draw()
  love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight()/2)
  love.graphics.getFont("Sounds")
  love.graphics.rectangle("fill", 0, love.graphics.getHeight()/2, love.graphics.getWidth(), love.graphics.getHeight()/2)
  love.graphics.getFont("Exit")
end

function Options:keypressed(key, code)
  if code == 1 then
    //take them to the sounds menu
  else if code == 2 then
    //exit options
end

function Options:keyreleased(key, code)
end

function Options:mousepressed(x, y, button)
  if(y <= love.graphics.getHeight()/2) then
    //take them to sounds menu
  else 
    //exit options menu
end

function Options:mousereleased(x, y, button)
end

function Options:leave()
end
