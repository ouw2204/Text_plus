local Types = require(script.Parent.Parent.Parent.TextPlusTypes)
local RainbowColors = {
    [1] = Color3.fromRGB(255,0,0);
    [2] = Color3.fromRGB(255,165,0);
    [3] = Color3.fromRGB(255,255,0);
    [4] = Color3.fromRGB(0,128,0);
    [5] = Color3.fromRGB(0,255,255);
    [6] = Color3.fromRGB(0,0,255);
    [7] = Color3.fromRGB(128,0,128);
}
local function LerpColor(colorA, colorB, t)
    -- Clamp t between 0 and 1
    t = math.clamp(t, 0, 1)

    return Color3.new(
        colorA.R + (colorB.R - colorA.R) * t,
        colorA.G + (colorB.G - colorA.G) * t,
        colorA.B + (colorB.B - colorA.B) * t
    )
end

local Step = 1/8
local mf = math.floor
return function(Letter: TextLabel,Progress: number,Transparency: number,Color: Color3,Size: UDim2,Position: UDim2,Amplitude: number?,Reversing: boolean?)
    local Current = mf(Progress*7)
    local CurentScope = (Current*(Step))
    local prog = (Progress-CurentScope)/Step
    local final = RainbowColors[Current+1]
    if Current == 7 then
        final = Color;
    end
    Letter.TextColor3 = LerpColor(RainbowColors[Current] or Color,final, prog)
end
