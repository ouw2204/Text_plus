return function(Letter: TextLabel,Progress: number,Transparency: number, StrokeTransparency: number,Color: Color3,StrokeColor: Color3,Size: UDim2,Position: UDim2,Amplitude: number?,Reversing: boolean?)
    Letter.TextTransparency = Transparency;
    Letter.TextColor3 = Color;
    return true;
end
