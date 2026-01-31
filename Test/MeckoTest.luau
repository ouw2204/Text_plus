local Threader = require(script.Parent.Parent.Packages.faye)
local TextPlus = require(script.Parent.Parent)
return function (Target: GuiBase)
    local Thread = Threader.new();
    Thread:Create "TextLabel" {
        Parent = Target;
        Position = UDim2.fromScale(.5,.5);
        AnchorPoint = Vector2.new(.5,.5);
        TextColor3 = Color3.new(1,1,1);
        Size = UDim2.fromScale(.3,.3);
        BackgroundTransparency = .5;
        BackgroundColor3 = Color3.fromRGB(0,0,0);
        function(Entity: GuiBase)
            -- do stuff
            TextPlus.new(`[You don't look like you belong here]<Style=Shrink >`, {
                XAlignment = Enum.TextXAlignment.Center,
                YAlignment = Enum.TextYAlignment.Center,
                Scale = .5,
                Amplitude = 2,
                Step = 0.025,
                ContentScaled = false,
            }):Play(Entity)
        end
    }

    return function()
        Thread:Destroy();
    end
end
