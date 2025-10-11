local Threader = require(script.Parent.Parent.Packages.faye)
local TextPlus = require(script.Parent.Parent)
local Types = require(script.Parent.Parent.Packages._Index["prophetouw_faye@1.8.1"].faye.Types)
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
            local Text = TextPlus.new("First style: [Rainbow](style={{Rainbow,Reverse=true,Repeat = 1},Shrink,{Rise,Reverse = true,Amplitude = 3,StepFactor = 2,DelayTime = .25}},Amplitude = 2,Chunks=3)",{
                --Size = 20;
                XAlignment = Enum.TextXAlignment.Center;
                YAlignment = Enum.TextYAlignment.Center;
                Scale = .5;
            });
            Text:Play(Entity)
            --[[task.delay(.25,function()
                Text:Print(Entity);
            end)]]
        end
    }

    return function()
        Thread:Clean();
    end
end
