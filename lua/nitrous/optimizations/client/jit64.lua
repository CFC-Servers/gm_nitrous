-- Jit is incredibly laggy on 64x, should be disabled.
if BRANCH ~= "unknown" then
    jit.off()
    jit.flush()
end
