local rawget = rawget
local net_ReadHeader = net.ReadHeader
local util_NetworkIDToString = util.NetworkIDToString
local IsValid = IsValid
local Entity = Entity
local IsColor = IsColor
local Color = Color
local assert = assert
local pairs = pairs
local type = type
local net_ReadBit = net.ReadBit
local net_WriteUInt = net.WriteUInt
local net_ReadUInt = net.ReadUInt
local net_ReadString = net.ReadString
local TypeID = TypeID
local net_ReadType = function() end -- Gets set at the end of the file
local net_WriteType = function() end -- Gets set at the end of the file

-- Writes
local net_WriteString = net.WriteString
local net_WriteDouble = net.WriteDouble
local net_WriteTable = net.WriteTable
local net_WriteBool = net.WriteBool
local net_WriteEntity = net.WriteEntity
local net_WriteVector = net.WriteVector
local net_WriteAngle = net.WriteAngle
local net_WriteMatrix = net.WriteMatrix
local net_WriteColor = net.WriteColor

-- Reads
local net_ReadBool = net.ReadBool
local net_ReadEntity = net.ReadEntity
local net_ReadTable = net.ReadTable
local net_ReadVector = net.ReadVector
local net_ReadAngle = net.ReadAngle
local net_ReadMatrix = net.ReadMatrix
local net_ReadColor = net.ReadColor
local net_ReadDouble = net.ReadDouble

TYPE_COLOR = 255

net.Receivers = {}
local receivers = net.Receivers

--
-- Set up a function to receive network messages
--
function net.Receive( name, func )
    receivers[name:lower()] = func
end

--
-- A message has been received from the network..
--
function net.Incoming( len, client )
    local i = net_ReadHeader()
    local strName = util_NetworkIDToString( i )
    if not strName then return end
    local func = rawget( receivers, strName:lower() )
    if not func then return end
    --
    -- len includes the 16 bit int which told us the message name
    --
    len = len - 16
    func( len, client )
end

--
-- Read/Write a boolean to the stream
--
net.WriteBool = net.WriteBit
net_WriteBool = net.WriteBit

function net.ReadBool()
    return net_ReadBit() == 1
end
net_ReadBool = net.ReadBool

--
-- Read/Write an entity to the stream
--
function net.WriteEntity( ent )
    if not IsValid( ent ) then
        net_WriteUInt( 0, 16 )
    else
        net_WriteUInt( ent:EntIndex(), 16 )
    end
end
net_WriteEntity = net.WriteEntity

function net.ReadEntity()
    local i = net_ReadUInt( 16 )
    if not i then return end

    return Entity( i )
end
net_ReadEntity = net.ReadEntity

--
-- Read/Write a color to/from the stream
--
function net.WriteColor( col, writeAlpha )
    if writeAlpha == nil then
        writeAlpha = true
    end

    assert( IsColor( col ), "net.WriteColor: color expected, got " .. type( col ) )
    local r, g, b, a = col:Unpack()
    net_WriteUInt( r, 8 )
    net_WriteUInt( g, 8 )
    net_WriteUInt( b, 8 )

    if writeAlpha then
        net_WriteUInt( a, 8 )
    end
end
net_WriteColor = net.WriteColor

function net.ReadColor( readAlpha )
    if readAlpha == nil then
        readAlpha = true
    end

    local r, g, b = net_ReadUInt( 8 ), net_ReadUInt( 8 ), net_ReadUInt( 8 )
    local a = 255

    if readAlpha then
        a = net_ReadUInt( 8 )
    end

    return Color( r, g, b, a )
end
net_ReadColor = net.ReadColor

--
-- Write a whole table to the stream
-- This is less optimal than writing each
-- item indivdually and in a specific order
-- because it adds type information before each var
--
function net.WriteTable( tab )
    for k, v in pairs( tab ) do
        net_WriteType( k )
        net_WriteType( v )
    end

    net_WriteType( nil )
end
net_WriteTable = net.WriteTable

function net.ReadTable()
    local tab = {}

    while true do
        local k = net_ReadType()
        if k == nil then return tab end
        tab[k] = net_ReadType()
    end
end
net_ReadTable = net.ReadTable

net.WriteVars = {
    [TYPE_NIL] = function( t ) net_WriteUInt( t, 8 ) end,
    [TYPE_STRING] = function( t, v ) net_WriteUInt( t, 8 ) net_WriteString( v ) end,
    [TYPE_NUMBER] = function( t, v ) net_WriteUInt( t, 8 ) net_WriteDouble( v ) end,
    [TYPE_TABLE] = function( t, v ) net_WriteUInt( t, 8 ) net_WriteTable( v ) end,
    [TYPE_BOOL] = function( t, v ) net_WriteUInt( t, 8 ) net_WriteBool( v ) end,
    [TYPE_ENTITY] = function( t, v ) net_WriteUInt( t, 8 ) net_WriteEntity( v ) end,
    [TYPE_VECTOR] = function( t, v ) net_WriteUInt( t, 8 ) net_WriteVector( v ) end,
    [TYPE_ANGLE] = function( t, v ) net_WriteUInt( t, 8 ) net_WriteAngle( v ) end,
    [TYPE_MATRIX] = function( t, v ) net_WriteUInt( t, 8 ) net_WriteMatrix( v ) end,
    [TYPE_COLOR] = function( t, v ) net_WriteUInt( t, 8 ) net_WriteColor( v ) end,
}

local WriteVars = net.WriteVars

function net.WriteType( v )
    local typeid = nil

    if IsColor( v ) then
        typeid = TYPE_COLOR
    else
        typeid = TypeID( v )
    end

    local wv = rawget( WriteVars, typeid )
    if wv then return wv( typeid, v ) end
    error( "net.WriteType: Couldn't write " .. type( v ) .. " (type " .. typeid .. ")" )
end
net_WriteType = net.WriteType

net.ReadVars = {
    [TYPE_NIL] = function() return nil end,
    [TYPE_STRING] = function() return net_ReadString() end,
    [TYPE_NUMBER] = function() return net_ReadDouble() end,
    [TYPE_TABLE] = function() return net_ReadTable() end,
    [TYPE_BOOL] = function() return net_ReadBool() end,
    [TYPE_ENTITY] = function() return net_ReadEntity() end,
    [TYPE_VECTOR] = function() return net_ReadVector() end,
    [TYPE_ANGLE] = function() return net_ReadAngle() end,
    [TYPE_MATRIX] = function() return net_ReadMatrix() end,
    [TYPE_COLOR] = function() return net_ReadColor() end,
}

local ReadVars = net.ReadVars

function net.ReadType( typeid )
    typeid = typeid or net_ReadUInt( 8 )
    local rv = rawget( ReadVars, typeid )
    if rv then return rv() end
    error( "net.ReadType: Couldn't read type " .. typeid )
end
net_ReadType = net.ReadType
