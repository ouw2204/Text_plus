local function Bezier4(p0, p1, p2, p3, t)
    local u = 1 - t
    local tt = t * t
    local uu = u * u
    local uuu = uu * u
    local ttt = tt * t

    return uuu * p0
        + 3 * uu * t * p1
        + 3 * u * tt * p2
        + ttt * p3
end
local YScale = 0.2;
return function(Letter: TextLabel,Progress: number,Transparency: number,Color: Color3,Size: UDim2,Position: UDim2,Amplitude: number?,Reversing: boolean?)
    local YFactor = YScale*Amplitude
    local PosYScale = Position.Y.Scale
    Letter.Position = UDim2.fromScale(Letter.Position.X.Scale,Bezier4(PosYScale,PosYScale+YFactor,PosYScale-YFactor,PosYScale,Progress))
end
