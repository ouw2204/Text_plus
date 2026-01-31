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
            local Text = TextPlus.new("Hello world [RedText [secondweight [InnersecondWeight]<Color=rgb(255,0,255)> ]<Color=rgb(0,50,255)> [thirdwreight] [fourthwreight]<color=rgb(0,255,0),Style=Pop> ]<Color = rgb(255,1,3),Scale=.75,Style = (Rainbow,Wiggle),stepfactor=1> vvasd...",{
                Size = 20;
                XAlignment = Enum.TextXAlignment.Center;
                YAlignment = Enum.TextYAlignment.Center;
                Scaled = true;
                --Scale = .5;
                Step =  .05;
                StrokeColor = Color3.new();
                StrokeTransparency = .2;
                ContentScaled = true;
            });
            
            Text:Play(Entity)
            local Anim = Thread:LoadAnimation(Entity,{Size = UDim2.fromScale(.3,.3)})
            Anim:Play()
        end
    }

    return function()
        Thread:Destroy();
    end
end
