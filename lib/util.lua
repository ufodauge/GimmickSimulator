local utils = {}

-- 影付きでテキスト出力
function utils.print_with_shadow( text, x, y )
    love.graphics.setColor( 0.2, 0.2, 0.2, 1 )
    love.graphics.print( text, x + 1, y + 1 )
    love.graphics.print( text, x - 1, y + 1 )
    love.graphics.print( text, x + 1, y - 1 )
    love.graphics.print( text, x - 1, y - 1 )
    love.graphics.setColor( 1, 1, 1, 1 )
    love.graphics.print( text, x, y )
end

return utils
