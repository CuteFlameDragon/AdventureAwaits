function love.load(arg)
  sprites = {}
  sprites.player = love.graphics.newImage("sprites/player.png")
  sprites.background = love.graphics.newImage("sprites/background.png")
  sprites.bullet = love.graphics.newImage("sprites/bullet.png")
  sprites.zombie = love.graphics.newImage("sprites/zombie.png")

  player = {}
  player.x = love.graphics.getWidth() / 2
  player.y = love.graphics.getHeight() / 2
  player.speed = 500

  bullets = {}

  zombies = {}
  stop = false
end


function love.update(dt)
  if love.keyboard.isDown("d") then
    player.x = player.x + player.speed * dt
  elseif love.keyboard.isDown("w") then
    player.y = player.y - player.speed * dt
  elseif love.keyboard.isDown("s") then
    player.y = player.y + player.speed * dt
  elseif love.keyboard.isDown("a") then
    player.x = player.x - player.speed * dt
  end

   updateZombies(dt)

   updateBullets(dt)

end

function love.draw()
  love.graphics.draw(sprites.background, 0, 0)
  drawZombies()
  drawPlayer()
  local i = 1

  while i <= #bullets do
    love.graphics.draw(sprites.bullet, bullets[i].x, bullets[i].y, nil, 0.5, 0.5,sprites.bullet:getWidth()/2, sprites.bullet:getHeight()/2)
    i = i + 1
  end
end

 function love.keypressed(key)
  if key == "space" then
     spawnZombies(1)
  end
end

function love.mousepressed(x, y, button)
  if button == 1 then
    spawnBullet()
  end
end

function getPlayerAngle()
  return math.atan2(player.y - love.mouse.getY(), player.x - love.mouse.getX()) + math.pi
end

function getZombieAngle(zombie)
  return math.atan2(player.y - zombie.y, player.x - zombie.x)
end

function spawnZombies(num)
  while num > 0 do
   local zombie = {}
   zombie.x = math.random(0, love.graphics.getWidth())
   zombie.y = math.random(0, love.graphics.getHeight())
   zombie.speed = 100
   table.insert(zombies, zombie)
   num = num - 1
 end
end

function spawnBullet()
  local bullet = {}
  bullet.x = player.x
  bullet.y = player.y
  bullet.speed = 1000
  bullet.direction = getPlayerAngle()
  table.insert(bullets, bullet)
end

function drawZombies()
  local count = 1
  local numberOfZombies = #zombies
  while count <= numberOfZombies do
    love.graphics.draw(sprites.zombie, zombies[count].x, zombies[count].y,getZombieAngle(zombies[count]), nil, nil,17.5 , 21.5)
    count = count + 1
  end
end

function drawPlayer()
  love.graphics.draw(sprites.player, player.x, player.y,  getPlayerAngle(), nil, nil, 17.5, 21.5)
end

function distanceBetween(x1, y1, x2, y2)
  return math.sqrt((y2-y1)^2 + (x2-x1)^2)
end

function updateZombies(dt)
  local count = 1
  local numberOfZombies = #zombies
  while count <= numberOfZombies and stop == false do
  local z = zombies[count]
  local angle = getZombieAngle(z)
  z.x = z.x + math.cos(angle) * z.speed * dt
  z.y = z.y + math.sin(angle) * z.speed * dt
  count = count + 1
  if distanceBetween(z.x, z.y, player.x, player.y) <1 then
    stop = true
  end
 end
end

function updateBullets(dt)
 local count = 1
 local numberOfBullets = #bullets
 while count <= numberOfBullets do
  local b = bullets[count]
  local angle = b.direction
  b.x = b.x + math.cos(angle) * b.speed * dt
  b.y = b.y + math.sin(angle) * b.speed * dt
  count = count + 1
  --if distanceBetween(z.x, z.y, b.x, b.y) <10 then
   --stop = true
 end
end
