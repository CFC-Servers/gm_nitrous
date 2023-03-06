local math_random = math.random

GMN.StoreOriginal( "math.Rand", math.Rand )

function math.Rand( low, high )
	return low + ( high - low ) * math_random()
end
