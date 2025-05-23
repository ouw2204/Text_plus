local module = {}

module.__index = module;
local RunService = game:GetService("RunService");
local AnimatorManager = require(script.Parent.Animators.AnimatorManager);
function module:Play(ParentFrame: Frame)
    if self.RenderStep ~= nil then
        self.RenderStep:Disconnect();
        self.RenderStep = nil;
    end
    if self.Frame ~= nil then
        self.Frame:Destroy();
    end
    local isBillBoard = ParentFrame:FindFirstAncestorOfClass("BillboardGui") ~= nil;
    local parentAbs = ParentFrame.AbsoluteSize
    self.Frame = Instance.new"Frame";
    self.Frame.Name = "TextPlusTextHolder";
    self.Frame.Size = (isBillBoard and UDim2.fromScale(1,1)) or UDim2.fromOffset(parentAbs.X,parentAbs.Y);
    self.Frame.BackgroundTransparency = .9;
    self.Frame.Parent = ParentFrame;
    local List = Instance.new"UIListLayout"
    List.Parent = self.Frame;
    List.Name = "List";
    List.SortOrder = Enum.SortOrder.LayoutOrder;
    self.ListObject = List;
    --
    if not (isBillBoard) then
        local XAnchor,YAnchor = 0,0;
        if self.Settings.YAlignment == Enum.TextYAlignment.Center then
            List.VerticalAlignment = Enum.VerticalAlignment.Center;
            YAnchor = .5;
        elseif self.Settings.YAlignment == Enum.TextYAlignment.Bottom then
            List.VerticalAlignment = Enum.VerticalAlignment.Bottom;
            YAnchor = 1;
        end
        if self.Settings.XAlignment == Enum.TextXAlignment.Center then
            List.HorizontalAlignment = Enum.HorizontalAlignment.Center;
            XAnchor = .5;
        elseif self.Settings.XAlignment == Enum.TextXAlignment.Right then
            List.HorizontalAlignment = Enum.HorizontalAlignment.Right;
            XAnchor = 1;
        end
        self.Frame.AnchorPoint = Vector2.new(XAnchor,YAnchor)
        self.Frame.Position = UDim2.fromScale(XAnchor,YAnchor)
    end;
    List.FillDirection = Enum.FillDirection.Horizontal;
    List.Wraps = self.Settings.Wrapped or false;
    self.CurrentIndex = 1;
    self.CurrentIndexPosition = 1;
    self.CurrentCharacterPosition = 1;
    self.SequenceCount = #self.Sequence;
    self.RenderStep = RunService.Heartbeat:Connect(function(waitTime)
        AnimatorManager(self,waitTime,parentAbs)
    end)
    --< max allowed testing time
    --[[task.delay(5,function()
        if self.RenderStep ~= nil then
            self.RenderStep:Disconnect();
            self.RenderStep = nil;
        end
    end)]]
    --> 
   
end
function module:Break()
    -- "Break"
    if self.RenderStep ~= nil then
        self.RenderStep:Disconnect();
        self.RenderStep = nil;
    end
   
end
function module:Destroy()
    -- "Destroy"
    self:Break();
    if self.Frame ~= nil then
        self.Frame:Destroy();
    end
end
return module;