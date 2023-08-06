return {
    cases = {
        {
            name = "It should behave identically to SortedPairs for list of letters",
            func = function()
                local t = { "e", "b", "d", "c", "a" }

                local resultBase = {}
                for id, text in SortedPairs( t ) do
                    table.insert( resultBase, { id, text } )
                end

                local resultGMN = {}
                for id, text in GMN.SortedPairs( t ) do
                    table.insert( resultGMN, { id, text } )
                end

                for i, base in ipairs( resultBase ) do
                    local gmnItem = resultGMN[i]
                    expect( gmnItem[1] ).to.equal( base[1] )
                    expect( gmnItem[2] ).to.equal( base[2] )
                end
            end
        },
        {
            name = "It should behave identically to SortedPairs for a key-value table",
            func = function()
                local t = {
                    e = 1,
                    b = 2,
                    d = 3,
                    c = 4,
                    a = 5
                }

                local resultBase = {}
                for id, text in SortedPairs( t ) do
                    table.insert( resultBase, { id, text } )
                end

                local resultGMN = {}
                for id, text in GMN.SortedPairs( t ) do
                    table.insert( resultGMN, { id, text } )
                end

                for i, base in ipairs( resultBase ) do
                    local gmnItem = resultGMN[i]
                    expect( gmnItem[1] ).to.equal( base[1] )
                    expect( gmnItem[2] ).to.equal( base[2] )
                end
            end
        },
        {
            name = "It should behave identically to SortedPairs for mixed type keys",
            func = function()
                local t = {
                    ["1"] = 1,
                    [1] = 2,
                    [true] = 3,
                    a = 4,
                    ["true"] = 5
                }

                expect( SortedPairs, t ).to.errWith( "attempt to compare string with number" )
                expect( GMN.SortedPairs, t ).to.errWith( "attempt to compare string with number" )
            end
        },
        {
            name = "It should behave identically to SortedPairs for descending order",
            func = function()
                local t = { "e", "b", "d", "c", "a" }

                local resultBase = {}
                for id, text in SortedPairs( t, true ) do
                    table.insert( resultBase, { id, text } )
                end

                local resultGMN = {}
                for id, text in GMN.SortedPairs( t, true ) do
                    table.insert( resultGMN, { id, text } )
                end

                for i, base in ipairs( resultBase ) do
                    local gmnItem = resultGMN[i]
                    expect( gmnItem[1] ).to.equal( base[1] )
                    expect( gmnItem[2] ).to.equal( base[2] )
                end
            end
        },
        {
            name = "It should behave identically to SortedPairs for empty tables",
            func = function()
                local t = {}

                local resultBase = {}
                for id, text in SortedPairs( t, true ) do
                    table.insert( resultBase, { id, text } )
                end

                local resultGMN = {}
                for id, text in GMN.SortedPairs( t, true ) do
                    table.insert( resultGMN, { id, text } )
                end

                expect( #resultBase ).to.equal( 0 )
                expect( #resultGMN ).to.equal( 0 )
            end
        },
    }
}
