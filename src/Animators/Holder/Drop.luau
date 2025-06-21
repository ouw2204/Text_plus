return function(Letter: TextLabel,Progress: number,Transparency: number,Color: Color3,Size: UDim2,Position: UDim2,Amplitude: number?,Initial: boolean?)
    Amplitude = .35* Amplitude
    Letter.Position = UDim2.fromScale(Letter.Position.X.Scale,Position.Y.Scale-(Amplitude*(1-Progress)))
    if Initial then
        Letter.TextTransparency = Transparency
    end
end
