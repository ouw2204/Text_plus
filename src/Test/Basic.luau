local Threader = require(script.Parent.Parent.Packages.faye)
local TextPlus = require(script.Parent.Parent)
local Types = require(script.Parent.Parent.Packages._Index["prophetouw_faye@1.2.2"].faye.Types)
return function (Target: GuiBase)
    local Thread = Threader();
    Thread:Create "Frame" {
        Parent = Target;
        Position = UDim2.fromScale(.5,.5);
        AnchorPoint = Vector2.new(.5,.5);
        Size = UDim2.fromScale(.3,.4);
        BackgroundTransparency = .5;
        BackgroundColor3 = Color3.fromRGB(0,0,0);
        function(Thread: Types.Thread,Entity: GuiBase)
            -- do stuff
            local Text = TextPlus.New("Hello world [RedText](Color = rgb<255,1,3>,step=.15,Transparency = .5,Style = Rainbow,Chunks=2) vvasd",{
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
