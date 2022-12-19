-- local meta = FindMetaTable( "Panel" )

-- meta.GMN_GetSkin = GMN.StoreOriginal( "Panel:GetSkin", meta.GetSkin )

-- Currently slower
-- function meta:GetSkin()
--     local cached = self.GMN_GetSkinVar
--     if cached then return cached end

--     local tbl = self:GMN_GetSkin()
--     self.GMN_GetSkinVar = tbl
--     return tbl
-- end
