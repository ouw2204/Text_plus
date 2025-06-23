return function(Letter: TextLabel,Progress: number,Transparency: number,Color: Color3,Size: UDim2,Position: UDim2,Amplitude: number?,Reversing: boolean?)
    Letter.TextTransparency = 1 - (Progress * (1 - Transparency))
end
