GMN.Originals = GMN.Originals or {}
function GMN.StoreOriginal( name, func )
    if GMN.Originals[name] then
        return GMN.Originals[name]
    end

    GMN.Originals[name] = func
    return func
end

function GMN.GetOriginal( name )
    return GMN.Originals[name]
end
