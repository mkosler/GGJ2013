local BASE = (...) .. '.'

return {
	core     = require(BASE .. 'core'),
  Button   = require(BASE .. 'button'),
  Canvas   = require(BASE .. 'canvas'),
	Slider   = require(BASE .. 'slider'),
	Slider2D = require(BASE .. 'slider2d'),
	Label    = require(BASE .. 'label'),
	Input    = require(BASE .. 'input'),
	Checkbox = require(BASE .. 'checkbox')
}
