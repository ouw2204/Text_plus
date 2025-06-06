local Types = require(script.Parent.Parent.Parent.Types)
return function(Letter: TextLabel,Progress: number,Transparency: number,Color: Color3,Size: UDim2,Position: UDim2)
    print("ye")
    Letter.TextTransparency = Transparency;
    Letter.TextColor3 = Color;
    return true;
end
