GMN.StoreOriginal( "game.SinglePlayer", game.SinglePlayer )

local isSP = game.SinglePlayer()
function game.SinglePlayer()
    return isSP
end

GMN.StoreOriginal( "game.IsDedicated", game.IsDedicated )

local isDedicated = game.IsDedicated()
function game.IsDedicated()
    return isDedicated
end
