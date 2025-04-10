local TextPlus = require(script.Parent.Parent)
return function(Target)
    local Frame = Instance.new("Frame");
    Frame.Size = UDim2.fromScale(.4,.4);
    Frame.BackgroundTransparency = .5;
    Frame.Position = UDim2.fromScale(.5,.5);
    Frame.AnchorPoint = Vector2.new(.5,.5);
    Frame.Parent = Target;
    local Txt = TextPlus.Initiate({
        Scale = .5;
        TextXAlignment = Enum.TextXAlignment.Left;
        TextYAlignment = Enum.TextYAlignment.Top;
    }):Add("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse libero leo, molestie sit amet eros vel, semper convallis augue. In hac habitasse platea dictumst. Proin lacinia venenatis placerat. Integer molestie arcu at leo scelerisque, non pretium neque pulvinar. Fusce iaculis tristique nunc, vitae congue est pellentesque quis. Nulla molestie velit eu tellus faucibus maximus. Suspendisse tellus quam, iaculis vitae odio sed, semper iaculis libero. Curabitur nec magna mollis, interdum diam ut, tristique tortor. Mauris consequat nisl mi, nec mattis felis vestibulum quis. Nunc sem lorem, pellentesque sit amet lorem eget, molestie tempus turpis. Proin egestas consequat faucibus.");
    Txt:Play(Frame)
    return function()
        Frame:Destroy()
    end
end
