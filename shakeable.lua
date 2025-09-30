require("mouse")
require("values")
require("pointInRectangle")

function createShakeable(x, y, w, h, init, update, draw, onClick)
    local shakeable = {}
    shakeable.x = x
    shakeable.y = y
    shakeable.state = SHAKEABLE_STATE_IDLE
    shakeable.shakeDirection = 1
    shakeable.angle = 0

    init(shakeable)

    shakeable.update = function (self)
        local mX, mY = Mouse:getPosition()
        mX = mX / SCALE
        mY = mY / SCALE

        local dx, dy = self.x - w * 0.5, self.y - h * 0.5

        if self.state == SHAKEABLE_STATE_HOVER then
            if not isPointInRectangle(mX, mY, dx, dy, w, h) then
                self.state = SHAKEABLE_STATE_IDLE
                self.angle = 0
            end

            if self.angle >= .15 or self.angle <= -.15 then
                self.shakeDirection = -self.shakeDirection
            end

            self.angle = self.angle + .01 * self.shakeDirection

            if Mouse:isLeftKeyClicked() then onClick(self) end
        else
            if HOLDING_PIECE == nil and isPointInRectangle(mX, mY, dx, dy, w, h) then
                self.state = SHAKEABLE_STATE_HOVER
            end
        end

        update(self)
    end

    shakeable.draw = draw

    return shakeable
end