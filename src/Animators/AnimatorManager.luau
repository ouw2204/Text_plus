local module = {}
module.__index = module;
local Types = require(script.Parent.Parent.TextPlusTypes)
local Defaults = require(script.Parent.Defaults)
local nilset = nil;
local AnimatorClass = require(script.Parent.AnimatorClass);
local Utility = require(script.Parent.Parent.TextPlusUtility);

local tins = table.insert
local ss = string.sub
local min = math.min

-- UTF-8 aware helpers to correctly handle multi-byte characters (accented, CJK, etc.)
local function utf8len(s: string): number
	return utf8.len(s) or #s
end
local function utf8sub(s: string, i: number, j: number): string
	local startByte = utf8.offset(s, i)
	local endByte = utf8.offset(s, j + 1)
	if startByte == nil then return "" end
	if endByte then
		return ss(s, startByte, endByte - 1)
	else
		return ss(s, startByte)
	end
end
local tof = typeof
local tabletxt = "table"
local DefaultX = Enum.TextXAlignment.Left;
local DefaultY = Enum.TextYAlignment.Top;
local ts = tostring

local ud2f = UDim2.fromScale;
local ud2fo = UDim2.fromOffset;

function Terminate(Content: Types.PlayableType)
    Content.__Broke = true;
    if Content.Animations == nil or #Content.Animations == 0 then
        Content:Destroy()
    else
        Content.__DeleteWhenDone = true;
    end
end
local Styles = require(script.Parent.Parent.Animators.AnimatorClass.Styles)
local emptyudm = UDim2.fromScale(1,1)
local tableType = "table"
return function(Content: Types.PlayableType, WaitTime: number,parentAbs: Vector2, ScaledEligible: boolean)
    if (Content.LastRunSuccessful == false and Content.__Broke == nil) or Content == nil or Content.Container == nil or Content.Container.Parent == nil then
        --warn(`Something went wrong while running Text+ so the programmed was terminated.`)
        Content:Destroy()
        return;
    end
    Content.LastRunSuccessful = false;
    if (Content.Timer == nil or Content.Timer+WaitTime > (Content.CurrentStep or Content.Settings.Step or Defaults.Step)/(Content.CurrentSpeed or Content.Settings.Speed or Defaults.Speed)) and Content.__Broke == nil then
        
        
        local Cont = Content.Sequence[Content.CurrentIndex];
        if Cont == nil then Terminate(Content) return end;
        local IncreaseCurentIndex = false;
        local IncreaseCurentIndexPosition = false;
        local IncreaseCurrentCharacterPosition = false;
        local Pass = false;
        if Content.List == nil then
            local Txt = Content.Sequence[Content.CurrentIndex];
            if tof(Txt) == tabletxt then
                if Txt.Params then
                    Content.CurrentSize = Txt.Params.size;
                    Content.Params = Txt.Params;
                    Content.CurrentStep = Txt.Params.step;
                    Content.Chunks = Txt.Params.chunks;
                    Content.CurrentScale = Txt.Params.scale
                    Content.CurrentColor = Txt.Params.color;
                    Content.CurrentTransparency = Txt.Params.transparency
                    Content.CurrentSpeed = Txt.Params.speed
                    Content.CurrentAmplitude = Txt.Params.amplitude
                    Content.CurrentFontFace = Txt.Params.fontface
                    Content.CurrentFont = Txt.Params.font;
                    Content.CurrentStrokeColor = Txt.Params.strokecolor;
                    Content.CurrentStrokeTransparency = Txt.Params.stroketransparency;
                end;
                Txt = Txt.Text;
            end
            local List,Count = Utility.splitWordsAndSpaces(Txt);
            Content.List = List;
            Content.Count = Count;
        end
        
        local TextSize = Content.TextSizeInit
        if TextSize == nil then
            TextSize = Content.CurrentSize or Content.Settings.Size;
            if Content.Settings.Scaled then
                TextSize = min(min(parentAbs.Y,100)* (Content.CurrentScale or Content.Settings.Scale or 1),100)
            end
        end;
        
        --< validators
        if Content.Count == nil or Content.Count == 0 then
            if Content.CurrentIndex >= Content.SequenceCount then
                Terminate(Content) return
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
                        Content.WordLength = utf8len(Content.Word);

                        --<ids
                        if Content.Params ~= nil and (Content.Word == "#" or utf8sub(Content.Word,1,1) == "#") then
                            if Content.Word == "#" and Content.Params then
                                --< image
                                if Content.Params.img ~= nil then
                                    local Image = Instance.new("ImageLabel");
                                    Image.Name = "img - "..Content.Params.img
                                    Image.Size = if Content.Settings.Scaled and ScaledEligible then ud2f(TextSize/parentAbs.X,TextSize/parentAbs.Y) else ud2fo(TextSize,TextSize)
                                    Image.Parent = Content.Container;
                                    Image.BackgroundTransparency = 1;
                                    Image.Image = "rbxassetid://"..Content.Params.img
                                    Pass = false;
                                    IncreaseCurentIndexPosition = true;
                                    Content.Word = nil;
                                end
                                --> image
                            else
                                --< functions
                                local id = utf8sub(Content.Word,min(2,Content.WordLength),Content.WordLength)
                                if id ~= nil then
                                    local fetched = Content:GetIdValue(id)
                                    local newWord = (fetched ~= nil and ts(fetched)) or id;
                                    Content.Word = newWord;
                                    Content.WordLength = utf8len(Content.Word);
                                    
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
                            WordInstance.AutoLocalize = false;
                            WordInstance.Parent = Content.Container;
                            WordInstance.TextTransparency = 1;
                            WordInstance.TextSize = TextSize;
                            WordInstance.Text = Content.Word;
                            WordInstance.TextXAlignment = Content.Settings.XAlignment or DefaultX;
                            WordInstance.TextYAlignment = Content.Settings.YAlignment or DefaultY;
                            WordInstance.BackgroundTransparency = 1;
                            if Content.Settings.FontFace ~= nil or Content.CurrentFontFace ~= nil then
                                WordInstance.FontFace = Content.CurrentFontFace or Content.Settings.FontFace;
                            else
                                WordInstance.Font = Content.CurrentFont or Content.Settings.Font or Enum.Font.SourceSans;
                            end
                            WordInstance.TextColor3 = Content.Settings.Color or Color3.new(1,1,1);
                            -- Pre-compute cumulative character widths before TextScaled is set
                            -- (TextBounds returns natural size only when TextScaled is false)
                            local charWidths = {}
                            for ci = 1, Content.WordLength do
                                WordInstance.Text = utf8sub(Content.Word, 1, ci)
                                charWidths[ci] = WordInstance.TextBounds.X
                            end
                            WordInstance.Text = Content.Word;
                            Content.CharWidths = charWidths;
                            local Bounds = WordInstance.TextBounds;
                            if Content.Settings.Scaled and ScaledEligible then
                                WordInstance.Size = ud2f(Bounds.X/parentAbs.X,TextSize/parentAbs.Y);
                                WordInstance.TextScaled = true;
                            else
                                WordInstance.Size = ud2fo(Bounds.X,TextSize);
                            end
                            Content.WordInstance = WordInstance;
                            local ContentSize = Content.ListObject.AbsoluteContentSize;
                            if not Content.Settings.Overfill and (--[[ContentSize.X > parentAbs.X or ]]ContentSize.Y > parentAbs.Y) then
                                WordInstance.Parent = nil;
                                WordInstance:Destroy();
                                Content.Word = nilset;
                                Terminate(Content);
                                Content.CurrentAnimation = nil;
                                return
                            else
                                if Content.Settings.WordStepped ~= nil then
                                    Content.Settings.WordStepped(Content, Content.Word)
                                end
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
                            Content.CharWidths = nil;
                            Content.Word = nilset;
                            Content.WordLength = nilset;
                            Content.CurrentCharTxt = nil;
                            Content.CurrentCharacterPosition = nil;
                            Content.PrevCharacterPosition = nil;
                            Content.CurrentAnimation = nil;
                        else
                            IncreaseCurrentCharacterPosition = true;
                            local Char = utf8sub(Content.Word,(Content.PrevCharacterPosition or 0) +1 ,Content.CurrentCharacterPosition)
                            local Txt = Instance.new("TextLabel");
                            Txt.AutoLocalize = false;
                            if Content.Settings.LetterStepped ~= nil then
                                Content.Settings.LetterStepped(Content,Char, Content.Word)
                            end
                            Txt.Name = Char;
                            --Content.CurrentCharTxt = Txt;
                            Txt.Size = ud2f(15,1);
                            Txt.TextTransparency = 1;
                            local Color = Content.CurrentColor or Content.Settings.Color or Defaults.Color
                            local Tr = (Content.CurrentTransparency or Content.Settings.Transparency or Defaults.Transparency)
                            local STr = (Content.CurrentStrokeTransparency or Content.Settings.StrokeTransparency or Defaults.StrokeTransparency)
                            local StrokeColor = (Content.CurrentStrokeColor or Content.Settings.StrokeColor or Defaults.StrokeColor)
                            Txt.TextTransparency = Tr
                            if Content.CurrentAnimation ~= nil then
                               if Content.CurrentAnimation.StyleIsTable then
                                    for _,v in ipairs(Content.CurrentAnimation.Style) do
                                        if tof(v) == tableType then
                                            Styles[v.style](Txt,0,Tr, STr,Color,StrokeColor,emptyudm,emptyudm,1,false)
                                        else
                                            Styles[v](Txt,0,Tr, STr,Color,StrokeColor,emptyudm,emptyudm,1,false)
                                        end
                                    end
                               else
                                    Styles[Content.CurrentAnimation.Style](Txt,0,Tr, STr,Color,StrokeColor,emptyudm,emptyudm,1,false)
                               end 
                            end
                            Txt.Parent = Content.WordInstance;
                            Txt.TextSize = TextSize;
                            --Txt.TextScaled = true;
                            Txt.AnchorPoint = Vector2.new(.5,.5);
                            Txt.TextXAlignment = Enum.TextXAlignment.Center;
                            Txt.TextYAlignment = Enum.TextYAlignment.Center;
                            Txt.BackgroundTransparency = 1;
                            if Content.Settings.FontFace ~= nil or Content.CurrentFontFace ~= nil then
                                Txt.FontFace = Content.CurrentFontFace or Content.Settings.FontFace;
                            else
                                Txt.Font = Content.CurrentFont or Content.Settings.Font or Enum.Font.SourceSans;
                            end
                            Txt.Text = Char;

                            -- Use pre-computed cumulative widths normalized to total word width
                            -- (avoids gaps from AbsoluteSize vs TextBounds pixel rounding mismatch)
                            local cumulativePixels = Content.CharWidths and Content.CharWidths[Content.CurrentCharacterPosition]
                            local totalWidth = Content.CharWidths and Content.CharWidths[Content.WordLength]
                            local cumulativeX
                            if cumulativePixels and totalWidth and totalWidth > 0 then
                                cumulativeX = cumulativePixels / totalWidth
                            else
                                local ParentAbs = Content.WordInstance.AbsoluteSize
                                cumulativeX = Content.PrevCharX + (Txt.TextBounds.X) / ParentAbs.X
                            end
                            local X = cumulativeX - Content.PrevCharX
                            Txt.Position = ud2f( Content.PrevCharX + (X/2),.5);
                            Content.PrevCharX = cumulativeX;
                            Txt.TextScaled = true;

                            Txt.TextColor3 = Color;
                            Txt.TextStrokeColor3 = StrokeColor
                            Txt.TextStrokeTransparency = STr
                            Txt.Size = ud2f(X,1);

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
            Terminate(Content); return
        end
        if IncreaseCurentIndex then
            Content.CurrentIndex = (Content.CurrentIndex or 1)+1;
            local fetch = Content.Sequence[Content.CurrentIndex];
            if fetch ~= nil and fetch.Params ~= nil and tof(fetch.Params) == tabletxt then
                Content.CurrentStep = fetch.Params.step;
                Content.Chunks = fetch.Params.chunks;
                Content.CurrentScale = fetch.Params.scale
                Content.CurrentColor = fetch.Params.color;
                Content.CurrentTransparency = fetch.Params.transparency
                Content.CurrentSpeed = fetch.Params.speed
                Content.CurrentAmplitude = fetch.Params.amplitude
                Content.CurrentFontFace = fetch.Params.fontface
                Content.CurrentFont = fetch.Params.font;
                Content.CurrentSize = fetch.Params.size;
                Content.Params = fetch.Params;
                Content.CurrentStrokeColor = fetch.Params.strokecolor;
                Content.CurrentStrokeTransparency = fetch.Params.stroketransparency;
            else
                Content.CurrentStrokeColor = nil;
                Content.CurrentStrokeTransparency = nil;
                Content.CurrentSize = nil;
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
    else
        if Content.Settings ~= nil and Content.Settings.OnFinished ~= nil then
            Content.Settings.OnFinished(Content)
        end
        if Content.__DeleteWhenDone then
            Content:Destroy();
        end
    end
    Content.LastRunSuccessful = true;
end
