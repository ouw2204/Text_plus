local Types = require(script.Types)
local MainMetatable = require(script.Handler)
local Storage = require(script.Storage)
local Styles = require(script.Animators.AnimatorClass.Styles)
local mt = {
    New = function(Content: string,DefaultSettings: Types.DefaultSettingsType)
        if Content == nil then return end;
        if DefaultSettings == nil then DefaultSettings = {}:: Types.DefaultSettingsType end;

        --< default properties
        DefaultSettings.Size = DefaultSettings.Size or 14;
        DefaultSettings.Color = DefaultSettings.Color or Color3.fromRGB(255,255,255);
        DefaultSettings.Wrapped = DefaultSettings.Wrapped or true;
        DefaultSettings.Font = DefaultSettings.Font or Enum.Font.SourceSans;
        DefaultSettings.FontFace = DefaultSettings.FontFace or nil;
        DefaultSettings.Overfill = DefaultSettings.Overfill or false;
        DefaultSettings.Transparency = DefaultSettings.Transparency or 0;
        DefaultSettings.Scaled = (DefaultSettings.Scaled or DefaultSettings.Scale ~= nil) or false;
        DefaultSettings.XAlignment = DefaultSettings.XAlignment or Enum.TextXAlignment.Left;
        DefaultSettings.YAlignment = DefaultSettings.YAlignment or Enum.TextYAlignment.Top;
        DefaultSettings.Scale = DefaultSettings.Scale or .35;
        --> default properties

        Content = Content or "";
        local Main = setmetatable({
            Animations = {};
            RawContent = Content;
            Settings = DefaultSettings;
        },MainMetatable)

        return Main
    end
}
function  mt:RegisterGlobalId(Id: string,Content: any)
    if Id == nil or Content == nil then 
        --warn("Id or Function cannot be nil")
        return
    end
    Storage.IdsStorage[Id] = Content;
    return true
end
function  mt:UnRegisterGlobalId(Id: string)
    if Id == nil then 
        --warn("Id cannot be nil")
        return
    end
    Storage.IdsStorage[Id] = nil;
end
function mt:RegisterStyle(Id: string,Function: (Letter: TextLabel,Progress: number,Transparency: number,Color: Color3,Size: UDim2,Position: UDim2,Amplitude: number?,Reversing: boolean?) -> ())
    if Id == nil or Function == nil then return end;
    Styles[Id] = Function;
end
function mt:UnRegisterStyle(Id: string)
    if Id == nil then return end;
    Styles[Id] = nil;
end
return mt :: Types.textPlusType