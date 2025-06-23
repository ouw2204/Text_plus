return function(Letter: TextLabel,Progress: number,Transparency: number,Color: Color3,Size: UDim2,Position: UDim2,Amplitude: number?,Reversing: boolean?)
    Amplitude = .25* Amplitude
    Letter.Position = UDim2.fromScale(Letter.Position.X.Scale,Position.Y.Scale+(Amplitude*(1-Progress)))
end
