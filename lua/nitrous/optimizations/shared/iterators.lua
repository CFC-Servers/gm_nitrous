local next = next
local pairs = pairs
local rawget = rawget
local table_sort = table.sort
local table_insert = table.insert

local function getGeys( tbl )
    local keys = {}

    for k in pairs( tbl ) do
        table_insert( keys, k )
    end

    return keys
end

GMN.StoreOriginal( "SortedPairs", SortedPairs )
function SortedPairs( tbl, desc )
    local keys = getGeys( tbl )

    if desc then
        table_sort( keys, function( a, b )
            return a > b
        end )
    else
        table_sort( keys, function( a, b )
            return a < b
        end )
    end

    local i, key
    return function()
        i, key = next( keys, i )
        return key, rawget( tbl, key )
    end
end
