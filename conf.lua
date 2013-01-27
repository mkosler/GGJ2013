function love.conf(t)
  t.title = "ZOMBIES! Don't Panic!"
  t.authors = "Anesh Patel, Jonathan Williamson, Marley Rainey, Michael Kosler, Nate Giles, Niraj Patel"

  t.screen.width=800
  t.screen.height=600

  t.screen.vsync = false
  t.screen.fsaa = 0

  t.modules.audio = true
  t.modules.keyboard = true
  t.modules.event = true
  t.modules.image = true
  t.modules.graphics = true
  t.modules.timer = true
  t.modules.mouse = true
  t.modules.sound = true
  t.modules.physics = true
  t.modules.filesystem = true


  t.console = true

  -- global variable
  gWindow = {
    width = t.screen.width,
    height = t.screen.height
  }

end
