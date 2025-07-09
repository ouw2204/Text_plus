local module = {}
module.__index = module;
local Types = require(script.Parent.Parent.Types)
local Defaults = require(script.Parent.Defaults)
local nilset = nil;
local AnimatorClass = require(script.Parent.AnimatorClass);
local Utility = require(script.Parent.Parent.Utility);

local tins = table.insert
local ss = string.sub
local min = math.min
return function(Content: Types.PlayableType, WaitTime: number,parentAbs: Vector2)
    if Content.LastRunSuccessful == false then
        warn(`Something went wrong while running Text+ so the programmed was terminated.`)
        Content:Destroy()
        return;
    end
    Content.LastRunSuccessful = false;
    if (Content.Timer == nil or Content.Timer+WaitTime > (Content.CurrentStep or Content.Settings.Step or Defaults.Step)/(Content.CurrentSpeed or Content.Settings.Speed or Defaults.Speed)) and Content.__Broke == nil then
        local TextSize = Content.Settings.Size;
        if Content.Settings.Scaled then
            TextSize = min(min(parentAbs.Y,100)* (Content.CurrentScale or Content.Settings.Scale or 1),100)
        end
        
        local Cont = Content.Sequence[Content.CurrentIndex];
        if Cont == nil then Content:Break(); Content.LastRunSuccessful = true return end;
        local IncreaseCurentIndex = false;
        local IncreaseCurentIndexPosition = false;
        local IncreaseCurrentCharacterPosition = false;
        local Pass = false;
        if Content.List == nil then
            local Txt = Content.Sequence[Content.CurrentIndex];
            if typeof(Txt) == "table" then
                Txt = Txt.Text;
            end
            local List,Count = Utility.splitWordsAndSpaces(Txt);
            Content.List = List;
            Content.Count = Count;
        end
        
        --< validators
        if Content.Count == nil or Content.Count == 0 then
            if Content.CurrentIndex >= Content.SequenceCount then
                Content:Break(); Content.LastRunSuccessful = true; Content.LastRunSuccessful = true return
            else
                IncreaseCurentIndex = true;
                if Content.List ~= nil then
                    table.clear(Content.List)
                end
                Content.Count = nil;
                Content.List = nil;
            end
        else
            if Content.CurrentIndexPosition > Content.Count then
                IncreaseCurentIndex = true;
                Content.CurrentIndexPosition = 1;
                Content.Count = nil;
                if Content.List ~= nil then
                    table.clear(Content.List)
                end
                Content.List = nil;
            else
                -- do character check
                if Content.List ~= nil then
                    if Content.Word == nil then
                        Pass = true;
                        Content.Word = Content.List[Content.CurrentIndexPosition];
                        Content.WordLength = #Content.Word;
                        
                        --<ids
                        if Content.Params ~= nil and (Content.Word == "#" or ss(Content.Word,1,1) == "#") then
                            if Content.Word == "#" and Content.Params then
                                --< image
                                if Content.Params.img ~= nil then
                                    local Image = Instance.new("ImageLabel");
                                    Image.Name = "img - "..Content.Params.img
                                    Image.Size = if Content.Settings.Scaled then UDim2.fromScale(TextSize/parentAbs.X,TextSize/parentAbs.Y) else UDim2.fromOffset(TextSize,TextSize)
                                    Image.Parent = Content.Frame;
                                    Image.BackgroundTransparency = 1;
                                    Image.Image = "rbxassetid://"..Content.Params.img
                                    Pass = false;
                                    IncreaseCurentIndexPosition = true;
                                    Content.Word = nil;
                                end
                                --> image
                            else
                                --< functions
                                local id = ss(Content.Word,min(2,Content.WordLength),Content.WordLength)
                                if id ~= nil then
                                    local newWord = Content:GetIdValue(id) or id;
                                    Content.Word = newWord;
                                    Content.WordLength = #Content.Word;
                                    
                                    -- Always reset character position for the new word
                                    Content.CurrentCharacterPosition = min((Content.Chunks or Content.Settings.Chunks or 1), Content.WordLength);
                                    Content.PrevCharacterPosition = nil; -- Also reset previous position
                                end
                                --> functions
                            end
                        end
                        --> ids
                        if Pass then
                            --< word instance creation
                            Content.CurrentCharacterPosition = min((Content.Chunks or Content.Settings.Chunks or 1),Content.WordLength);
                            Content.PrevCharX = 0;
                            local WordInstance = Instance.new("TextLabel");
                            WordInstance.Name = Content.Word;
                            WordInstance.Parent = Content.Frame;
                            WordInstance.TextTransparency = 1;
                            WordInstance.TextSize = TextSize;
                            WordInstance.Text = Content.Word;
                            WordInstance.TextXAlignment = Content.Settings.XAlignment or Enum.TextXAlignment.Left;
                            WordInstance.TextYAlignment = Content.Settings.YAlignment or Enum.TextYAlignment.Top;
                            WordInstance.BackgroundTransparency = 1;
                            if Content.Settings.FontFace ~= nil or Content.CurrentFontFace ~= nil then
                                WordInstance.FontFace = Content.CurrentFontFace or Content.Settings.FontFace;
                            else
                                WordInstance.Font = Content.CurrentFont or Content.Settings.Font or Enum.Font.SourceSans;
                            end
                            WordInstance.TextColor3 = Content.Settings.Color or Color3.new(1,1,1);
                            local Bounds = WordInstance.TextBounds;
                            if Content.Settings.Scaled then
                                WordInstance.Size = UDim2.fromScale(Bounds.X/parentAbs.X,TextSize/parentAbs.Y);
                                WordInstance.TextScaled = true;
                            else
                                WordInstance.Size = UDim2.fromOffset(Bounds.X,TextSize);
                            end
                            Content.WordInstance = WordInstance;
                            local ContentSize = Content.ListObject.AbsoluteContentSize;
                            if not Content.Settings.Overfill and (ContentSize.X > parentAbs.X or ContentSize.Y > parentAbs.Y) then
                                WordInstance.Parent = nil;
                                WordInstance:Destroy();
                                Content.Word = nilset;
                                Content:Break();
                                Content.CurrentAnimation = nil;
                                Content.LastRunSuccessful = true
                                return
                            end
                            if string.match(Content.Word,"%s+") == Content.Word then
                                Content.Word = nilset;
                                Content.CurrentAnimation = nil;
                                IncreaseCurentIndexPosition = true;
                            else
                                local Animation = AnimatorClass(Content, Content.WordInstance,Content.Params or nil,Content.Settings);
                                tins(Content.Animations,Animation);
                                Content.CurrentAnimation = Animation;
                            end
                        end
                        --> word instance creation
                    end
                    if Content.Word ~= nil then
                        --< letters
                        if Content.CurrentCharacterPosition > Content.WordLength then
                            IncreaseCurentIndexPosition = true;
                            Content.Word = nilset;
                            Content.WordLength = nilset;
                            Content.CurrentCharTxt = nil;
                            Content.CurrentCharacterPosition = nil;
                            Content.PrevCharacterPosition = nil;
                            Content.CurrentAnimation = nil;
                        else
                            IncreaseCurrentCharacterPosition = true;
                            local String = ss(Content.Word,0,Content.CurrentCharacterPosition)
                            local Char = ss(Content.Word,(Content.PrevCharacterPosition or 0) +1 ,Content.CurrentCharacterPosition)
                            local Txt = Instance.new("TextLabel");
                            Txt.Name = Char;
                            --Content.CurrentCharTxt = Txt;
                            Txt.Size = UDim2.fromScale(1,1);
                            Txt.TextTransparency = 1;
                            Txt.Parent = Content.WordInstance;
                            Txt.TextSize = TextSize;
                            Txt.TextScaled = true;
                            Txt.AnchorPoint = Vector2.new(.5,.5);
                            Txt.TextXAlignment = Enum.TextXAlignment.Center;
                            Txt.TextYAlignment = Enum.TextYAlignment.Center;
                            Txt.BackgroundTransparency = 1;
                            if Content.Settings.FontFace ~= nil or Content.CurrentFontFace ~= nil then
                                Txt.FontFace = Content.CurrentFontFace or Content.Settings.FontFace;
                            else
                                Txt.Font = Content.CurrentFont or Content.Settings.Font or Enum.Font.SourceSans;
                            end
                            Txt.Text = String;
                            local FullBounds = Txt.TextBounds.X;
                            local Difference = FullBounds-Content.PrevCharX;
                            Txt.Text = Char;
                            Txt.TextColor3 = Content.Settings.Color or Color3.new(1,1,1);
                            local X = Difference/Content.WordInstance.AbsoluteSize.X
                            Txt.Size = UDim2.fromScale(X,1);
                            Txt.Position = UDim2.fromScale(Content.PrevCharX/Content.WordInstance.AbsoluteSize.X + X/2,.5);
                            Content.PrevCharX = FullBounds;

                            if Content.CurrentAnimation ~= nil then
                                Content.CurrentAnimation:AddLetter(Txt)
                            end
                        end
                        --> letters
                    end
                else
                    IncreaseCurentIndexPosition = true;
                end
            end
        end
        --> validators
        if not IncreaseCurentIndex and not IncreaseCurentIndexPosition and not IncreaseCurrentCharacterPosition and not Pass then
            Content:Break(); Content.LastRunSuccessful = true return
        end
        if IncreaseCurentIndex then
            Content.CurrentIndex = (Content.CurrentIndex or 1)+1;
            local fetch = Content.Sequence[Content.CurrentIndex];
            if fetch ~= nil and fetch.Params ~= nil then
                if fetch.Params then
                    Content.CurrentStep = fetch.Params.step;
                    Content.Chunks = fetch.Params.chunks;
                    Content.CurrentScale = fetch.Params.scale
                    Content.CurrentColor = fetch.Params.color;
                    Content.CurrentTransparency = fetch.Params.transparency
                    Content.CurrentSpeed = fetch.Params.speed
                    Content.CurrentAmplitude = fetch.Params.amplitude
                    Content.CurrentFontFace = fetch.Params.fontface
                    Content.CurrentFont = fetch.Params.font;
                end;
                Content.Params = fetch.Params;
            else
                Content.CurrentFont = nil;
                Content.CurrentAmplitude = nil;
                Content.Params =nil;
                Content.CurrentAmplitude = nil;
                Content.CurrentSpeed = nil;
                Content.CurrentTransparency = nil;
                Content.CurrentColor = nil;
                Content.CurrentScale = nil;
                Content.Chunks = nil;
                Content.CurrentStep = nil;
            end
        elseif IncreaseCurentIndexPosition then
            Content.CurrentIndexPosition = (Content.CurrentIndexPosition or 1)+1;
        elseif IncreaseCurrentCharacterPosition then
            local Chunk = (Content.Chunks or Content.Settings.Chunks or 1)
            Content.PrevCharacterPosition = Content.CurrentCharacterPosition
            if Content.CurrentCharacterPosition < Content.WordLength and Content.CurrentCharacterPosition+Chunk > Content.WordLength then
                Content.CurrentCharacterPosition = Content.WordLength;
            else
                Content.CurrentCharacterPosition += Chunk;
            end
        end
        --> validators
        Content.Timer = 0; -- timer reset
    else
        Content.Timer = (Content.Timer and Content.Timer+WaitTime) or WaitTime; -- timer update
    end
    local TotalAnims = #Content.Animations
    if TotalAnims >0 then
        for i = 1,TotalAnims do
            local Animation = Content.Animations[i];
            if Animation ~= nil and Animation.HasUpdate then 
                Animation:Update()
            end
        end
    elseif Content.__DeleteWhenDone then
        Content:Destroy();
    end
    Content.LastRunSuccessful = true;
end
