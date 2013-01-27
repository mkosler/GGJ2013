local core = require((...):match("^(.+)%.[^%.]+") .. '.core')

return function(canvas, x, y, w, h, align, effect, draw)
	local id = core.generateID()

	core.registerDraw(id, draw or core.style.Canvas, canvas,x,y,w,h,align,effect)
	return false
end

