GMN.originals["LocalPlayer"] = LocalPlayer
local LocalPlayer_ = LocalPlayer
local ply

function LocalPlayer()
    if ply then return ply end
    ply = LocalPlayer_()
    return ply
end
