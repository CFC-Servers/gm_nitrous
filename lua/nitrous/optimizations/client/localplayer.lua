local LocalPlayer_ = GMN.StoreOriginal( "LocalPlayer", LocalPlayer )
local ply

function LocalPlayer()
    if ply then return ply end
    ply = LocalPlayer_()
    if ply == NULL then
        ply = nil
        return NULL
    end
    return ply
end
