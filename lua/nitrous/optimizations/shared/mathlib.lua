-- Locals
local math_abs = math.abs
local math_min = math.min
local math_max = math.max
local tonumber = tonumber
local math_sqrt = math.sqrt
local math_floor = math.floor
local math_AngleDifference = math.AngleDifference

-- math.Clamp
GMN.StoreOriginal( "math.Clamp", math.Clamp )

function math.Clamp( _in, low, high )
    return math_min( math_max( _in, low ), high )
end


-- math.BinToInt
GMN.StoreOriginal( "math.BinToInt", math.BinToInt )

function math.BinToInt( bin )
    return tonumber( bin, 2 )
end


-- math.Distance
GMN.StoreOriginal( "math.Distance", math.Distance )

function math.Distance( x1, y1, x2, y2 )
    local xd = x2 - x1
    local yd = y2 - y1
    return math_sqrt( xd * xd + yd * yd )
end
math["Dist"] = math.Distance -- brackets for gualint


-- math.Round
GMN.StoreOriginal( "math.Distance", math.Distance )

function math.Round( num, idp )
    local mult = 10 ^ ( idp or 0 )
    return math_floor( num * mult + 0.5 ) / mult
end


-- math.Approach
GMN.StoreOriginal( "math.Approach", math.Approach )

function math.Approach( cur, target, inc )
    inc = math_abs( inc )

    if ( cur < target ) then
        return math_min( cur + inc, target )
    elseif ( cur > target ) then
        return math_max( cur - inc, target )
    end

    return target
end

-- math.ApproachAngle
GMN.StoreOriginal( "math.ApproachAngle", math.ApproachAngle )
local math_Approach = math.Approach

function math.ApproachAngle( cur, target, inc )
    local diff = math_AngleDifference( target, cur )

    return math_Approach( cur, cur + diff, inc )
end
