--!strict
local InterfaceUtility = require(script.Parent.Parent.Packages.IU);
local Utility = require(script.Parent.Parent.Utility);
local Types = require(script.Parent.Parent.TextPlusTypes)

return function(Content: string, Frame: Frame,IsOffset: boolean,AnimInfo: Types.AnimInfo,Properties: Types.PropertiesType,List: UIListLayout)
    local TextSize = Properties.TextSize or 14;
    local ParentAbs = InterfaceUtility.GetAbsoluteSize(Frame);
    if not IsOffset then
        TextSize = math.min(ParentAbs.Y,100)/ParentAbs.Y* (Properties.Scale or 1);
    end
    local Splits,Count = Utility.splitWordsAndSpaces(Content);
    for i = 1,Count do
        
        local v = Splits[i]
        local Object = Instance.new"TextLabel";
        Object.Text = v;
        Object.Font = Properties.Font or Enum.Font.SourceSans;
        Object.BackgroundTransparency = .95;
        Object.Parent = Frame;
        Object.BackgroundColor3 = BrickColor.random().Color;
        Object.TextScaled = not IsOffset;
        local ContentSize
        if IsOffset then
            Object.TextSize = TextSize;
            ContentSize = UDim2.fromOffset(InterfaceUtility.GetTextLength(v,nil,TextSize,Properties.Font,Object.AbsoluteSize),TextSize);
        else
            Object.Size = UDim2.fromScale(5,TextSize);
            ContentSize = UDim2.fromScale(InterfaceUtility.GetScaledTextLength(v,Object),TextSize);
        end
        Object.Size = ContentSize

        if not Properties.Overfill then
            local ListAbs = List.AbsoluteContentSize;
            local FrameAbs = Frame.AbsoluteSize;
            if (ListAbs.Y > FrameAbs.Y) then
                Object:Destroy()
                return;
            end
        end;
        task.wait(AnimInfo.Step)
    end
end
