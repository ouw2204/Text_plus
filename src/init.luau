local Types = require(script.TextPlusTypes)
local MainMetatable = require(script.Handler)
local Storage = require(script.Storage)
local Styles = require(script.Animators.AnimatorClass.Styles)
local mt = {
    new = function(Content: string,DefaultSettings: Types.DefaultSettingsType)
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
        DefaultSettings.UseCanvas = DefaultSettings.UseCanvas or false;
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
function  mt.RegisterId(Id: string,Content: any)
    if Id == nil or Content == nil then 
        return
    end
    Storage.IdsStorage[Id] = Content;
    return true
end
function  mt.UnRegisterId(Id: string)
    if Id == nil then 
        return
    end
    Storage.IdsStorage[Id] = nil;
end
function mt.RegisterStyle(Id: string,Function: (Letter: TextLabel,Progress: number,Transparency: number, StrokeTransparency: number,Color: Color3,StrokeColor: Color3,Size: UDim2,Position: UDim2,Amplitude: number?,Reversing: boolean?) -> ())
    if Id == nil or Function == nil then return end;
    Styles[Id] = Function;
end
function mt.UnRegisterStyle(Id: string)
    if Id == nil then return end;
    Styles[Id] = nil;
end


local tof = typeof
local ts = tostring
local stringtype = "string"
local tabletype = "table"
local emptystring = ""
local opencurlybrackets = "("
local closecurlybrackets = ")"
local enumtype = "Enum"
local imagetxt = "Image"
local imgtxt = "Img"
local mc = math.clamp
local sf = string.format
local CustomFormating; CustomFormating = {
    Color = function(Color: Color3)
        if Color == nil then return end;
        local R,G,B = mc(Color.R * 255,0,255), mc(Color.G * 255,0,255), mc(Color.B * 255,0,255)
        return sf("rgb(%d,%d,%d)",R,G,B)
    end,
    Color3 = function(Color: Color3)
        if Color == nil then return end;
        local R,G,B = mc(Color.R * 255,0,255), mc(Color.G * 255,0,255), mc(Color.B * 255,0,255)
        return sf("rgb(%d,%d,%d)",R,G,B)
    end,
    FontFace = function(FontFace: Font)
        if FontFace == nil then return nil end;
        local Name = (FontFace.Family and FontFace.Family) or "Unknown"
        local Weight = (FontFace.Weight and FontFace.Weight.Name) or "Regular"
        local Style = (FontFace.Style and FontFace.Style.Name) or "Normal"
        return sf("(%s,%s,%s)",Name,Weight,Style)
    end,
    Style = function(Style: string)
        if Style == nil then return end;
        if tof(Style) == tabletype then
            local re = opencurlybrackets
            for i = 1,#Style do
                if i ~= 1 then
                    re ..= ","
                end
                re ..= Style[i]
            end
            re ..= closecurlybrackets
            return re
        else
            return Style
        end
    end,
    Font = function(Font: Enum.Font)
        if Font == nil then return end;
        local toff = tof(Font)
        if toff == enumtype then
            return Font.Name
        elseif toff == stringtype then
            return Font
        else
            return CustomFormating.FontFace(Font)
        end
    end,
    EnumItem = function(EnumItem: EnumItem)
        if EnumItem == nil then return end;
        return EnumItem.Name;
    end,
};

function mt.Format(Content: (Types.ContentType | any) )
    local firstType = tof(Content)
    if firstType == tabletype then
        local ret = emptystring;
        local Count = 0;
        for i,v in pairs(Content) do
            if i == imagetxt then
                i = imgtxt
            end
            local val = nil;
            if CustomFormating[i] ~= nil then
                val = CustomFormating[i](v)
            else
                local secondType = tof(v)
                if secondType == stringtype then
                    val = v
                elseif CustomFormating[secondType] ~= nil then
                    val = CustomFormating[secondType](v)
                end
                if val == nil then
                    val = ts(v)
                end
            end
            if val ~= nil then
                if Count ~= 0 then
                    ret..=`,{i} = {val}`
                else
                    ret..=`{i} = {val}`
                end
                Count += 1;
            end
        end
        return ret;
    elseif firstType == stringtype then
        return Content
    else
        return (CustomFormating[firstType] and CustomFormating[firstType](Content)) or ts(Content)
    end

end

return mt :: Types.textPlusType