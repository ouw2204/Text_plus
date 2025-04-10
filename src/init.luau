--!strict
local Types =require(script.TextPlusTypes);

export type AnimType = {

}
type tableType = {
    Count: number;
    [number]: string | AnimType;
    Properties: Types.PropertiesType;
    DefaultAnimationProps: Types.AnimInfo;
}
export type TextPlusType = {
    __index: any;
    Count: number?;
    Add: (self: TextPlusType, Content: string) -> TextPlusType;
    Play: (self: tableType,Frame: Frame,Yield: boolean) -> ();
    
}
local Compilers = {
    Regular = require(script.Compilers.Regular);
}
local mt : TextPlusType = {
    Add = function(self: TextPlusType,Content : string) : TextPlusType
        self.Count = (self.Count or 0) + 1;
        self[self.Count] = Content;
        return self :: any;
    end,
    Play = function(self: tableType,Frame: Frame,Yield: boolean?)
        if self.Properties == nil then warn("Must initiate first Text+."); return end;

        local IsOffset = (self.Properties.Scale == nil and self.Properties.TextScaled == nil) or false;
        local List = Instance.new"UIListLayout"
        List.Parent = Frame;
        List.Name = "List";
        local VerticalAlignment = Enum.VerticalAlignment.Top;
        local HorizontalAlignment = Enum.HorizontalAlignment.Left;
        if self.Properties.TextYAlignment == Enum.TextYAlignment.Center then
            VerticalAlignment = Enum.VerticalAlignment.Center;
        elseif self.Properties.TextYAlignment == Enum.TextYAlignment.Bottom then
            VerticalAlignment = Enum.VerticalAlignment.Bottom;
        end
        if self.Properties.TextXAlignment == Enum.TextXAlignment.Center then
            HorizontalAlignment = Enum.HorizontalAlignment.Center;
        elseif self.Properties.TextXAlignment == Enum.TextXAlignment.Right then
            HorizontalAlignment = Enum.HorizontalAlignment.Right;
        end
        List.HorizontalAlignment = HorizontalAlignment;
        List.VerticalAlignment = VerticalAlignment;
        List.FillDirection = Enum.FillDirection.Horizontal;
        List.Wraps = self.Properties.TextWrapped or false;
        local Run = function()
            for k = 1,self.Count do
                local Content = self[k];
                local Compiler = "Regular"
                local Props = self.DefaultAnimationProps;
                if typeof(Content) == "table" then
    
                end
                Compilers[Compiler](Content,Frame,IsOffset,Props,self.Properties,List);
                task.wait(Props.Step)
            end
        end
        if Yield == true then
            Run()
        else
            task.spawn(Run)
        end
    end
};
mt.__index = mt;
export type mType = {
    Initiate: (Properties: Types.PropertiesType?) -> TextPlusType;
}
local m = {

    Initiate = function(Properties: Types.PropertiesType) : TextPlusType
        if Properties == nil then
            Properties = {
            }
        end
        Properties.TextWrapped = Properties.TextWrapped or true;
        Properties.Font = Properties.Font or Enum.Font.SourceSans;
        Properties.Overfill = Properties.Overfill or false;
        local tab = {Count = 0,Properties = Properties,DefaultAnimationProps = {Step = Properties.Step, Group = Properties.Group}};
        Properties.Step = nil;
        Properties.Group = nil;
        setmetatable(tab,mt);
        return tab:: any
    end
};

return m :: mType;