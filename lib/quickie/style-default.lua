-- default style
local colorStack = require 'lib.colors'

local color = {
	normal = {bg = {28,28,28,255}, fg = {60,60,60,255}},
	hot    = {bg = {44,44,44,255}, fg = {224,224,224,255}},
	active = {bg = {28,28,28,255}, fg = {224,224,224,255}}
}

local fonts = {
	title = love.graphics.newFont("assets/fonts/visitor1.ttf", 120),
	subtitle = love.graphics.newFont("assets/fonts/visitor1.ttf", 30),
	plain = love.graphics.newFont("assets/fonts/visitor1.ttf", 20),
	menu = love.graphics.newFont("assets/fonts/visitor1.ttf", 18),
	center = love.graphics.newFont("assets/fonts/visitor1.ttf", 18)
}

local borderwidth = 0

local function Button(state, title, x,y,w,h, font)
	local c = color[state]
	if state ~= 'normal' then
		colorStack:push(unpack(c.fg))
		love.graphics.rectangle('fill', x+borderwidth,y+borderwidth,w,h)
		colorStack:pop()
	end
	colorStack:push(unpack(c.bg))
	love.graphics.rectangle('fill', x,y,w,h)
	colorStack:pop()

	colorStack:push(unpack(c.fg))
	local previousFont = love.graphics.getFont()
	local f = fonts[font]
  love.graphics.setFont(f)
	love.graphics.print(title, x + (w-f:getWidth(title))/2, y + (h-f:getHeight(title))/2)
	love.graphics.setFont(previousFont)
	colorStack:pop()
end

local function Image(state, image, quad, x,y,w,h,align)
	colorStack:push(255, 255, 255, 255)
	love.graphics.drawq(image, quad, x, y, w, h)
	colorStack:pop()
end

local function Label(state, text, x,y,w,h,align,font)
	local c = color[state]
	love.graphics.setColor(c.fg)
	local f = fonts[font]
	if align == 'center' then
		x = x + (w - f:getWidth(text))/2
		y = y + (h - f:getHeight(text))/2
	elseif align == 'right' then
		x = x + w - f:getWidth(text)
		y = y + h - f:getHeight(text)
	end
	local previousFont = love.graphics.getFont()
  love.graphics.setFont(f)
	love.graphics.print(text, x,y)
	love.graphics.setFont(previousFont)
end

local function Canvas(state, canvas, x, y, w, h, align,effect)
  love.graphics.setPixelEffect(effect)
	love.graphics.draw(canvas, x, y)
  love.graphics.setPixelEffect()
end

local function Slider(state, fraction, x,y,w,h, vertical)
	local c = color[state]
	if state ~= 'normal' then
		love.graphics.setColor(c.fg)
		love.graphics.rectangle('fill', x+borderwidth,y+borderwidth,w,h)
	end
	love.graphics.setColor(c.bg)
	love.graphics.rectangle('fill', x,y,w,h)

	love.graphics.setColor(c.fg)
	local hw,hh = w,h
	if vertical then
		hh = h * fraction
		y = y + (h - hh)
	else
		hw = w * fraction
	end
	love.graphics.rectangle('fill', x,y,hw,hh)
end

local function Slider2D(state, fraction, x,y,w,h, vertical)
	local c = color[state]
	if state ~= 'normal' then
		love.graphics.setColor(c.fg)
		love.graphics.rectangle('fill', x+borderwidth,y+borderwidth,w,h)
	end
	love.graphics.setColor(c.bg)
	love.graphics.rectangle('fill', x,y,w,h)

	-- draw quadrants
	local lw = love.graphics.getLineWidth()
	love.graphics.setLineWidth(1)
	love.graphics.setColor(c.fg[1], c.fg[2], c.fg[3], math.min(c.fg[4], 127))
	love.graphics.line(x+w/2,y, x+w/2,y+h)
	love.graphics.line(x,y+h/2, x+w,y+h/2)
	love.graphics.setLineWidth(lw)

	-- draw cursor
	local xx = x + fraction.x * w
	local yy = y + fraction.y * h
	love.graphics.setColor(c.fg)
	love.graphics.circle('fill', xx,yy,4,4)
end

local function Input(state, text, cursor, x,y,w,h)
	local c = color[state]
	if state ~= 'normal' then
		love.graphics.setColor(c.fg)
		love.graphics.rectangle('fill', x+borderwidth,y+borderwidth,w,h)
	end
	love.graphics.setColor(c.bg)
	love.graphics.rectangle('fill', x,y,w,h)
	love.graphics.setColor(c.fg)

	local lw = love.graphics.getLineWidth()
	love.graphics.setLineWidth(1)
	love.graphics.rectangle('line', x,y,w,h)

	local f = love.graphics.getFont()
	local th = f:getHeight(text)
	local cursorPos = x + 2 + f:getWidth(text:sub(1,cursor))

	love.graphics.print(text, x+2,y+(h-th)/2)
	love.graphics.line(cursorPos, y+4, cursorPos, y+h-4)

	love.graphics.setLineWidth(lw)
end

local function Checkbox(state, checked, x,y,w,h)
	local c = color[state]
	if state ~= 'normal' then
		love.graphics.setColor(c.fg)
		love.graphics.rectangle('fill', x+borderwidth,y+borderwidth,w,h)
	end
	love.graphics.setColor(c.bg)
	love.graphics.rectangle('fill', x,y,w,h)
	love.graphics.setColor(c.fg)
	love.graphics.rectangle('line', x,y,w,h)
	if checked then
		local r = math.max(math.min(w/2,h/2) - 3, 2)
		love.graphics.circle('fill', x+w/2,y+h/2,r)
	end
end


-- the style
return {
	color    = color,
	Button   = Button,
	Label    = Label,
	Canvas    = Canvas,
	Slider   = Slider,
	Slider2D = Slider2D,
	Input    = Input,
	Checkbox = Checkbox,
}
