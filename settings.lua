require("values")
require("shakeable")

function createSettings(onSizeClick, saveImage)
    local count = IMAGE_SIZES:getWidth() / PIECE_SIZE + 3
    local w = WINDOW_WIDTH / ( SCALE * count )

    return createShakeable(
        w, 10,
        PIECE_SIZE, PIECE_SIZE,
        --init
        function (shakeable)
            shakeable.image = love.graphics.newImage(RESOURCE_FOLDER .. "settings.png")
            shakeable.image:setFilter("nearest")
            shakeable.isOpen = false
            shakeable.tools = {}

            for i = 2, 10 do
                table.insert(
                    shakeable.tools,
                    createSizeIcons(i * w, 10, i + 2, onSizeClick)
                )
            end

            table.insert(
                shakeable.tools,
                createSaveIcon(w * (#shakeable.tools + 2), 10, saveImage)
            )
        end,
        --update
        function (self)
            if self.isOpen then
                for i = 1, #self.tools do self.tools[i]:update() end
            end
        end,
        --draw
        function (self)
            love.graphics.draw(
                self.image,
                self.x, self.y,
                self.angle,
                1, 1,
                PIECE_SIZE * 0.5, PIECE_SIZE * 0.5
            )

            if self.isOpen then
                for i = 1, #self.tools do self.tools[i]:draw() end
            end
        end,
        --onClick
        function (self)
            self.isOpen = not self.isOpen
        end
    )
end

function createSizeIcons(x, y, n, onClick)
    return createShakeable(
        x, y,
        PIECE_SIZE, PIECE_SIZE,
        --init
        function (shakeable)
            shakeable.quad = love.graphics.newQuad( 
                (n - 4) * PIECE_SIZE, 0,
                PIECE_SIZE, PIECE_SIZE,
                IMAGE_SIZES
            )
        end,
        --update
        function (self) end,
        --draw
        function (self)
            love.graphics.draw(
                IMAGE_SIZES,
                self.quad,
                self.x, self.y,
                self.angle,
                1, 1,
                PIECE_SIZE * 0.5, PIECE_SIZE * 0.5
            )
        end,
        --onClick
        function (self)
            onClick(n)
        end
    )
end

function createSaveIcon(x, y, saveImage)
    return createShakeable(
        x, y,
        PIECE_SIZE, PIECE_SIZE,
        --init
        function (shakeable)
            shakeable.image = love.graphics.newImage(RESOURCE_FOLDER .. "save.png")
            shakeable.image:setFilter("nearest")
        end,
        --update
        function (self) end,
        --draw
        function (self)
            love.graphics.draw(
                self.image,
                self.x, self.y,
                self.angle,
                1, 1,
                PIECE_SIZE * 0.5, PIECE_SIZE * 0.5
            )
        end,
        --onClick
        function (self)
            saveImage()
        end
    )
end