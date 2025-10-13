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
        BackgroundTransparency = .5;
        BackgroundColor3 = Color3.fromRGB(0,0,0);
        function(Entity: GuiBase)
            -- do stuff
            local Text = TextPlus.new("Hello [world]<font=Arcade> this is [a font]<fontface = (rbxasset://fonts/families/AmaticSC.json,Regular,Italic)> [test.]<fontface=Sarpanch>",{
                Size = 20; 
                XAlignment = Enum.TextXAlignment.Center;
                YAlignment = Enum.TextYAlignment.Center;
                Scale = .5;
                Font = Enum.Font.SourceSans;
            });
            Text:Play(Entity)
            print(Text.Sequence)
        end
    }

    return function()
        Thread:Destroy();
    end
end
