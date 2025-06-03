local module = {};
local opposites = {
    ["%["] = "%]",
    ["%{"] = "%}",
    ["%("] = "%)",
    ["%<"] = "%>",
}
function module.splitWordsAndSpaces(input: string): ({string},number)
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
local function tonumbfunc(value: string)
    return tonumber(value)
end
local SpecialCompilers = {
    ["color"] = function(value: string)
        if value == nil then return end;
        if string.find(value,"%<") == nil then
            return Color3.fromHex(value)
        else
            local mode, r, g, b = string.match(value, "^(.-)<%s*([+-]?%d*%.?%d+)%s*,%s*([+-]?%d*%.?%d+)%s*,%s*([+-]?%d*%.?%d+)%s*>")
            if not mode then
                -- Try without brackets: rgb 255,1,3 or rgb255,1,3
                mode, r, g, b = string.match(value, "^(%a+)%s*([+-]?%d*%.?%d+)%s*,%s*([+-]?%d*%.?%d+)%s*,%s*([+-]?%d*%.?%d+)")
            end
            if mode == nil then return end;
            r = tonumber(r); g = tonumber(g); b = tonumber(b);
            if r == nil or g == nil or b == nil then return end;
            mode = string.match(string.lower(mode),"(%w+)");
            if mode == nil then
                if r ~= nil and g ~= nil and b ~= nil then
                    return Color3.new(r,g,b)
                end
            else
                if mode == "rgb" then
                    if r ~= nil and g ~= nil and b ~= nil then
                        return Color3.fromRGB(r,g,b)
                    end
                elseif mode == "hsv" then
                    if r ~= nil and g ~= nil and b ~= nil then
                        return Color3.fromHSV(r,g,b)
                    end
                end
            end
        end;
        return nil
    end,
    ["transparency"] = tonumbfunc;
    ["chunks"] = tonumbfunc;
}
function module.Phase2(input: string?): {[any]: any}?
    if input == nil then return end;
    local result = {}
    
    -- Method 1: Handle values that might contain commas in brackets
    -- This pattern matches key=value where value can contain brackets with commas
    local remaining = input
    while remaining and #remaining > 0 do
        -- Match key = 
        local key, afterKey = string.match(remaining, "^%s*(%w+)%s*=%s*(.*)")
        if not key then break end
        
        local value, nextPart
        -- Check if value starts with a bracket (like rgb<...>)
        if string.match(afterKey, "^%s*[^<]*<") then
            value, nextPart = string.match(afterKey, "^%s*([^<]*<[^>]*>)%s*,?(.*)")
        else
            -- Regular value (no brackets)
            value, nextPart = string.match(afterKey, "^%s*([^,]*)%s*,?(.*)")
        end
        
        if value then
            value = value:match("^%s*(.-)%s*$")
            key = string.lower(key)
            result[key] = (SpecialCompilers[key] ~= nil and SpecialCompilers[key](value)) or value
            remaining = nextPart
        else
            break
        end
    end
    return result
end

module.Phase1 = function(input: any): {[any]: any}?
    if input == nil then return end
    
    local result = {}
    local index = 1
    local lastPos = 1
    
    -- First pass: Handle [Text](Params) patterns
    local processedRanges = {}  -- Track what we've already processed
    
    for startPos, textPart, between, params, endPos in input:gmatch("()%[([^%]]*)%](.-)%(([^%)]*)%)()") do
        -- Add any plain text before the current match
        if startPos > lastPos then
            local before = input:sub(lastPos, startPos - 1)
            if #before > 0 then
                result[index] = before
                index = index + 1
            end
        end
        
        -- Add the captured [Text] with params
        result[index] = { Text = textPart, Params = module.Phase2(params) }
        index = index + 1
        
        -- Add the `between` text if it exists
        if between and #between > 0 then
            result[index] = between
            index = index + 1
        end
        
        -- Mark this range as processed
        processedRanges[#processedRanges + 1] = {startPos, endPos}
        lastPos = endPos
    end
    
    -- Second pass: Handle standalone [Text] patterns (without parentheses)
    -- Reset for second pass
    local tempLastPos = 1
    local tempResult = {}
    local tempIndex = 1
    
    -- Function to check if position is already processed
    local function isProcessed(pos)
        for _, range in ipairs(processedRanges) do
            if pos >= range[1] and pos < range[2] then
                return true
            end
        end
        return false
    end
    
    for startPos, textPart, endPos in input:gmatch("()%[([^%]]*)%]()") do
        -- Skip if this bracket pair is already processed (has parentheses)
        if not isProcessed(startPos) then
            -- Add text before this match
            if startPos > tempLastPos then
                local before = input:sub(tempLastPos, startPos - 1)
                if #before > 0 then
                    tempResult[tempIndex] = before
                    tempIndex = tempIndex + 1
                end
            end
            
            -- Add the standalone [Text] with Params = false
            tempResult[tempIndex] = { Text = textPart, Params = false }
            tempIndex = tempIndex + 1
            
            tempLastPos = endPos
        end
    end
    
    -- Add remaining text from second pass
    if tempLastPos <= #input then
        local remaining = input:sub(tempLastPos)
        if #remaining > 0 then
            tempResult[tempIndex] = remaining
        end
    end
    
    -- Merge results if we found standalone brackets
    if #tempResult > 0 then
        -- Combine and sort all matches by position
        local allMatches = {}
        
        -- Add parametered matches
        local pos = 1
        for startPos, textPart, between, params, endPos in input:gmatch("()%[([^%]]*)%](.-)%(([^%)]*)%)()") do
            table.insert(allMatches, {
                pos = startPos,
                endPos = endPos,
                type = "with_params",
                text = textPart,
                params = params,
                between = between
            })
        end
        
        -- Add standalone matches
        for startPos, textPart, endPos in input:gmatch("()%[([^%]]*)%]()") do
            if not isProcessed(startPos) then
                table.insert(allMatches, {
                    pos = startPos,
                    endPos = endPos,
                    type = "standalone",
                    text = textPart
                })
            end
        end
        
        -- Sort by position
        table.sort(allMatches, function(a, b) return a.pos < b.pos end)
        
        -- Rebuild result in correct order
        result = {}
        index = 1
        lastPos = 1
        
        for _, match in ipairs(allMatches) do
            -- Add text before match
            if match.pos > lastPos then
                local before = input:sub(lastPos, match.pos - 1)
                if #before > 0 then
                    result[index] = before
                    index = index + 1
                end
            end
            
            -- Add the match
            if match.type == "with_params" then
                result[index] = { Text = match.text, Params = module.Phase2(match.params) }
                index = index + 1
                if match.between and #match.between > 0 then
                    result[index] = match.between
                    index = index + 1
                end
            else
                result[index] = { Text = match.text, Params = false }
                index = index + 1
            end
            
            lastPos = match.endPos
        end
        
        -- Add final remaining text
        if lastPos <= #input then
            local remaining = input:sub(lastPos)
            if #remaining > 0 then
                result[index] = remaining
            end
        end
    else
        -- No standalone brackets found, use original result
        -- Add any remaining trailing text from first pass
        if lastPos <= #input then
            local remaining = input:sub(lastPos)
            if #remaining > 0 then
                result[index] = remaining
            end
        end
    end
    
    return result
end
module.Phase1_by_ouw = function(input: any): {[any]: any}?
    if input == nil then return end;
    local result = {};
    local ChildCounter = 0;
    local currentChar = "%["
    local j = string.find(input, currentChar);
    local capturedContent = nil;
    while j ~= nil do
       local opposite = opposites[currentChar];
       local k = string.find(input,opposite)
       if k ~= nil then
        if currentChar == "%[" then
            local before = string.sub(input,0,math.max(0,j-1));
            if before ~= nil and #before > 0 then
                result[ChildCounter+1] = before;
                ChildCounter = ChildCounter + 1;
            end
            capturedContent = string.sub(input,j+1,k-1);
            input = string.sub(input,k+1,#input);
            currentChar = "%(";
            j = string.find(input,currentChar);
        elseif currentChar == "%(" then
            local before = string.sub(input,0,math.max(0,j-1));
            if before ~= nil and #before > 0 then
                result[ChildCounter+1] = before;
                ChildCounter = ChildCounter + 1;
            end
            local Params = string.sub(input,j+1,k-1);
            if capturedContent ~= nil and Params ~= nil and #Params > 0 then
                local tab = {Text = capturedContent,Params = module.Phase2(Params)};
                result[ChildCounter+1] = tab;
                ChildCounter = ChildCounter + 1;
            end
            input = string.sub(input,k+1,#input);
            currentChar = "%[";
            j = string.find(input,currentChar);
        end
       else
          j = nil;
       end
    end
    if input ~= nil and #input >0 then
        result[ChildCounter+1] = input;
    end
    return result
end
return module;
