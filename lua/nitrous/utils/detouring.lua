GMN.Originals = GMN.Originals or {}

--- Store the original function and return it
--- @param name string A unique name for the function
--- @param func function The function to store
function GMN.StoreOriginal( name, func )
    if GMN.Originals[name] then
        return GMN.Originals[name]
    end

    GMN.Originals[name] = func
    return func
end

--- Get the original function
--- @param name string The unique name of the function
function GMN.GetOriginal( name )
    return GMN.Originals[name]
end
