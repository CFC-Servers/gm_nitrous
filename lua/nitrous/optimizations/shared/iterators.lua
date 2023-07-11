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

local function getKeyValues( tbl )
    local keyValues = {}

    for k, v in pairs( tbl ) do
        table_insert( keyValues, { k, v } )
    end

    return keyValues
end

function GMN.SortedPairs( tbl, desc )
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

function GMN.SortedPairsByValue( tbl, desc )
    local keyValues = getKeyValues( tbl )

    if desc then
        table_sort( keyValues, function( a, b )
            return a[2] > b[2]
        end )
    else
        table_sort( keyValues, function( a, b )
            return a[2] < b[2]
        end )
    end

    local i, keyValue
    return function()
        i, keyValue = next( keyValues, i )
        if not keyValue then return end

        return keyValue[1], keyValue[2]
    end
end
