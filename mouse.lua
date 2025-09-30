Mouse = {}

Mouse.x, Mouse.y = love.mouse.getPosition()
Mouse.leftKeyPreviousState = nil
Mouse.leftKeyCurrentState = nil

Mouse.update = function (self)
    self.x, self.y = love.mouse.getPosition()
 
    self.leftKeyPreviousState = self.leftKeyCurrentState
    self.leftKeyCurrentState = love.mouse.isDown(1)
end

Mouse.isLeftKeyClicked = function (self)
    return self.leftKeyPreviousState and not self.leftKeyCurrentState
end

Mouse.isLeftKeyDown = function (self)
    return self.leftKeyCurrentState
end

Mouse.getPosition = function (self)
    return self.x, self.y
end