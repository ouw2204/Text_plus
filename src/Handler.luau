local module = {}

module.__index = module;
local RunService = game:GetService("RunService");
local AnimatorManager = require(script.Parent.Animators.AnimatorManager);
local tof = typeof
function module:Play(ParentFrame: Frame)
    self.__playing = true;
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
    task.delay(5,function()
        if self.RenderStep ~= nil then
            self.RenderStep:Disconnect();
            self.RenderStep = nil;
        end
        --self.Frame:Clone().Parent = workspace
    end)
    --> 
   
end
function module:Stop()
    self:Break(true)
    if self.Animations ~= nil then
        for i = #self.Animations,1,-1 do
            self.Animations[i]:Destroy();
            self.Animations[i] = nil;
        end
    end
    if self.List ~= nil then
        for i = #self.List,1,-1 do
            if self.List[i] ~= nil then
                self.List[i] = nil;
            end
        end
        self.List = nil;
    end
    self.CurrentAnimation = nil;
    self.Count = nil;
    self.WordLength = nil;
    self.PrevCharX = nil;
    self.PrevCharacterPosition = nil;
    self.Word = nil;
    self.LastRunSuccessful = nil;
    self.CurrentCharacterPosition = nil;
    self.CurrentIndex = nil;
    self.CurrentIndexPosition = nil;
    self.WordInstance = nil;
    self.__Broke = nil;
    self.Timer = nil; 
    self.__DeleteWhenDone = nil;
    self.Animations = nil;
end
function module:Destroy()
    print("destroyed")
    self:Stop();
    self.Frame = nil;
    self.ListObject = nil;
    for i = #self.Sequence,1,-1 do
        self.Sequence[i] = nil;
    end
    self.Sequence = nil;
    self.SequenceCount = nil;
    for i,v in pairs(self.Settings) do
        self.Settings[i] = nil;
    end
    self.Settings = nil;
    setmetatable(self,nil)
end
function module:Break(Strict: boolean)
    print("broke")
    self.__Broke = true;
    if self.Animations == nil or #self.Animations == 0 or Strict then
        if self.RenderStep ~= nil then
            self.RenderStep:Disconnect();
            self.RenderStep = nil;
        end
    else
        self.__DeleteWhenDone = true;
    end
   self.__playing = nil;
end
function module:Print(ParentFrame: Frame)
    if ParentFrame == nil then return end;
    if self.__playing then
        self:Stop()
    end;
    if self.Frame ~= nil then
        self.Frame:Destroy();
        self.Frame = nil;
    end
    self.ListObject = nil;


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

    local TextSize = self.Settings.Size;
    if self.Settings.Scaled then
        TextSize = math.min(math.min(parentAbs.Y,100)* (self.CurrentScale or self.Settings.Scale or 1),100)
    end
    for i = 1,self.SequenceCount do
        local Font,Color,Transparency,InnerTextSize = self.Settings.Font,self.Settings.Color,self.Settings.Transparency,TextSize;
        if tof(self.Sequence[i]) == "table" then
            print(self.Sequence[i])
        else
            
        end
    end
    self:Destroy()
end
return module;