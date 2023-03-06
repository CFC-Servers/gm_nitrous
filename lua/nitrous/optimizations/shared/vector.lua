local Vector = Vector
local math_Rand = math.Rand

GMN.StoreOriginal( "VectorRand", VectorRand )

function VectorRand( min, max )
    min = min or -1
    max = max or 1
    return Vector( math_Rand( min, max ), math_Rand( min, max ), math_Rand( min, max ) )
end
