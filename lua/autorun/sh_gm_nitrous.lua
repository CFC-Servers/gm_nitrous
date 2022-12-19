GMN = {}

local function includeDir( dir )
    for _, v in pairs( file.Find( dir .. "/*.lua", "LUA" ) ) do
        include( dir .. "/" .. v )
    end
end

local function addcsluaDir( dir )
    for _, v in pairs( file.Find( dir .. "/*.lua", "LUA" ) ) do
        AddCSLuaFile( dir .. "/" .. v )
    end
end

includeDir( "nitrous/utils" )
includeDir( "nitrous/optimizations/shared" )

if CLIENT then
    includeDir( "nitrous/optimizations/client" )
end

if SERVER then
    includeDir( "nitrous/optimizations/server" )

    addcsluaDir( "nitrous/optimizations/client" )
    addcsluaDir( "nitrous/optimizations/shared" )
    addcsluaDir( "nitrous/utils" )
end
