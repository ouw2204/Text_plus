return function(Letter: TextLabel,Progress: number,Transparency: number, StrokeTransparency: number,Color: Color3,StrokeColor: Color3,Size: UDim2,Position: UDim2,Amplitude: number?,Reversing: boolean?)
    Letter.TextTransparency = 1 - (Progress * (1 - Transparency))
    Letter.TextStrokeTransparency = 1 - (Progress * (1 - StrokeTransparency))
end
