local Threader = require(script.Parent.Parent.Packages.faye)
local TextPlus = require(script.Parent.Parent)
local Types = require(script.Parent.Parent.Packages._Index["mountaindouw_faye@1.9.2"].faye.Types)
return function (Target: GuiBase)
    local Thread = Threader.new();
    Thread:Create "Frame" {
        Parent = Target;
        Position = UDim2.fromScale(.5,.5);
        AnchorPoint = Vector2.new(.5,.5);
        Size = UDim2.fromScale(.45,.6);
        BackgroundTransparency = .8;
        BackgroundColor3 = Color3.fromRGB(0,0,0);
        function(Entity: GuiBase)
            -- do stuff
            local Text = TextPlus.new("Lorem ipsum dolor sit amet, [consectetur adipiscing elit. Duis fringilla]<StrokeColor=(0,0,0),StrokeTransparency=0> placerat est, sed gravida libero pharetra a. Quisque at leo dictum, lacinia magna ac, facilisis metus. Duis eget orci luctus, ullamcorper massa eget, accumsan augue. Suspendisse quis metus mauris. Mauris id tortor vel est lacinia suscipit. Proin volutpat, diam interdum ullamcorper porttitor",{
                Size = 20;
                XAlignment = Enum.TextXAlignment.Center;
                YAlignment = Enum.TextYAlignment.Center;
                Scaled = true;
                Step = .01;
                Style = {"Wiggle","Fade"};
                Scale = .5;
                StrokeColor = Color3.new(1,1,0);
                StrokeTransparency = .8;
            });
            print(Text:GetContentSize(Entity))
            Text:Play(Entity)
        end
    }

    return function()
        Thread:Destroy();
    end
end
