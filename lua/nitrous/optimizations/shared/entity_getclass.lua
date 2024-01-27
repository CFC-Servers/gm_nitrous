local meta = FindMetaTable( "Entity" )

meta.GMN_GetClass = GMN.StoreOriginal( "Entity:GetClass", meta.GetClass )
local getTable = meta.GetTable

function meta:GetClass()
    if self == NULL then return self:GMN_GetClass() end

    local cached = getTable( self ).GMN_GetClassVar
    if cached then return cached end

    local id = self:GMN_GetClass()
    self.GMN_GetClassVar = id
    return id
end
