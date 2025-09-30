require("values")
require("shakeable")

function createPiece(x, y, pieceQuad, n)
    local piece = {}
    piece.state = SHAKEABLE_STATE_IDLE
    piece.shakeState = 1
    piece.angle = 0
    piece.x = x
    piece.y = y
    piece.quad = pieceQuad

    piece.update = function (self)
        local mX, mY = Mouse:getPosition()
        mX = mX / SCALE
        mY = mY / SCALE

        local xA = self.x - PIECE_SIZE * 0.5
        local yA = self.y - PIECE_SIZE * 0.5

        if HOLDING_PIECE == nil and self.state ~= SHAKEABLE_STATE_HOVER and
            isPointInRectangle(mX, mY, xA, yA, PIECE_SIZE, PIECE_SIZE)
        then
            self.state = SHAKEABLE_STATE_HOVER
        elseif self.state ~= SHAKEABLE_STATE_IDLE and
            not isPointInRectangle(mX, mY, xA, yA, PIECE_SIZE, PIECE_SIZE)
        then
            self.state = SHAKEABLE_STATE_IDLE
            self.angle = 0
        end
    end

    piece.draw = function (self)
        love.graphics.draw(
            IMAGE_PIECES,
            self.quad,
            self.x, self.y,
            self.angle,
            1, 1,
            PIECE_SIZE * 0.5, PIECE_SIZE * 0.5
        )

        if self.state == SHAKEABLE_STATE_HOVER then
            if self.angle >= .15 or self.angle <= -.15 then
                self.shakeState = self.shakeState * -1
            end

            self.angle = self.angle + .01 * self.shakeState

            if Mouse:isLeftKeyDown() then
                HOLDING_PIECE = createFollowingPiece(n, self.quad)
            end
        end
    end

    return piece
end

function createFollowingPiece(n, pieceQuad)
    local piece = {}
    piece.n = n
    piece.quad = pieceQuad

    local xM, yM = Mouse:getPosition()
    piece.x = xM / SCALE
    piece.y = yM / SCALE

    piece.update = function(self)
        local x, y = Mouse:getPosition()
        self.x = x / SCALE
        self.y = y / SCALE
    end

    piece.draw = function(self)
        love.graphics.draw(
            IMAGE_PIECES,
            self.quad,
            self.x, self.y,
            self.angle,
            1, 1,
            PIECE_SIZE * 0.5, PIECE_SIZE * 0.5
        )
    end

    return piece
end