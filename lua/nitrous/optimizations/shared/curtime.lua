local CurTime_ = GMN.StoreOriginal( "CurTime", CurTime )

local time = CurTime()

function CurTime()
    return time
end

if SERVER then
    hook.Add( "Tick", "GMN_CurTime", function()
        time = CurTime_()
    end )
end

if CLIENT then
    hook.Add( "Tick", "GMN_CurTime", function()
        time = CurTime_()
    end )
end
