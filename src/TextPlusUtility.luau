local module = {};
local Storage = require(script.Parent.Storage)
local opposites = {
    ["%["] = "%]",
    ["%{"] = "%}",
    ["%("] = "%)",
    ["%<"] = "%>",
}
local ss = string.sub
local sl = string.lower
local tof = typeof
local sf = string.find
local tabletxt = "table"
local tins = table.insert
local tf = table.find
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
local function smartSplit(str, delimiter)
    local result = {}
    local current = ""
    local depth = 0
    local count = 0;
    for i = 1, #str do
        local char = ss(str, i, i)
        
        if char == "(" then
            depth = depth + 1
            current = current .. char
        elseif char == ")" then
            depth = depth - 1
            current = current .. char
        elseif char == delimiter and depth == 0 then
            -- Only split when we're not inside brackets
            local trimmed = current:match("^%s*(.-)%s*$") -- trim whitespace
            if #trimmed > 0 then
                table.insert(result, trimmed)
                count += 1
            end
            current = ""
        else
            current = current .. char
        end
    end
    
    -- Add the last part
    local trimmed = current:match("^%s*(.-)%s*$")
    if #trimmed > 0 then
        table.insert(result, trimmed)
        count += 1;
    end
    depth = nil;
    current = nil;
    return result,count
end
local booleanfunc = function(Content)
    return sl(Content) == "true"
end;
local SpecialCompilers; SpecialCompilers = {
    ["color"] = function(value: string)
        if value == nil then return end;
        if string.find(value,"%(") == nil then
            return Color3.fromHex(value)
        else
            local mode, r, g, b = string.match(value, "^(.-)%((%s*[+-]?%d*%.?%d+)%s*,%s*([+-]?%d*%.?%d+)%s*,%s*([+-]?%d*%.?%d+)%s*%)")
            if not mode then
                -- Try without brackets: rgb 255,1,3 or rgb255,1,3
                mode, r, g, b = string.match(value, "^(%a+)%s*([+-]?%d*%.?%d+)%s*,%s*([+-]?%d*%.?%d+)%s*,%s*([+-]?%d*%.?%d+)")
            end
            if mode == nil then return end;
            r = tonumber(r); g = tonumber(g); b = tonumber(b);
            if r == nil or g == nil or b == nil then return end;
            mode = string.match(sl(mode),"(%w+)");
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
    looped = booleanfunc;
    reverse = booleanfunc;
    ["repeat"] = tonumbfunc;
    delaytime = tonumbfunc;
    ["transparency"] = tonumbfunc;
    ["chunks"] = tonumbfunc;
    ["textsize"] = tonumbfunc;
    ["amplitude"] = tonumbfunc;
    step = tonumbfunc;
    ["fontface"] = function(value: string)
        if value == nil then return end;
        
        -- Check if it has parentheses (complex format)
        if string.find(value,"%(") ~= nil then
            -- Pattern for text values in brackets: fromName(font,style,weight)
            local mode, x, y, z = string.match(value, "^(.-)%((%s*[^,]+)%s*,?%s*([^,]*)%s*,?%s*([^,)]*)%s*%)")
            
            if x ~= nil and x ~= "" then
                -- Trim whitespace from captured values
                x = x:match("^%s*(.-)%s*$")
                y = (y and y ~= "") and y:match("^%s*(.-)%s*$") or "Regular"
                z = (z and z ~= "") and z:match("^%s*(.-)%s*$") or "Normal"
                
                mode = mode and string.match(sl(mode),"(%w+)") or nil
                
                if mode == "name" then
                    return Font.fromName(string.gsub(x," ","_"), Enum.FontWeight[y], Enum.FontStyle[z])
                elseif mode == "id" then
                    return Font.fromId(string.gsub(x," ","_"), Enum.FontWeight[y], Enum.FontStyle[z])
                elseif mode == nil then
                    return Font.new(string.gsub(x," ","_"), Enum.FontWeight[y], Enum.FontStyle[z])
                end
            end
        else
            -- Simple format: just the font name, use as fromName with defaults
            local fontName = value:match("^%s*(.-)%s*$") -- trim whitespace
            if fontName and fontName ~= "" then
                return Font.fromName(string.gsub(fontName," ","_"), Enum.FontWeight.Regular, Enum.FontStyle.Normal)
            end
        end
        
        return nil
    end;
    ["style"] = function(value)
        if value == nil then return end;
        if string.find(value,"%(") ~= nil then
            value = string.match(value, "%((.+)%)")
            local result
            if string.find(value,"%(") then
                local count
                result,count = smartSplit(value,",")
                for x = 1,count do
                    if string.find(result[x],"%(") then
                        local res = string.split(string.match(result[x], "%((.+)%)"))
                        for y = #res,1,-1 do
                            if string.find(res[y],"%=") ~= nil then
                                local key, val = string.match(res[y], "^%s*([^=]-)%s*=%s*(.-)%s*$")
                                key = sl(key)
                                res[key] = (SpecialCompilers[key] and SpecialCompilers[key](val)) or val;
                            else
                                res["Style"] = string.match(res[y], "^%s*(.-)%s*$");
                                
                            end
                            res[y] = nil;
                        end
                        result[x] = res
                    end
                end
            else
                result = string.split(value,",")
            end
            return result
        else
            return value;
        end
    end
}


function module.Phase2(input: string?, Content: any): {[any]: any}?
    if input == nil then return end
    local result = {}
    local remaining = input

    while remaining and #remaining > 0 do
        -- key =
        local key, afterKey = string.match(remaining, "^%s*(%w+)%s*=%s*(.*)")
        if not key then break end

        local value, nextPart

        -- Only match if value STARTS with identifier + balanced {}
        -- e.g. rgb{1,2,3}, map{a=b}, etc.
        local brackets = string.match(afterKey, "^%s*([%w_]*%b())")
        if brackets then
            value = brackets
            -- skip over the exact bracketed chunk + optional comma + spaces
            local escaped = string.gsub(brackets, "([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1")
            nextPart = string.match(afterKey, "^%s*" .. escaped .. "%s*,%s*(.*)")
                      or string.match(afterKey, "^%s*" .. escaped .. "%s*(.*)")
        else
            -- Scan until the next top-level comma (commas inside {...} are ignored)
            local depth, i, len = 0, 1, #afterKey
            local stop = len
            while i <= len do
                local c = afterKey:sub(i, i)
                if c == '(' then depth = depth + 1
                elseif c == ')' and depth > 0 then depth = depth - 1
                elseif c == ',' and depth == 0 then
                    stop = i - 1
                    break
                end
                i = i + 1
            end
            value = afterKey:sub(1, stop):match("^%s*(.-)%s*$")

            -- move to char after comma, then skip spaces
            local j = stop + 1
            if afterKey:sub(j, j) == ',' then
                j = j + 1
                while j <= len and afterKey:sub(j, j):match("%s") do
                    j = j + 1
                end
            end
            nextPart = afterKey:sub(j)
        end

        if value then
            local loweredkey = sl(key)
            local func = Storage.IdsStorage[value]
            local valueToUse = value;
            if func ~= nil then
                valueToUse = func(key) or valueToUse
            end
            result[loweredkey] = (SpecialCompilers[loweredkey] ~= nil and SpecialCompilers[loweredkey](valueToUse)) or value;
        end

        remaining = nextPart
    end

    return result
end

local TranslateWrapper = require(script.Parent.Packages.translatewrapper);

module.Phase1 = function(input: string?, Content: any): {[any]: any}?
	if input == nil then return end
	local result = {n = 1}
	local i = 1
	local len = #input

	while i <= len do
		local c = input:sub(i,i)
		if c == "[" then
			-- parse inside [...]
			local depth = 1
			local j = i + 1
			local innerStart = j
			while j <= len and depth > 0 do
				local cj = input:sub(j,j)
				if cj == "[" then
					depth += 1
				elseif cj == "]" then
					depth -= 1
				end
				j += 1
			end

			local innerText = input:sub(innerStart, j-2 >= innerStart and j-2 or innerStart)
			local after = j

			-- check for <params>
			local paramBlock = nil
			if after <= len and input:sub(after,after) == "<" then
				local k = after + 1
				while k <= len and input:sub(k,k) ~= ">" do
					k += 1
				end
				if k <= len then
					paramBlock = input:sub(after+1, k-1)
					after = k+1
				end
			end

			-- add entry directly into result
            local Parsed
            if paramBlock ~= nil then
                Parsed = module.Phase2(paramBlock, Content)
            end
            if sf(innerText, "%<") or sf(innerText, "%[") then
                local extracted1 = module.Phase1(innerText, Content)
                for i = 1,extracted1.n do
                    local v = extracted1[i]
                    if v == nil then continue end;
                    if tof(v) == tabletxt then
                        if Parsed ~= nil then
                            for index,value in Parsed do
                                if v.Params[index] == nil then
                                    v.Params[index] = value;
                                elseif tof(value) == tabletxt then

                                    if tof(v.Params[index]) ~= tabletxt then
                                        v.Params[index] = {v.Params[index]}
                                    end
                                    for _,newv in ipairs(value) do
                                        if tf(v.Params[index],newv) == nil then
                                            tins(v.Params[index],newv)
                                        end
                                    end

                                end
                            end
                        end
                    else
                        if Parsed ~= nil then
                            v = {
                                Text = TranslateWrapper.Translate(v),
                                Params = Parsed
                            }
                        end
                    end
                    result[result.n] = v;
                    result.n += 1
                end
            else
                if Parsed then
                    
                    result[result.n] = {
                        Text = TranslateWrapper.Translate(innerText),
                        Params = Parsed
                    }
                else
                    result[result.n] = TranslateWrapper.Translate(innerText)
                end
                result.n += 1
            end
			
			i = after
		else
			-- collect plain text until next [
			local j = i
			while j <= len and input:sub(j,j) ~= "[" do
				j += 1
			end
			local text = input:sub(i, j-1)
			if #text > 0 then
				result[result.n] = TranslateWrapper.Translate(text)
				result.n += 1
			end
			i = j
		end
	end
	return result
end


return module;