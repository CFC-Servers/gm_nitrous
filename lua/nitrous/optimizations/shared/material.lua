local Material_ = GMN.StoreOriginal( "Material", Material )

local cache = {}

function Material( name, params )
    local key = name .. (params or "")

    local cached = cache[key]
    if cached then return cached end

    cached = Material_( name, params )
    cache[key] = cached
    return cached
end
