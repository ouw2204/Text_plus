local Threader = require(script.Parent.Parent.Packages.faye)
local TextPlus = require(script.Parent.Parent)
return function (Target: GuiBase)
    local Thread = Threader.new();
    Thread:Create "Frame" {
        Parent = Target;
        Position = UDim2.fromScale(.5,.5);
        AnchorPoint = Vector2.new(.5,.5);
        Size = UDim2.fromScale(.45,.6);
        BackgroundTransparency = .5;
        BackgroundColor3 = Color3.fromRGB(0,0,0);
        function(Entity: GuiBase)
            -- do stuff
            local Text = TextPlus.new("Hello world this [#]<img=115664934599527,Style=teststyle> [is an image, again]<Size=100>: [#]<img=115664934599527,Scale=.35>",{
                Size = 50;
                XAlignment = Enum.TextXAlignment.Left;
                YAlignment = Enum.TextYAlignment.Top;
                --[[Scaled = true;
                Scale = .5;]]

            });
            --print(Text:GetContentSize(Entity))
            Text:Print(Entity)
            
        end
    }

    return function()
        Thread:Destroy();
    end
end
