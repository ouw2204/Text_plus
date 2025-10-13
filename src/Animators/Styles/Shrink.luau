return function(Letter: TextLabel,Progress: number,Transparency: number, StrokeTransparency: number,Color: Color3,StrokeColor: Color3,Size: UDim2,Position: UDim2,Amplitude: number?,Reversing: boolean?)
    Amplitude = (Amplitude) - (Progress*(Amplitude-1) )
    Letter.Size = UDim2.fromScale(Size.X.Scale + ((1-Progress)*.5*Amplitude),Size.Y.Scale + ((1-Progress)*.5*Amplitude))
end
