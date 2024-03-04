local RealTime = RealTime
local matMeta = FindMetaTable( "IMaterial" )
local SetVector = matMeta.SetVector
local SetFloat = matMeta.SetFloat
local SetInt = matMeta.SetInt
local SetTexture = matMeta.SetTexture

local skyPaint

local init = function()
    skyPaint = g_SkyPaint
end

local bind = function( _, mat )
    local values = skyPaint:GetNetworkVars()

    SetVector( mat, "$TOPCOLOR", values.TopColor )
    SetVector( mat, "$BOTTOMCOLOR", values.BottomColor )
    SetVector( mat, "$DUSKCOLOR", values.DuskColor )
    SetFloat( mat, "$DUSKSCALE", values.DuskScale )
    SetFloat( mat, "$DUSKINTENSITY", values.DuskIntensity )
    SetFloat( mat, "$FADEBIAS",	values.FadeBias )
    SetFloat( mat, "$HDRSCALE",	values.HDRScale )

    SetVector( mat, "$SUNNORMAL", values.SunNormal )
    SetVector( mat, "$SUNCOLOR", values.SunColor )
    SetFloat( mat, "$SUNSIZE", values.SunSize )

    if values.DrawStars then
        SetInt( mat, "$STARLAYERS",	values.StarLayers )
        SetFloat( mat, "$STARSCALE", values.StarScale )
        SetFloat( mat, "$STARFADE",	values.StarFade )
        SetFloat( mat, "$STARPOS", values.StarSpeed * RealTime() )
        SetTexture( mat, "$STARTEXTURE", values.StarTexture )
    else
        SetInt( mat, "$STARLAYERS", 0 )
    end
end

local function replace()
    matproxy.Add( {
        name = "SkyPaint",
        init = init,
        bind = bind
    } )
end

hook.Add( "InitPostEntity", "Nitrous_SkyPaint", replace )
replace()
