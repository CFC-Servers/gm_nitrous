local Material_ = GMN.StoreOriginal( "Material", Material )

local cache = {}

function Material( name, params )
    if params then return Material_( name, params ) end

    local cached = cache[name]
    if cached then return cached end

    cached = Material_( name )
    cache[name] = cached
    return cached
end
