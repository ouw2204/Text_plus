local module = {}

module.__index = module;
local RunService = game:GetService("RunService");
local Storage = require(script.Parent.Storage)
local AnimatorManager = require(script.Parent.Animators.AnimatorManager);
local Utility = require(script.Parent.TextPlusUtility)
local tof = typeof
local functiontxt = "function"
local tabletxt = "table";
local Defaults = require(script.Parent.Animators.Defaults)

local DefaultX = Enum.TextXAlignment.Left;
local DefaultY = Enum.TextYAlignment.Top;
local ss = string.sub
local min = math.min
local ListName = "List";
local ud2f = UDim2.fromScale;
local ud2fo = UDim2.fromOffset;

local v2zero = Vector2.new(0,0)
function module:GetContentSize(ParentFrame: Frame)
    if ParentFrame == nil  then return end;
    if ParentFrame.Parent == nil or ParentFrame.Parent.Parent == nil then warn("Parent frame is not parented correctely") return v2zero end;
    if  ParentFrame.AbsoluteSize.Y <= 0 then warn("Parent frame is too small") return v2zero end;
    --< Get Initial Text Size
    if self.RawContent ~= nil and self.Sequence == nil then
        self.Sequence = Utility.Phase1(self.RawContent,self);
        self.SequenceCount = #self.Sequence
        self.RawContent = nil;
    end
    

    local parentAbs = ParentFrame.AbsoluteSize
    local Container = Instance.new("Frame");
    Container.Name = "TextPlusTextHolder";
    Container.Size =  (self.Settings.ContentScaled and ud2f(1,1)) or UDim2.fromOffset(parentAbs.X,parentAbs.Y);
    Container.BackgroundTransparency = 1;
    Container.Parent = ParentFrame;
    local ScaledEligible = ParentFrame.AbsoluteSize.X >0
    local List = Instance.new"UIListLayout"
    List.Parent = Container;
    List.Name = "List";
    List.SortOrder = Enum.SortOrder.LayoutOrder;
    self:ApplyAlignments(Container, List)
    List.FillDirection = Enum.FillDirection.Horizontal;
    List.Wraps = self.Settings.Wrapped;
    for _,v in ipairs(self.Sequence) do
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
            Scale = Params.scale or Scale;
            TextSize = Params.size or TextSize;
            fontface = Params.fontface or fontface;
            font = Params.font or font
            img = Params.img
        end;
        if self.Settings.Scaled then
            TextSize = math.min(math.min(parentAbs.Y,100)*Scale,100)
        end
        
        for _,Word in ipairs(Split) do
            
            --<ids
            if (Word == "#" or ss(Word,1,1) == "#") then
                if Word == "#" then
                    --< image
                    if img ~= nil then
                        local Image = Instance.new("ImageLabel");
                        Image.Name = "img - "..img
                        Image.Size = if self.Settings.Scaled and ScaledEligible then ud2f(TextSize/parentAbs.X,TextSize/parentAbs.Y) else ud2fo(TextSize,TextSize)
                        Image.ImageTransparency = 1;
                        Image.Parent = Container;
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
            WordInstance.Parent = Container;
            if fontface ~= nil then
                WordInstance.FontFace = fontface;
            else
                WordInstance.Font = font or Defaults.Font;
            end
            local Bounds = WordInstance.TextBounds;
            if self.Settings.Scaled and ScaledEligible then
                WordInstance.Size = ud2f(Bounds.X/parentAbs.X,TextSize/parentAbs.Y);
                WordInstance.TextScaled = true;
            else
                WordInstance.Size = ud2fo(Bounds.X,TextSize);
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
    local Abs = Container.List.AbsoluteContentSize;
    Container:Destroy()
    return Abs;
    --> Get Initial size
end
function module:ApplyAlignments(Container: any, List: UIListLayout)
    if List == nil then return end;
    do
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
        Container.AnchorPoint = Vector2.new(XAnchor,YAnchor)
        Container.Position = ud2f(XAnchor,YAnchor)
    end
end
function module:Play(ParentFrame: Frame)
    if ParentFrame == nil then return end;
    if ParentFrame.Parent == nil or ParentFrame.Parent.Parent == nil then warn("Parent frame is not parented correctely") return self end;
    if  ParentFrame.AbsoluteSize.Y <= 0 then warn("Parent frame is too small") return self end;

    self.__playing = true;
    if self.RawContent ~= nil and self.Sequence == nil then
        self.Sequence = Utility.Phase1(self.RawContent,self);
        self.SequenceCount = #self.Sequence
        self.RawContent = nil;
    end
    if self.RenderStep ~= nil then
        self.RenderStep:Disconnect();
        self.RenderStep = nil;
    end
    if self.Container ~= nil then
        self.Container:Destroy();
    end

    self.Container = (self.Settings.UseCanvas and Instance.new("CanvasGroup")) or Instance.new"Frame";
    self.Container.Name = "TextPlusTextHolder";
    if self.Settings.ContentScaled then
        self.Container.Size =  ud2f(1,1)
    end;
    self.Container.BackgroundTransparency = 1;
    self.Container.Parent = ParentFrame;
    local List = Instance.new"UIListLayout"
    List.Parent = self.Container;
    List.Name = "List";
    List.SortOrder = Enum.SortOrder.LayoutOrder;
    self.ListObject = List;


    --
    self:ApplyAlignments(self.Container, List)

    List.FillDirection = Enum.FillDirection.Horizontal;
    List.Wraps = self.Settings.Wrapped;
    self.CurrentIndex = 1;
    self.CurrentIndexPosition = 1;
    self.CurrentCharacterPosition = 1;
    local parentAbs = nil;
    local ScaledEligible
    self.RenderStep = RunService.Heartbeat:Connect(function(waitTime)
        if parentAbs == nil then
            parentAbs = ParentFrame.AbsoluteSize
            ScaledEligible = ParentFrame.AbsoluteSize.X >0
            if not self.Settings.ContentScaled then
                self.Container.Size = UDim2.fromOffset(parentAbs.X,parentAbs.Y)
            end
        end
        AnimatorManager(self,waitTime,parentAbs,ScaledEligible)
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
local PropsToCopy = {
    TextSize = "Size",
    TextColor3 = "Color",
    TextTransparency = "Transparency",
    TextStrokeColor3 = "StrokeColor",
    TextStrokeTransparency = "StrokeTransparency",
    FontFace = "FontFace",
    TextXAlignment = "XAlignment",
    TextYAlignment = "YAlignment",
}

local tf = table.find
function module:From(TextLabel: TextLabel, Exclusions: (string | {string})?)
    
    if TextLabel == nil or TextLabel.ClassName ~= "TextLabel" then return self end;
    local ExclusionsIsTable = tof(Exclusions) == tabletxt
    for i,v in pairs(PropsToCopy) do
        if Exclusions ~= nil then
            if Exclusions == v or Exclusions == i then continue end;
            if ExclusionsIsTable and (tf(Exclusions,v) ~= nil or tf(Exclusions,i) ~= nil) then continue end;

        end
        self.Settings[v] = TextLabel[i]
    end

    return self;
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
    if self.__playing then
       if self.Settings.OnFinished ~= nil then
            self.Settings.OnFinished(self);
       end
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

function module:Destroy()
    self:__removeRoutines();
    self:Stop();
    self.Container = nil;
    self.ListObject = nil;
    for i = #self.Sequence,1,-1 do
        self.Sequence[i] = nil;
    end
    self.Sequence = nil;
    self.SequenceCount = nil;

    self.RawContent = nil;

end

local threadtxt = "thread"
function module:__addRoutine()
    local newThread: thread = coroutine.running()
    if self.__routine ~= nil then
        if typeof(self.__routine) == threadtxt  then
            warn(1111)
            self.__routine = {
                self.__routine,
            }
        end
        table.insert(self.__routine,newThread)
    else
        self.__routine = newThread;
    end
    return newThread;
end
function module:__removeRoutines()
    if self.__routine ~= nil then
        if tof(self.__routine) == threadtxt then
            coroutine.resume(self.__routine)
        else
            for i = #self.__routine,1,-1 do
                coroutine.resume(self.__routine[i])
            end
        end
        self.__routine = nil;
        
    end
end
function module:Wait()
    if self.__playing then
        self:__addRoutine()
        coroutine.yield()
    else
        warn("Text+ Writer is not currently running so the :Wait function can not be used.")
    end
    return self,self.Container;
end
function module:Print(ParentFrame: Frame)
    if ParentFrame == nil then return end;
    if ParentFrame.Parent == nil or ParentFrame.Parent.Parent == nil then warn("Parent frame is not parented correctely") return v2zero end;
    if  ParentFrame.AbsoluteSize.Y <= 0 then warn("Parent frame is too small") return v2zero end;
    self:__removeRoutines();
    local ScaledEligible = ParentFrame.AbsoluteSize.X >0

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


    local parentAbs = ParentFrame.AbsoluteSize
    local List
    if self.Container == nil then
        self.Container = (self.Settings.UseCanvas and Instance.new("CanvasGroup")) or Instance.new"Frame";
        self.Container.Name = "TextPlusTextHolder";
        self.Container.Size = (self.Settings.ContentScaled and ud2f(1,1)) or UDim2.fromOffset(parentAbs.X,parentAbs.Y);
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
    self:ApplyAlignments(self.Container, List)

    List.FillDirection = Enum.FillDirection.Horizontal;
    List.Wraps = self.Settings.Wrapped;
    if self.RawContent ~= nil and self.Sequence == nil then
        self.Sequence = Utility.Phase1(self.RawContent,self);
        self.SequenceCount = #self.Sequence
        self.RawContent = nil;
    end
    for i = 1,self.SequenceCount do
        local TextSize,Color,StrokeColor,Transparency,StrokeTransparency,Scale,fontface,font,img = self.Settings.Size,self.Settings.Color,self.Settings.StrokeColor,self.Settings.Transparency,self.Settings.StrokeTransparency,self.Settings.Scale or 1,self.Settings.FontFace,self.Settings.Font,nil;
        local Text = nil;
        if tof(self.Sequence[i]) == "table" then
            Text = self.Sequence[i].Text;
            if self.Sequence[i].Params then
                Color = self.Sequence[i].Params.color or Color;
                Scale = self.Sequence[i].Params.scale or Scale;
                TextSize = self.Sequence[i].Params.size or TextSize;
                Transparency = self.Sequence[i].Params.transparency or Transparency;
                StrokeTransparency = self.Sequence[i].Params.stroketransparency or StrokeTransparency
                StrokeColor = self.Sequence[i].Params.strokecolor or StrokeColor;
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
                            Image.Size = if self.Settings.Scaled and ScaledEligible then ud2f(TextSize/parentAbs.X,TextSize/parentAbs.Y) else ud2fo(TextSize,TextSize)
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
                WordInstance.TextStrokeTransparency = StrokeTransparency or Defaults.StrokeTransparency;
                WordInstance.TextStrokeColor3 = StrokeColor or Defaults.StrokeColor;
                if fontface ~= nil then
                    WordInstance.FontFace = fontface;
                else
                    WordInstance.Font = font or Defaults.Font;
                end
                WordInstance.TextColor3 = Color or Defaults.Color;
                local Bounds = WordInstance.TextBounds;
                if self.Settings.Scaled and ScaledEligible then
                    WordInstance.Size = ud2f(Bounds.X/parentAbs.X,TextSize/parentAbs.Y);
                    WordInstance.TextScaled = true;
                else
                    WordInstance.Size = ud2fo(Bounds.X,TextSize);
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