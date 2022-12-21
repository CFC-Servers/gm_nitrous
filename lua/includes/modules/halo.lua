local table_IsEmpty = table.IsEmpty
local table_insert = table.insert
local render_GetRenderTarget = render.GetRenderTarget
local render_CopyRenderTargetToTexture = render.CopyRenderTargetToTexture
local render_Clear = render.Clear
local cam_Start3D = cam.Start3D
local render_SetStencilEnable = render.SetStencilEnable
local render_SuppressEngineLighting = render.SuppressEngineLighting
local cam_IgnoreZ = cam.IgnoreZ
local render_SetStencilWriteMask = render.SetStencilWriteMask
local render_SetStencilTestMask = render.SetStencilTestMask
local render_SetStencilReferenceValue = render.SetStencilReferenceValue
local render_SetStencilCompareFunction = render.SetStencilCompareFunction
local render_SetStencilPassOperation = render.SetStencilPassOperation
local render_SetStencilFailOperation = render.SetStencilFailOperation
local render_SetStencilZFailOperation = render.SetStencilZFailOperation
local render_DrawScreenQuad = render.DrawScreenQuad
local hook_Run = hook.Run
local cam_Start2D = cam.Start2D
local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawRect = surface.DrawRect
local render_BlurRenderTarget = render.BlurRenderTarget
local render_SetRenderTarget = render.SetRenderTarget
local render_SetMaterial = render.SetMaterial
local cam_End2D = cam.End2D
local cam_End3D = cam.End3D
local halo_Render
local IsValid = IsValid
local ipairs = ipairs

halo = halo or {}

local mat_Copy = Material( "pp/copy" )
local mat_Add = Material( "pp/add" )
local mat_Sub = Material( "pp/sub" )
local rt_Store = render.GetScreenEffectTexture( 0 )
local rt_Blur = render.GetScreenEffectTexture( 1 )
local List = {}
local RenderEnt = NULL

function halo.Add( entities, color, blurx, blury, passes, add, ignorez )
    if table_IsEmpty( entities ) then return end

    if add == nil then
        add = true
    end

    if ignorez == nil then
        ignorez = false
    end

    local t = {
        Ents = entities,
        Color = color,
        Hidden = when_hidden,
        BlurX = blurx or 2,
        BlurY = blury or 2,
        DrawPasses = passes or 1,
        Additive = add,
        IgnoreZ = ignorez
    }

    table_insert( List, t )
end

function halo.RenderedEntity()
    return RenderEnt
end

function halo.Render( entry )
    local rt_Scene = render_GetRenderTarget()
    -- Store a copy of the original scene
    render_CopyRenderTargetToTexture( rt_Store )

    -- Clear our scene so that additive/subtractive rendering with it will work later
    if entry.Additive then
        render_Clear( 0, 0, 0, 255, false, true )
    else
        render_Clear( 255, 255, 255, 255, false, true )
    end

    -- Render colored props to the scene and set their pixels high
    cam_Start3D()
    render_SetStencilEnable( true )
    render_SuppressEngineLighting( true )
    cam_IgnoreZ( entry.IgnoreZ )
    render_SetStencilWriteMask( 1 )
    render_SetStencilTestMask( 1 )
    render_SetStencilReferenceValue( 1 )
    render_SetStencilCompareFunction( STENCIL_ALWAYS )
    render_SetStencilPassOperation( STENCIL_REPLACE )
    render_SetStencilFailOperation( STENCIL_KEEP )
    render_SetStencilZFailOperation( STENCIL_KEEP )

    for _, v in pairs( entry.Ents ) do
        if not IsValid( v ) or v:GetNoDraw() then continue end
        RenderEnt = v
        v:DrawModel()
    end

    RenderEnt = NULL
    render_SetStencilCompareFunction( STENCIL_EQUAL )
    render_SetStencilPassOperation( STENCIL_KEEP )
    cam_Start2D()
    surface_SetDrawColor( entry.Color )
    surface_DrawRect( 0, 0, ScrW(), ScrH() )
    cam_End2D()
    cam_IgnoreZ( false )
    render_SuppressEngineLighting( false )
    render_SetStencilEnable( false )
    cam_End3D()
    -- Store a blurred version of the colored props in an RT
    render_CopyRenderTargetToTexture( rt_Blur )
    render_BlurRenderTarget( rt_Blur, entry.BlurX, entry.BlurY, 1 )
    -- Restore the original scene
    render_SetRenderTarget( rt_Scene )
    mat_Copy:SetTexture( "$basetexture", rt_Store )
    mat_Copy:SetString( "$color", "1 1 1" )
    render_SetMaterial( mat_Copy )
    render_DrawScreenQuad()
    -- Draw back our blured colored props additively/subtractively, ignoring the high bits
    render_SetStencilEnable( true )
    render_SetStencilCompareFunction( STENCIL_NOTEQUAL )

    if entry.Additive then
        mat_Add:SetTexture( "$basetexture", rt_Blur )
        render_SetMaterial( mat_Add )
    else
        mat_Sub:SetTexture( "$basetexture", rt_Blur )
        render_SetMaterial( mat_Sub )
    end

    for _ = 0, entry.DrawPasses do
        render_DrawScreenQuad()
    end

    render_SetStencilEnable( false )
    -- Return original values
    render_SetStencilTestMask( 0 )
    render_SetStencilWriteMask( 0 )
    render_SetStencilReferenceValue( 0 )
end
halo_Render = halo.Render

hook.Add( "PostDrawEffects", "RenderHalos", function()
    hook_Run( "PreDrawHalos" )
    if #List == 0 then return end

    for _, v in ipairs( List ) do
        halo_Render( v )
    end

    List = {}
end )

hook.Add( "PreGamemodeLoaded", "GMN_SetHaloLocals", function()
    table_IsEmpty = table.IsEmpty
    render_BlurRenderTarget = render.BlurRenderTarget
    cam_Start3D = cam.Start3D
    cam_Start2D = cam.Start2D
    hook.Remove( "PreGamemodeLoaded", "GMN_SetHaloLocals" )
end )
