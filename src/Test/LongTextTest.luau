local Threader = require(script.Parent.Parent.Packages.faye)
local TextPlus = require(script.Parent.Parent)
local Types = require(script.Parent.Parent.Packages._Index["prophetouw_faye@1.3.1"].faye.Types)
return function (Target: GuiBase)
    local Thread = Threader();
    Thread:Create "Frame" {
        Parent = Target;
        Position = UDim2.fromScale(.5,.5);
        AnchorPoint = Vector2.new(.5,.5);
        Size = UDim2.fromScale(.3,.4);
        BackgroundTransparency = .5;
        BackgroundColor3 = Color3.fromRGB(0,0,0);
        function(Entity: GuiBase)
            -- do stuff
            local Text = TextPlus.New("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis fringilla placerat est, sed gravida libero pharetra a. Quisque at leo dictum, lacinia magna ac, facilisis metus. Duis eget orci luctus, ullamcorper massa eget, accumsan augue. Suspendisse quis metus mauris. Mauris id tortor vel est lacinia suscipit. Proin volutpat, diam interdum ullamcorper porttitor",{
                Size = 20;
                XAlignment = Enum.TextXAlignment.Center;
                YAlignment = Enum.TextYAlignment.Center;
                Scaled = true;
                Step = .01;
                Scale = .5;
            });
            Text:Play(Entity)
        end
    }

    return function()
        Thread:Clean();
    end
end
