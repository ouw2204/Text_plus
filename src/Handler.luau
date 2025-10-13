local module = {}

module.__index = module;
local RunService = game:GetService("RunService");
local Storage = require(script.Parent.Storage)
local AnimatorManager = require(script.Parent.Animators.AnimatorManager);
local Utility = require(script.Parent.TextPlusUtility)
local tof = typeof
local functiontxt = "function"
local tabletxt = "table";

local DefaultX = Enum.TextXAlignment.Left;
local DefaultY = Enum.TextYAlignment.Top;
local ss = string.sub
local min = math.min
local ListName = "List";

function module:Play(ParentFrame: Frame)
    self.__playing = true;
    if self.RawContent ~= nil and self.Sequence == nil then
        self.Sequence = Utility.Phase1(self.RawContent,self);
        self.RawContent = nil;
    end
    if self.RenderStep ~= nil then
        self.RenderStep:Disconnect();
        self.RenderStep = nil;
    end
    if self.Container ~= nil then
        self.Container:Destroy();
    end
    local isBillBoard = ParentFrame:FindFirstAncestorOfClass("BillboardGui") ~= nil;
    local parentAbs = ParentFrame.AbsoluteSize
    self.Container = (self.Settings.UseCanvas and Instance.new("CanvasGroup")) or Instance.new"Frame";
    self.Container.Name = "TextPlusTextHolder";
    self.Container.Size =  UDim2.fromScale(1,1) --UDim2.fromOffset(parentAbs.X,parentAbs.Y); --(isBillBoard and UDim2.fromScale(1,1)) or UDim2.fromOffset(parentAbs.X,parentAbs.Y);
    self.Container.BackgroundTransparency = 1;
    self.Container.Parent = ParentFrame;
    local List = Instance.new"UIListLayout"
    List.Parent = self.Container;
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
        self.Container.AnchorPoint = Vector2.new(XAnchor,YAnchor)
        self.Container.Position = UDim2.fromScale(XAnchor,YAnchor)
    end;
    List.FillDirection = Enum.FillDirection.Horizontal;
    List.Wraps = self.Settings.Wrapped or false;
    self.CurrentIndex = 1;
    self.CurrentIndexPosition = 1;
    self.CurrentCharacterPosition = 1;
    self.SequenceCount = #self.Sequence;

    
    --< Get Initial Text Size
    for i,v in ipairs(self.Sequence) do
        local istable = tof(v) == tabletxt
        local Split;
        local Params = nil
        if istable then
            Split = Utility.splitWordsAndSpaces(v.Text)
            Params = v.Params;
        else
            Split = Utility.splitWordsAndSpaces(v)
        end
        local broke = false;
        local TextSize,Scale,fontface,font,img = self.Settings.Size,self.Settings.Scale or 1,self.Settings.FontFace,self.Settings.Font,nil;
        if Params ~= nil then
            --[[Color = Params.color or Color;]]
            Scale = Params.scale or Scale;
            TextSize = Params.Size or TextSize;
            fontface = Params.fontface or fontface;
            font = Params.font or font
            img = Params.img
        end;
        if self.Settings.Scaled then
            TextSize = math.min(math.min(parentAbs.Y,100)*Scale,100)
        end
        for _,Word in pairs(Split) do
            
            --<ids
            if (Word == "#" or ss(Word,1,1) == "#") then
                if Word == "#" then
                    --< image
                    if img ~= nil then
                        local Image = Instance.new("ImageLabel");
                        Image.Name = "img - "..img
                        Image.Size = if self.Settings.Scaled then UDim2.fromScale(TextSize/parentAbs.X,TextSize/parentAbs.Y) else UDim2.fromOffset(TextSize,TextSize)
                        Image.ImageTransparency = 1;
                        Image.Parent = self.Container;
                        Image.BackgroundTransparency = 1;
                        Image.Image = "rbxassetid://"..img
                        continue
                    end
                    --> image
                else
                    --< functions
                    local WordLength = #Word;
                    local id = ss(Word,min(2,WordLength),WordLength)
                    if id ~= nil then
                        local newWord = self:GetIdValue(id) or id;
                        Word = newWord;
                    end
                    --> functions
                end
            end
            --> ids

            local WordInstance = Instance.new("TextLabel");
            WordInstance.Name = Word;
            WordInstance.TextSize = TextSize;
            WordInstance.Text = Word;
            WordInstance.TextXAlignment = self.Settings.XAlignment or DefaultX;
            WordInstance.TextYAlignment = self.Settings.YAlignment or DefaultY;
            WordInstance.BackgroundTransparency = 1;
            WordInstance.TextTransparency = 1;
            WordInstance.Parent = self.Container;
            if fontface ~= nil then
                WordInstance.FontFace = fontface;
            else
                WordInstance.Font = font or Enum.Font.SourceSans;
            end
            local Bounds = WordInstance.TextBounds;
            if self.Settings.Scaled then
                WordInstance.Size = UDim2.fromScale(Bounds.X/parentAbs.X,TextSize/parentAbs.Y);
                WordInstance.TextScaled = true;
            else
                WordInstance.Size = UDim2.fromOffset(Bounds.X,TextSize);
            end
            local ContentSize = List.AbsoluteContentSize;
            if not self.Settings.Overfill and (--[[ContentSize.X > parentAbs.X or ]]ContentSize.Y > parentAbs.Y) then
                WordInstance.Parent = nil;
                WordInstance:Destroy();
                broke = true;
                break
            end
        end
        if broke then
            break;
        end
    end
    local Abs = self.Container.List.AbsoluteContentSize;
    for _,v in self.Container:GetChildren() do
        if v.Name == ListName then continue end;
        v:Destroy();
    end
    self.ContentSize = Abs;
    --> Get Initial size


    self.RenderStep = RunService.Heartbeat:Connect(function(waitTime)
        AnimatorManager(self,waitTime,parentAbs)
    end)
    
   return self,self.Container;
end
function module:GetIdValue(Id: string)
    if Id == nil then return nil end;
    local fetched = Storage.IdsStorage[Id]
    if fetched ~= nil then
        if tof(fetched) == functiontxt then
            return fetched(self)
        else
            return fetched
        end
    end
    return nil;
end
function module:Stop()
    if self.RenderStep ~= nil then
        self.RenderStep:Disconnect();
        self.RenderStep = nil;
    end
    if self.SizeChangedConnection ~= nil then
       self.SizeChangedConnection:Disconnect()
       self.SizeChangedConnection = nil; 
    end
    self.__playing = nil;
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
    self.CurrentFontFace = nil;
    self.Timer = nil; 
    self.__Broke = nil;
    self.__DeleteWhenDone = nil;
    self.Animations = nil;
end
local tc = table.clear
function module:Destroy()
    if self.__routine ~= nil then
        coroutine.resume(self.__routine)
        self.__routine = nil;
    end
    self:Stop();
    self.Container = nil;
    self.ListObject = nil;
    for i = #self.Sequence,1,-1 do
        self.Sequence[i] = nil;
    end
    self.Sequence = nil;
    self.SequenceCount = nil;
    --[[for i,_ in pairs(self.Settings) do
        self.Settings[i] = nil;
    end]]
    self.RawContent = nil;
    --self.Settings = nil;
    setmetatable(self,nil)
    tc(self)
end


function module:Wait()
    if self.__playing then
        self.__routine = coroutine.running()
        coroutine.yield()
    else
        warn("Text+ Writer is not currently running so the :Wait function can not be used.")
    end
    return self,self.Container;
end
function module:Print(ParentFrame: Frame)
    if ParentFrame == nil then return end;
    if self.__playing then
        self:Stop()
    end;
    if self.Container ~= nil then
        for _,v in self.Container:GetChildren() do
            if v.Name == ListName then continue end;
            v:Destroy();
        end
    end
    self.ListObject = nil;


    local isBillBoard = ParentFrame:FindFirstAncestorOfClass("BillboardGui") ~= nil;
    local parentAbs = ParentFrame.AbsoluteSize
    local List
    if self.Container == nil then
        self.Container = (self.Settings.UseCanvas and Instance.new("CanvasGroup")) or Instance.new"Frame";
        self.Container.Name = "TextPlusTextHolder";
        self.Container.Size = (isBillBoard and UDim2.fromScale(1,1)) or UDim2.fromOffset(parentAbs.X,parentAbs.Y);
        self.Container.BackgroundTransparency = 1;
        self.Container.Parent = ParentFrame;
        List = Instance.new"UIListLayout"
        List.Parent = self.Container;
        List.Name = "List";
        List.SortOrder = Enum.SortOrder.LayoutOrder;
        self.ListObject = List;
    else
        List = self.Container.List;
    end;
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
        self.Container.AnchorPoint = Vector2.new(XAnchor,YAnchor)
        self.Container.Position = UDim2.fromScale(XAnchor,YAnchor)
    end;
    List.FillDirection = Enum.FillDirection.Horizontal;
    List.Wraps = self.Settings.Wrapped or false;
    if self.RawContent ~= nil and self.Sequence == nil then
        self.Sequence = Utility.Phase1(self.RawContent,self);
        self.SequenceCount = #self.Sequence
        self.RawContent = nil;
    end
    for i = 1,self.SequenceCount do
        local TextSize,Color,Transparency,Scale,fontface,font,img = self.Settings.Size,self.Settings.Color,self.Settings.Transparency,self.Settings.Scale or 1,self.Settings.FontFace,self.Settings.Font,nil;
        local Text = nil;
        if tof(self.Sequence[i]) == "table" then
            Text = self.Sequence[i].Text;
            if self.Sequence[i].Params then
                Color = self.Sequence[i].Params.color or Color;
                Scale = self.Sequence[i].Params.scale or Scale;
                TextSize = self.Sequence[i].Params.Size or TextSize;
                Transparency = self.Sequence[i].Params.transparency or Transparency;
                fontface = self.Sequence[i].Params.fontface or fontface;
                font = self.Sequence[i].Params.font or font
                img = self.Sequence[i].Params.img
            end;
        else
           Text = self.Sequence[i];
        end
        
        if Text ~= nil then
            
            if self.Settings.Scaled then
                TextSize = math.min(math.min(parentAbs.Y,100)*Scale,100)
            end
            local WordsList,Count = Utility.splitWordsAndSpaces(Text)
            for x = 1,Count do
                local Word = WordsList[x]


                --<ids
                if (Word == "#" or ss(Word,1,1) == "#") then
                    if Word == "#" then
                        --< image
                        if img ~= nil then
                            local Image = Instance.new("ImageLabel");
                            Image.Name = "img - "..img
                            Image.Size = if self.Settings.Scaled then UDim2.fromScale(TextSize/parentAbs.X,TextSize/parentAbs.Y) else UDim2.fromOffset(TextSize,TextSize)
                            Image.Parent = self.Container;
                            Image.BackgroundTransparency = 1;
                            Image.Image = "rbxassetid://"..img
                            continue
                        end
                        --> image
                    else
                        --< functions
                        local WordLength = #Word;
                        local id = ss(Word,min(2,WordLength),WordLength)
                        if id ~= nil then
                            local newWord = self:GetIdValue(id) or id;
                            Word = newWord;
                        end
                        --> functions
                    end
                end
                --> ids

                local WordInstance = Instance.new("TextLabel");
                WordInstance.Name = Word;
                WordInstance.Parent = self.Container;
                WordInstance.TextTransparency = Transparency;
                WordInstance.TextSize = TextSize;
                WordInstance.Text = Word;
                WordInstance.TextXAlignment = self.Settings.XAlignment or DefaultX;
                WordInstance.TextYAlignment = self.Settings.YAlignment or DefaultY;
                WordInstance.BackgroundTransparency = 1;
                if fontface ~= nil then
                    WordInstance.FontFace = fontface;
                else
                    WordInstance.Font = font or Enum.Font.SourceSans;
                end
                WordInstance.TextColor3 = Color or Color3.new(1,1,1);
                local Bounds = WordInstance.TextBounds;
                if self.Settings.Scaled then
                    WordInstance.Size = UDim2.fromScale(Bounds.X/parentAbs.X,TextSize/parentAbs.Y);
                    WordInstance.TextScaled = true;
                else
                    WordInstance.Size = UDim2.fromOffset(Bounds.X,TextSize);
                end
                local ContentSize = List.AbsoluteContentSize;
                 if not self.Settings.Overfill and (--[[ContentSize.X > parentAbs.X or ]]ContentSize.Y > parentAbs.Y) then
                    WordInstance.Parent = nil;
                    WordInstance:Destroy();
                    return
                end
            end
        end
    end;
    local ContentSize = List.AbsoluteContentSize;
    self:Destroy()
    return ContentSize;
end
return module;