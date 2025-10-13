return function(Letter: TextLabel,Progress: number,Transparency: number, StrokeTransparency: number,Color: Color3,StrokeColor: Color3,Size: UDim2,Position: UDim2,Amplitude: number?,Reversing: boolean?)
    Amplitude = .35* Amplitude
    Letter.Position = UDim2.fromScale(Letter.Position.X.Scale,Position.Y.Scale-(Amplitude*(1-Progress)))
end
