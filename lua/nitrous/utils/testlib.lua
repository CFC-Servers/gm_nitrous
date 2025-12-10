GMN = GMN or {}
local SysTime = SysTime

function GMN.NiceSize( byteSize )
    local negative = byteSize < 0
    if negative then
        byteSize = -byteSize
    end

    if byteSize < 1024 then
        return ( negative and "-" or "" ) .. byteSize .. " B"
    end

    local kb = byteSize / 1024
    if kb < 1024 then
        return ( negative and "-" or "" ) .. math.Round( kb ) .. " KB"
    elseif kb < 1024 * 1024 then
        return ( negative and "-" or "" ) .. math.Round( kb / 1024 ) .. " MB"
    elseif kb < 1024 * 1024 * 1024 then
        return ( negative and "-" or "" ) .. math.Round( kb / ( 1024 * 1024 ), 2 ) .. " GB"
    end
end

function GMN.RunTest( func, count )
    count = count or 1000000

    local startTime = SysTime()
    jit.flush()
    collectgarbage()

    local garbageBefore = collectgarbage( "count" )
    for _ = 1, count do
        func()
    end
    local garbageAfter = collectgarbage( "count" )
    local garbageCollected = garbageAfter - garbageBefore

    local endTime = SysTime()
    local totalTime = endTime - startTime

    local averageTime = totalTime / count
    return totalTime, averageTime, garbageCollected
end

function GMN.TestCompare( func1, func2, count )
    count = count or 1000000

    local jitstatus = jit.status()

    print( "[GMN] Starting test.." )

    jit.on()
    local totalTime1, averageTime1, garbage1 = GMN.RunTest( func1, count )

    jit.on()
    local totalTime2, averageTime2, garbage2 = GMN.RunTest( func2, count )

    jit.off()
    local totalTime3, averageTime3, garbage3 = GMN.RunTest( func1, count )

    jit.off()
    local totalTime4, averageTime4, garbage4 = GMN.RunTest( func2, count )

    if jitstatus then
        jit.on()
    else
        jit.off()
    end

    print( "1 JIT ON took " .. totalTime1 .. " seconds to run " .. count .. " times, average: " .. averageTime1 .. " seconds, garbage collected: " .. GMN.NiceSize( garbage1 ) )
    print( "2 JIT ON took " .. totalTime2 .. " seconds to run " .. count .. " times, average: " .. averageTime2 .. " seconds, garbage collected: " .. GMN.NiceSize( garbage2 ) )
    print( "1 JIT OFF took " .. totalTime3 .. " seconds to run " .. count .. " times, average: " .. averageTime3 .. " seconds, garbage collected: " .. GMN.NiceSize( garbage3 ) )
    print( "2 JIT OFF took " .. totalTime4 .. " seconds to run " .. count .. " times, average: " .. averageTime4 .. " seconds, garbage collected: " .. GMN.NiceSize( garbage4 ) )

    if averageTime1 > averageTime2 then
        print( "JIT ON 2 is " .. math.Round( ( averageTime1 / averageTime2 ) * 100 - 100, 3 ) .. "% faster than test 1" )
    else
        print( "JIT ON 1 is " .. math.Round( ( averageTime2 / averageTime1 ) * 100 - 100, 3 ) .. "% faster than test 2" )
    end

    if averageTime3 > averageTime4 then
        print( "JIT OFF 2 is " .. math.Round( ( averageTime3 / averageTime4 ) * 100 - 100, 3 ) .. "% faster than test 1" )
    else
        print( "JIT OFF 1 is " .. math.Round( ( averageTime4 / averageTime3 ) * 100 - 100, 3 ) .. "% faster than test 2" )
    end

    if garbage1 ~= garbage2 then
        print( "JIT ON tests produced different garbage amounts: " .. GMN.NiceSize( garbage1 ) .. " vs " .. GMN.NiceSize( garbage2 ) )
    end

    if garbage3 ~= garbage4 then
        print( "JIT OFF tests produced different garbage amounts: " .. GMN.NiceSize( garbage3 ) .. " vs " .. GMN.NiceSize( garbage4 ) )
    end
end
