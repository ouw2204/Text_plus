local Types = require(script.Parent.Parent.Types);
local module = {};

module.__index = module;
function module:Destroy()
    print("destroy")
end
function module:AddLetter(Letter: TextLabel)
    
end
return function(Word: TextLabel, Settings: Types.DefaultSettingsType): Types.AnimatorType
    local tab = {
        Word = Word;
        Letters = {};
        HasUpdate = false;
        Index = 0;
    }
    
    return setmetatable(tab,module) :: any
end
