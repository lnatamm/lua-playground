function love.load()
    -- Imports
    anim8 = require 'libraries/anim8'
    sti = require 'libraries/sti'
    camera = require 'libraries/camera'
    wf = require 'libraries/windfield'
    cam = camera()
    love.graphics.setDefaultFilter("nearest", "nearest")

    gameMap = sti('maps/testMap.lua')

    world = wf.newWorld(0, 0)

    -- Player Attributes
    player = {}
    player.x = 400
    player.y = 200
    player.collider = world:newBSGRectangleCollider(player.x, player.y, 50, 100, 10)
    player.collider:setFixedRotation(true)
    player.speed = 300
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

    walls = {}
    if gameMap.layers["Walls"] then
    for i, obj in pairs(gameMap.layers["Walls"].objects) do
        if obj.width > 0 and obj.height > 0 then -- Add this check
            local wall = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            wall:setType('static')
            table.insert(walls, wall)
        end
    end
end
    
end

function love.update(dt)
    local isMoving = false
    local vx = 0
    local vy = 0

    if love.keyboard.isDown("right") then
        isMoving = true
        vx = player.speed
        player.currentAnimation = player.animations.right
    end
    if love.keyboard.isDown("left") then
        isMoving = true
        vx = -player.speed
        player.currentAnimation = player.animations.left
    end
    if love.keyboard.isDown("up") then
        isMoving = true
        vy = -player.speed
        player.currentAnimation = player.animations.up
    end
    if love.keyboard.isDown("down") then
        isMoving = true
        vy = player.speed
        player.currentAnimation = player.animations.down
    end
    
    player.collider:setLinearVelocity(vx, vy)

    if isMoving == false then
        -- Function to go to the standby frame of current animation
        player.currentAnimation:gotoFrame(2)
    end
    world:update(dt)
    player.x = player.collider:getX()
    player.y = player.collider:getY()
    
    player.currentAnimation:update(dt)
    
    cam:lookAt(player.x, player.y)
    local windowWidth = love.graphics.getWidth()
    local windowHeight = love.graphics.getHeight()

    if cam.x < windowWidth/2 then
        cam.x = windowWidth/2
    end

    if cam.y < windowHeight/2 then
        cam.y = windowHeight/2
    end

    local mapWidth = gameMap.width * gameMap.tilewidth
    local mapHeight = gameMap.height * gameMap.tileheight

    if cam.x > (mapWidth - windowWidth/2) then
        cam.x = (mapWidth - windowWidth/2)
    end

    if cam.y > (mapHeight - windowHeight/2) then
        cam.y = (mapHeight - windowHeight/2)
    end

end

function love.draw()
    cam:attach()
        gameMap:drawLayer(gameMap.layers['Ground'])
        gameMap:drawLayer(gameMap.layers['Trees'])
        player.currentAnimation:draw(player.spriteSheet, player.x, player.y, nil, 6, nil, 6, 9)
        world:draw()
    cam:detach()
end