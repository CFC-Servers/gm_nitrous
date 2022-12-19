local SysTime = SysTime

function GMN.RunTest( func, count )
    count = count or 100000

    local startTime = SysTime()

    for _ = 1, count do
        func()
    end

    local endTime = SysTime()
    local totalTime = endTime - startTime

    local averageTime = totalTime / count
    return totalTime, averageTime
end

function GMN.TestCompare( func1, func2, count )
    local jitstatus = jit.status()

    print( "[GMN] Starting test.." )

    timer.Simple( 0, function()
        jit.on()
        collectgarbage()
        local totalTime1, averageTime1 = GMN.RunTest( func1, count )
        print( "1 JIT ON took " .. totalTime1 .. " seconds to run " .. count .. " times, average: " .. averageTime1 .. " seconds" )
    end )

    timer.Simple( 0.05, function()
        jit.on()
        collectgarbage()
        local totalTime2, averageTime2 = GMN.RunTest( func2, count )
        print( "2 JIT ON took " .. totalTime2 .. " seconds to run " .. count .. " times, average: " .. averageTime2 .. " seconds" )
    end )

    timer.Simple( 0.1, function()
        jit.off()
        collectgarbage()
        local totalTime3, averageTime3 = GMN.RunTest( func1, count )
        print( "1 JIT OFF took " .. totalTime3 .. " seconds to run " .. count .. " times, average: " .. averageTime3 .. " seconds" )
    end )

    timer.Simple( 0.15, function()
        jit.off()
        collectgarbage()
        local totalTime4, averageTime4 = GMN.RunTest( func2, count )
        print( "2 JIT OFF took " .. totalTime4 .. " seconds to run " .. count .. " times, average: " .. averageTime4 .. " seconds" )

        if jitstatus then
            jit.on()
        else
            jit.off()
        end
    end )
end
