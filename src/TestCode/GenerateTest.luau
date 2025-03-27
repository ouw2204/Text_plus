local TextPlus = require(script.Parent.Parent)
return function(Target)
    local Frame = Instance.new("Frame");
    Frame.Size = UDim2.fromScale(.4,.4);
    Frame.BackgroundTransparency = .5;
    Frame.Position = UDim2.fromScale(.5,.5);
    Frame.AnchorPoint = Vector2.new(.5,.5);
    Frame.Parent = Target;
    local Txt = TextPlus.Initiate({
        TextXAlignment = Enum.TextXAlignment.Center;
    });
    print(Txt)
    return function()
        Frame:Destroy()
    end
end
