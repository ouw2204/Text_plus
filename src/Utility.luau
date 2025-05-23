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
local SpecialCompilers = {
    ["Color"] = function(value: string)
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
    ["Transparency"] = function(value: string)
        return tonumber(value)
    end,
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
            result[string.lower(key)] = (SpecialCompilers[key] ~= nil and SpecialCompilers[key](value)) or value
            remaining = nextPart
        else
            break
        end
    end
    print(result," are phase 2 results")
    return result
end

module.Phase1 = function(input: any): {[any]: any}?
    if input == nil then return end

    local result = {}
    local index = 1
    local lastPos = 1

    -- Match: [Text] between (Params)
    for startPos, textPart, between, params, endPos in input:gmatch("()%[([^%]]+)%](.-)%(([^%)]+)%)()") do
        -- Add any plain text before the current match
        if startPos > lastPos then
            local before = input:sub(lastPos, startPos - 1)
            if #before > 0 then
                result[index] = before
                index += 1
            end
        end

        -- Add the captured [Text]
        result[index] = { Text = textPart, Params = module.Phase2(params) }
        index += 1

        -- Add the `between` text (space, formatting, etc.) as its own string
        if between and #between > 0 then
            result[index] = between
            index += 1
        end

        lastPos = endPos -- endPos is already a number
    end

    -- Add any remaining trailing text
    if lastPos <= #input then
        local remaining = input:sub(lastPos)
        if #remaining > 0 then
            result[index] = remaining
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
