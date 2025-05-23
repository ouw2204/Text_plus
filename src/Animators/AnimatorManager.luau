local module = {}
module.__index = module;
local Types = require(script.Parent.Parent.Types)
local Defaults = {
    Speed = 1;
    Step = .01;
}
local nilset = nil;
local Utility = require(script.Parent.Parent.Utility);
return function(Content: Types.PlayableType, WaitTime: number,parentAbs: Vector2)
    if Content.Timer == nil or Content.Timer+WaitTime > (Content.CurrentStep or Content.Settings.Step or Defaults.Step)/(Content.CurrentSpeed or Content.Settings.Speed or Defaults.Speed) then
        local TextSize = Content.Settings.Size;
        if Content.Settings.Scaled then
            TextSize = math.min(parentAbs.Y,100)* (Content.Settings.Scale or 1)
        end
        
        local Cont = Content.Sequence[Content.CurrentIndex];
        if Cont == nil then Content:Break(); print(Content.CurrentIndex); return end;
        local IncreaseCurentIndex = false;
        local IncreaseCurentIndexPosition = false;
        local IncreaseCurrentCharacterPosition = false;
        local Pass = false;
        if Content.List == nil then
            local Txt = Content.Sequence[Content.CurrentIndex];
            if typeof(Txt) == "table" then
                Txt = Txt.Text;
                print(" is tab")
            end
            local List,Count = Utility.splitWordsAndSpaces(Txt);
            Content.List = List;
            Content.Count = Count;
        end
        
        --< validators
        if Content.Count == nil or Content.Count == 0 then
            if Content.CurrentIndex >= Content.SequenceCount then
                Content:Break(); print("break",Content.SequenceCount,Content.CurrentIndex); return
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
                        --string.match(Content.Word,"%s+") == Content.Word
                        Content.Word = Content.List[Content.CurrentIndexPosition];
                        Content.WordLength = #Content.Word;
                        Content.CurrentCharacterPosition = 1;
                        Content.PrevCharX = 0;
                        local WordInstance = Instance.new("TextLabel");
                        WordInstance.Name = Content.Word.."display";
                        WordInstance.Parent = Content.Frame;
                        WordInstance.TextTransparency = .5;
                        WordInstance.TextSize = TextSize;
                        WordInstance.Text = Content.Word;
                        WordInstance.TextXAlignment = Content.Settings.XAlignment or Enum.TextXAlignment.Left;
                        WordInstance.TextYAlignment = Content.Settings.YAlignment or Enum.TextYAlignment.Top;
                        WordInstance.BackgroundTransparency = 1;
                        if Content.Settings.FontFace ~= nil then
                            WordInstance.FontFace = Content.Settings.FontFace;
                        else
                            WordInstance.Font = Content.Settings.Font or Enum.Font.SourceSans;
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
                        Pass = true;
                        local ContentSize = Content.ListObject.AbsoluteContentSize;
                        if not Content.Settings.Overfill and (ContentSize.X > parentAbs.X or ContentSize.Y > parentAbs.Y) then
                            WordInstance.Parent = nil;
                            WordInstance:Destroy();
                            Content:Break();
                            return
                        end
                    else
                        if Content.CurrentCharTxt ~= nil then
                            Content.CurrentCharTxt.TextTransparency = 0;
                        end;
                        if Content.CurrentCharacterPosition > Content.WordLength then
                            IncreaseCurentIndexPosition = true;
                            Content.Word = nilset;
                            Content.WordLength = nilset;
                            Content.CurrentCharTxt = nil;
                            Content.CurrentCharacterPosition = 1;
                        else
                            IncreaseCurrentCharacterPosition = true;
                            local String = string.sub(Content.Word,0,Content.CurrentCharacterPosition)
                            local Char = string.sub(Content.Word,Content.CurrentCharacterPosition or 1,Content.CurrentCharacterPosition)
                            local Txt = Instance.new("TextLabel");
                            Txt.Name = Char;
                            Content.CurrentCharTxt = Txt;
                            Txt.Size = UDim2.fromScale(1,1);
                            Txt.TextTransparency = 1;
                            Txt.Position = UDim2.fromScale(Content.PrevCharX/Content.WordInstance.AbsoluteSize.X,0);
                            Txt.Parent = Content.WordInstance;
                            Txt.TextSize = TextSize;
                            Txt.TextXAlignment = Enum.TextXAlignment.Center;
                            Txt.TextYAlignment = Enum.TextYAlignment.Center;
                            Txt.BackgroundTransparency = 1;
                            if Content.Settings.FontFace ~= nil then
                                Txt.FontFace = Content.Settings.FontFace;
                            else
                                Txt.Font = Content.Settings.Font or Enum.Font.SourceSans;
                            end
                            Txt.Text = String;
                            local FullBounds = Txt.TextBounds.X;
                            local Difference = FullBounds-Content.PrevCharX;
                            Txt.Text = Char;
                            Txt.TextColor3 = Content.Settings.Color or Color3.new(1,1,1);
                            local X = Difference/Content.WordInstance.AbsoluteSize.X
                            Txt.Size = UDim2.fromScale(X,1);
                            Content.PrevCharX = FullBounds;
                        end
                    end
                else
                    IncreaseCurentIndexPosition = true;
                end
            end
        end
        --> validators
        if not IncreaseCurentIndex and not IncreaseCurentIndexPosition and not IncreaseCurrentCharacterPosition and not Pass then
            Content:Break(); print("break2"); return
        elseif Pass then
            Content.Timer = 0;
        elseif IncreaseCurentIndex then
            Content.CurrentIndex = (Content.CurrentIndex or 1)+1;
            Content.Timer = 0;
        elseif IncreaseCurentIndexPosition then
            Content.CurrentIndexPosition = (Content.CurrentIndexPosition or 1)+1;
            Content.Timer = 0;
        elseif IncreaseCurrentCharacterPosition then
            Content.CurrentCharacterPosition = (Content.CurrentCharacterPosition or 1)+1;
            Content.Timer = 0;
        end
    else
        Content.Timer = (Content.Timer and Content.Timer+WaitTime) or WaitTime;
    end
end
