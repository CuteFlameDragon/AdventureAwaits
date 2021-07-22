function love.load(arg)
  sprites = {}
  sprites.player = love.graphics.newImage("sprites/player.png")
  sprites.background = love.graphics.newImage("sprites/background.png")
  sprites.bullet = love.graphics.newImage("sprites/bullet.png")
  sprites.zombie = love.graphics.newImage("sprites/zombie.png")

  player = {}
  player.x = love.graphics.getWidth() / 2
  player.y = love.graphics.getHeight() / 2
  player.speed = 250

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

   delBullets(dt)

   for i,z in ipairs(zombies) do
      for i,b in ipairs(bullets) do
        if distanceBetween (z.x ,z.y, b.x, b.y) <15 then
          z.dead = true
          b.dead = true
        end
      end
    end

    for i=#zombies, 1, -1 do
      local z = zombies[i]
        if zombies.dead == true then
           table.remove(zombies, i)
        end
    end

    for i=#bullets, 1, -1 do
      local b = bullets[i]
        if bullets.dead == true then
           table.remove(bullets, i)
        end
    end

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
  pickUp()

  cleanUp()
end

function cleanUp()
  for index, zombie in ipairs(zombies) do
    if zombie.dead then
      table.remove(zombies, index)
    end
  end
end

function pickUp()
  for index, bullet in ipairs(bullets) do
    if bullet.dead then
      table.remove(bullets, index)
    end
  end
end

 function love.keypressed(key)
  if key == "space" then
     spawnZombies(333)
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
   local side = math.random(1, 4)

   if side == 1 then
     zombie.x = (0)
     zombie.y = math.random(0, love.graphics.getHeight())
   end

   if side == 2 then
     zombie.y = (0)
     zombie.x = math.random(0, love.graphics.getWidth())
   end

   if side == 3 then
     zombie.y = (love.graphics.getHeight())
     zombie.x = math.random(0, love.graphics.getWidth())
   end

   if side == 4 then
     zombie.x = (love.graphics.getWidth())
     zombie.y = math.random(0, love.graphics.getHeight())
   end

   zombie.speed = 75
   zombie.dead = false
   table.insert(zombies, zombie)
   num = num - 1
 end
end

function spawnBullet()
  local bullet = {}
  bullet.x = player.x
  bullet.y = player.y
  bullet.speed = 1000
  bullet.dead = false
  bullet.direction = getPlayerAngle()
  table.insert(bullets, bullet)
end

function drawZombies()
  local count = 1
  local numberOfZombies = #zombies
  while count <= numberOfZombies do
     if zombies[count].dead == false then
       love.graphics.draw(sprites.zombie, zombies[count].x, zombies[count].y,getZombieAngle(zombies[count]), nil, nil,17.5 , 21.5)
     end
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

    if distanceBetween(z.x, z.y, player.x, player.y) <10 then
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
   end
end

function delBullets(dt)
  for i=#bullets, 1 , -1 do
    local b = bullets[1]
    if b.x < 0 or b.y < 0 or b.y > 1000 or b.x > 1000 then
     table.remove(bullets, i)
    end
  end
end
