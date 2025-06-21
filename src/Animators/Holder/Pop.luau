local Spring = require(script.Parent.Utilities.Spring);
return function(Letter: TextLabel,Progress: number,Transparency: number,Color: Color3,Size: UDim2,Position: UDim2,Amplitude: number?,Initial: boolean?)
    Amplitude = (Amplitude) - (Progress*(Amplitude-1) )
    local Spring = Spring(Progress,2,.5)
    Letter.Size = UDim2.fromScale(Size.X.Scale*Spring*Amplitude,Size.Y.Scale*Spring*Amplitude)
    if Initial then
        Letter.TextTransparency = Transparency
    end
end
