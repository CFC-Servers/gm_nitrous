-- Jit is incredibly laggy on 64x, should be disabled.
if BRANCH ~= "unknown" then
    hook.Add( "InitPostEntity", "64JitPerf", function()
        jit.off()
        jit.flush()
    end )
end
