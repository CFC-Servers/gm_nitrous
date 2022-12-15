GMN = {
    originals = {}
}

local function includeDir( dir )
    for _, v in pairs( file.Find( dir .. "/*.lua", "LUA" ) ) do
        include( dir .. "/" .. v )
    end
end

if CLIENT then
    includeDir( "gmn/client" )
    includeDir( "gmn/shared" )
end

if SERVER then
    includeDir( "gmn/server" )
end
