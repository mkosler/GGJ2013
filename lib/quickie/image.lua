local core = require((...):match("^(.+)%.[^%.]+") .. '.core')

return function(image, quad, x,y,w,h,align, draw)
	local id = core.generateID()
	w, h, align = w or 0, h or 0, align or 'center'
	core.registerDraw(id, draw or core.style.Image,  text,x,y,w,h,align)
	return false
end

