local meta = FindMetaTable( "Entity" )

meta.GMN_LookupBone = GMN.StoreOriginal( "Entity:LookupBone", meta.LookupBone )
local lookupBone = meta.LookupBone

function meta:LookupBone( boneName )
    local cache = self.GMN_LookupBoneCache
    if not cache then
        cache = {}
        self.GMN_LookupBoneCache = cache
    end

    
    -- If an entity's model changes, surely their bones will too
    -- We can cache per-model, or we can detect when it changes and clear their cache
    local modelName = self:GetModel()
    local modelCache = cache[modelName]
    if not modelCache then
        modelCache = {}
        cache[modelName] = modelCache
    end

    local cached = modelCache[boneName]
    if cached then return cached end
    
    local result = self:GMN_LookupBone( boneName )
    modelCache[boneName] = result
    
    return result
end
