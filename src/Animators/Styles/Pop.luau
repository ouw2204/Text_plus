local Spring = require(script.Parent.Utilities.Spring);
return function(Letter: TextLabel,Progress: number,Transparency: number, StrokeTransparency: number,Color: Color3,StrokeColor: Color3,Size: UDim2,Position: UDim2,Amplitude: number?,Reversing: boolean?)
    Amplitude = (Amplitude) - (Progress*(Amplitude-1) )
    local Spring = Spring(Progress,2,.5)
    Letter.Size = UDim2.fromScale(Size.X.Scale*Spring*Amplitude,Size.Y.Scale*Spring*Amplitude)
end
