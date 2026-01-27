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
            local Text = TextPlus.new("Hello world this [#name](Style=tteststyle) is an test id...",{
                XAlignment = Enum.TextXAlignment.Center;
                YAlignment = Enum.TextYAlignment.Center;
                Scaled = true;
                Scale = .5;
            });
            Text:RegisterLocalId("name", function()
                return "test - "..tostring(math.random(1,999))
            end);
            Text:RegisterLocalId("tteststyle","NewTestStyle")
            TextPlus:RegisterStyle("NewTestStyle", function(Letter: TextLabel, Progress: number, Transparency: number, Color: Color3, Size: UDim2, Position: UDim2, Amplitude: number?, Reversing: boolean?)
                Letter.TextTransparency = 1-Progress;
            end);
            TextPlus:UnRegisterStyle("NewTestStyle");
            Text:Play(Entity)
        end
    }

    return function()
        Thread:Clean();
    end
end
