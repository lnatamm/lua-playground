function love.load()
    -- Imports
    anim8 = require 'libraries/anim8'
    love.graphics.setDefaultFilter("nearest", "nearest")
    
    -- Player Attributes
    player = {}
    player.x = 400
    player.y = 200
    player.speed = 1
    player.sprite = love.graphics.newImage('sprites/parrot.png')
    player.spriteSheet = love.graphics.newImage('sprites/player-sheet.png')
    player.grid = anim8.newGrid(12, 18, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())

    -- Player Animations
    player.animations = {}
    player.animations.down = anim8.newAnimation(player.grid('1-4', 1), 0.2)
    player.animations.left = anim8.newAnimation(player.grid('1-4', 2), 0.2)
    player.animations.right = anim8.newAnimation(player.grid('1-4', 3), 0.2)
    player.animations.up = anim8.newAnimation(player.grid('1-4', 4), 0.2)

    -- Standart Animation
    player.currentAnimation = player.animations.left

    -- Background
    background = love.graphics.newImage('sprites/background.png')
end

function love.update(dt)
    local isMoving = false

    if love.keyboard.isDown("right") then
        isMoving = true
        player.x = player.x + player.speed
        player.currentAnimation = player.animations.right
    end
    if love.keyboard.isDown("left") then
        isMoving = true
        player.x = player.x - player.speed
        player.currentAnimation = player.animations.left
    end
    if love.keyboard.isDown("up") then
        isMoving = true
        player.y = player.y - player.speed
        player.currentAnimation = player.animations.up
    end
    if love.keyboard.isDown("down") then
        isMoving = true
        player.y = player.y + player.speed
        player.currentAnimation = player.animations.down
    end
    if isMoving == false then
        -- Function to go to the standby frame of current animation
        player.currentAnimation:gotoFrame(2)
    end
    player.currentAnimation:update(dt)
end

function love.draw()
    love.graphics.draw(background, 0, 0)
    -- Scaling by 10 due to small spritesheet
    player.currentAnimation:draw(player.spriteSheet, player.x, player.y, nil, 10)
end