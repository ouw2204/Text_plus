--!strict
export type AnimType = {

}

type tableType = {
    Count: number;
    [number]: string | AnimType
}
export type TextPlusType = {
    __index: any;
    AddText: (self: tableType, Text: string) -> TextPlusType | tableType;
    Play: (self: tableType,Frame: Frame) -> TextPlusType | tableType
}
local mt : TextPlusType = {
    AddText = function(self: tableType,Text : string)
        self.Count += 1;
        self[self.Count] = Text;
        return self;
    end,
    Play = function(self: tableType,Frame: Frame)

        return self;
    end
};
mt.__index = mt;

type PropertiesType = {
    TextXAlignment: Enum.TextXAlignment?;
    TextYAlignment: Enum.TextYAlignment?;
    TextColor3: Color3?;
    Font: Enum.Font?;
    TextScaled: boolean?;
    Scale: number?;
    TextStrokeColor3: Color3?;
    StrokeTransparency: number?;
    TextTransparency: number?;
};
export type mType = {
    Initiate: (Properties: PropertiesType?) -> TextPlusType;
}
local m = {

    Initiate = function(Properties: PropertiesType?) : TextPlusType
        local tab = {Count = 0,Properties = nil};
        return tab:: any
    end
};

return m :: mType;