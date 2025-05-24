local Types = require(script.Parent.Parent.Types);
local module = {};

module.__index = module;
function module:Destroy()
    print("destroy")
end
function module:AddWord(Word: TextLabel)
    
end
return function(Word: TextLabel, Settings: Types.DefaultSettingsType,ContentSettings: Types.DefaultSettingsType): Types.AnimatorType
    return setmetatable({
        Word = Word;
        Letters = {};
        HasUpdate = false;
        Index = 0;
        Settings = Settings;
        ContentSettings = ContentSettings;
    },module) :: any
end
