function isPointInRectangle(pX, pY, sX, sY, sW, sH)
    return sX <= pX and pX <= sX + sW and sY <= pY and pY <= sY + sH
end