local Threader = require(script.Parent.Parent.Packages.faye)
local TextPlus = require(script.Parent.Parent)
local Types = require(script.Parent.Parent.Packages._Index["mountaindouw_faye@2.1.5"].faye.FayeTypes)
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
            local Text = TextPlus.new("Hello world my name is Saad Abas ALi muhamed Asmeh Badher Souleiman hackeem Nesrellah vasdasd",{
                Size = 20;
                XAlignment = Enum.TextXAlignment.Center;
                YAlignment = Enum.TextYAlignment.Center;
                Scaled = true;
                --Scale = .5;
                --Step =  .05;
                Style = {"Wiggle","Fade"},
                Chunks = 2;
                ContentScaled = true;
            });
            Text:Play(Entity)
            
        end
    }

    return function()
        Thread:Destroy();
    end
end
