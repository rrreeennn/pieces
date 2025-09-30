-- Board is used to display placed pieces
function createBoard(w, h)
    local board = {}

    for i = 1 , h do
        board[i] = {}
        
        for j = 1 , w do
            board[i][j] = 1
        end
    end

    return board
end