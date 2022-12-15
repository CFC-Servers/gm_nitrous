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
    return averageTime
end

function GMN.RunTestPrint( name, func, count )
    local averageTime = GMN.RunTest( name, func, count )
    print( "[GMN] " .. name .. " took " .. totalTime .. " seconds to run " .. count .. " times, average: " .. averageTime .. " seconds" )
end
