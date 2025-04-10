local Utility = {};
function Utility.splitWordsAndSpaces(input: string): ({string},number)
	local result = {}
    local i = 1
    local Count = 0;
    while i <= #input do
        -- Try to match whitespace first
        local spaces = input:match("^%s+", i)
        if spaces then
            table.insert(result, spaces)
            Count += 1
            i = i + #spaces
        else
            -- If no whitespace, match non-whitespace (words, punctuation, etc.)
            local word = input:match("^%S+", i)
            if word then
                table.insert(result, word)
                Count += 1;
                i = i + #word
            else
                break
            end
        end
    end
    return result, Count;
end
return Utility;