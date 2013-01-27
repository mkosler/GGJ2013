local core = require((...):match("^(.+)%.[^%.]+") .. '.core')

return function(text, x,y,w,h,align,font, draw)
	local id = core.generateID()
	w, h, align = w or 0, h or 0, align or 'left'
	core.registerDraw(id, draw or core.style.Label,  text,x,y,w,h,align,font)
	return false
end

