require("values")
require("board")
require("piece")
require("settings")
require("mouse")
require("pointInRectangle")

local palette = {}
local boardX, boardY = 0, 0
local board = nil
local pieces = {}
local settings = nil

function love.load()
    -- source image can be replaced
    -- for example to "pieces_2.png"
    IMAGE_PIECES = love.graphics.newImage(RESOURCE_FOLDER ..  "pieces.png")
    IMAGE_PIECES:setFilter("nearest")

    IMAGE_SIZES = love.graphics.newImage(RESOURCE_FOLDER .. "sizes.png")
    IMAGE_SIZES:setFilter("nearest")

    local paletteCount = IMAGE_PIECES:getWidth() / PIECE_SIZE
    local t = WINDOW_WIDTH / ( SCALE * (paletteCount + 1) )
    local h = ( WINDOW_HEIGHT - WINDOW_HEIGHT * RATIO_PIECES * 0.5 ) / SCALE

    onSizeClick(BOARD_WIDTH)

    for i = 1 , paletteCount do
        local quad = love.graphics.newQuad( (i - 1) * PIECE_SIZE, 0, PIECE_SIZE, PIECE_SIZE, IMAGE_PIECES )
        palette[i] = quad
        pieces[i] = createPiece(t * i, h, quad, i)
    end

    settings = createSettings(onSizeClick, saveImage)

    love.graphics.setBackgroundColor(BACKGROUND_COLOR)
end

function love.update(dt)

    Mouse:update()

    settings:update()

    for i = 1 , #pieces do pieces[i]:update() end

    if HOLDING_PIECE ~= nil then
        HOLDING_PIECE:update()
        dropPieceUpdate()
    end
end

function love.draw()
    love.graphics.scale(SCALE)

    settings:draw()

    for i = 1 , BOARD_HEIGHT do
        for j = 1 , BOARD_WIDTH do
            love.graphics.draw(
                IMAGE_PIECES,
                palette[board[i][j]],
                (j - 1) * PIECE_SIZE + boardX,
                (i - 1) * PIECE_SIZE + boardY
            )
        end
    end

    for i = 1 , #pieces do pieces[i]:draw() end

    if HOLDING_PIECE ~= nil then HOLDING_PIECE:draw() end
end

function dropPieceUpdate()
    if not Mouse:isLeftKeyDown() then
        local mX, mY = Mouse:getPosition()
        mX = mX / SCALE
        mY = mY / SCALE
    
        if isPointInRectangle(mX, mY, boardX, boardY, BOARD_WIDTH * PIECE_SIZE, BOARD_HEIGHT * PIECE_SIZE)
        then
            local cX = math.floor(( mX - boardX ) / PIECE_SIZE ) + 1
            local cY = math.floor(( mY - boardY ) / PIECE_SIZE ) + 1

            board[cY][cX] = HOLDING_PIECE.n
        end

        HOLDING_PIECE = nil
    end
end

function onSizeClick(n)
    BOARD_HEIGHT = n
    BOARD_WIDTH = n
    board = createBoard(n, n)

    boardX = ( WINDOW_WIDTH - BOARD_WIDTH * PIECE_SIZE * SCALE ) * 0.5 / SCALE
    boardY = ( WINDOW_HEIGHT * RATIO_BOARD - BOARD_HEIGHT * PIECE_SIZE * SCALE ) * 0.5 / SCALE
end

function saveImage()
    local canvas = love.graphics.newCanvas(BOARD_WIDTH * PIECE_SIZE * SCALE, BOARD_HEIGHT * PIECE_SIZE * SCALE)
    love.graphics.setCanvas(canvas)

    for i = 1 , BOARD_HEIGHT do
        for j = 1 , BOARD_WIDTH do
            love.graphics.draw(
                IMAGE_PIECES,
                palette[board[i][j]],
                (j - 1) * PIECE_SIZE,
                (i - 1) * PIECE_SIZE
            )
        end
    end

    love.graphics.setCanvas()

    canvas:newImageData():encode("png","pego.png")
end