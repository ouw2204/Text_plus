local Threader = require(script.Parent.Parent.Packages.faye)
local TextPlus = require(script.Parent.Parent)
local Types = require(script.Parent.Parent.Packages._Index["prophetouw_faye@1.4.8"].faye.Types)
return function (Target: GuiBase)
    local Thread = Threader();
    Thread:Create "Frame" {
        Parent = Target;
        Position = UDim2.fromScale(.5,.5);
        AnchorPoint = Vector2.new(.5,.5);
        Size = UDim2.fromScale(.45,.6);
        BackgroundTransparency = .5;
        BackgroundColor3 = Color3.fromRGB(0,0,0);
        function(Entity: GuiBase)
            -- do stuff
            local Text = TextPlus.New("Hello world this [#name] is an image...",{
                Size = 20;
                XAlignment = Enum.TextXAlignment.Center;
                YAlignment = Enum.TextYAlignment.Center;
                Scaled = true;
                Scale = .5;
            });
            Text:Play(Entity)
        end
    }

    return function()
        Thread:Clean();
    end
end
