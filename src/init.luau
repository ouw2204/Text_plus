local Types = require(script.Types)
local MainMetatable = require(script.MainMetatable)
local Decrypter = require(script.Utility)
return {
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
        return setmetatable({
            Sequence = Decrypter.Phase1(Content);
            Settings = DefaultSettings;
        },MainMetatable)
    end
}:: Types.textPlusType