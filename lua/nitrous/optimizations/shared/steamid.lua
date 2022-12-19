local meta = FindMetaTable( "Player" )

meta.GMN_SteamID = GMN.StoreOriginal( "Player:SteamID", meta.SteamID )

function meta:SteamID()
    local cached = self:GetTable().GMN_SteamIDVar
    if cached then return cached end

    local id = self:GMN_SteamID()
    self.GMN_SteamIDVar = id
    return id
end

meta.GMN_SteamID64 = GMN.StoreOriginal( "Player:SteamID64", meta.SteamID64 )

function meta:SteamID64()
    local cached = self:GetTable().GMN_SteamID64Var
    if cached then return cached end

    local id = self:GMN_SteamID64()
    self.GMN_SteamID64Var = id
    return id
end
