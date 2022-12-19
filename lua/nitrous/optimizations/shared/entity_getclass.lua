local meta = FindMetaTable( "Entity" )

meta.GMN_GetClass = GMN.StoreOriginal( "Entity:GetClass", meta.GetClass )

function meta:GetClass()
    local cached = self:GetTable().GMN_GetClassVar
    if cached then return cached end

    local id = self:GMN_GetClass()
    self.GMN_GetClassVar = id
    return id
end
