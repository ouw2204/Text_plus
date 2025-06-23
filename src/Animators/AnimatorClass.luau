local tof = typeof
local Types = require(script.Parent.Parent.Types);
local module = {};
local Defaults = require(script.Parent.Defaults);
module.__index = module;
local tf,tr,tc = table.find,table.remove,table.clear
local Styles = {
    Default = require(script.Parent.Holder.Default);
    Rainbow = require(script.Parent.Holder.Rainbow);
    Fade = require(script.Parent.Holder.Fade),
    Wiggle = require(script.Parent.Holder.Wiggle);
    Pop = require(script.Parent.Holder.Pop);
    Shrink = require(script.Parent.Holder.Shrink);
    Rise = require(script.Parent.Holder.Rise);
    Drop = require(script.Parent.Holder.Drop);
}
local mc = math.clamp
local StyleFactors = {
    Wiggle = 1.8;
    Fade = 1.8;
    Pop = 1.5;
};
function updateSingle(Style: string,Letter: TextLabel,Step: number,Transparency: number,Color: Color3,HasUpdate: boolean,Index: number,Started: number,StepFactor: number,Size: UDim2,Position: UDim2,Amplitude: number?,StyleTable: {Repeat: number?, Looped: boolean?,Reverse: boolean?, DelayTime: number?}?)
    if Styles[Style] == nil then
        return true;
    end
    local finalprog = 1
    if HasUpdate then
        local stylefactor = (StyleFactors[Style] or 1.6) * 10
        local delayTime = (StyleTable and StyleTable.DelayTime) or 0
        local elapsedTime = (os.clock() - Started) - (Step*(Index-1))
        
        -- Don't run animation during delay period
        if elapsedTime < delayTime then
            elapsedTime = nil;
            delayTime = nil;
            stylefactor = nil;
            return nil  -- Exit early, don't run animation yet
        end
        
        finalprog = (elapsedTime - delayTime) / ( Step*stylefactor*(StepFactor or 1) )
        elapsedTime = nil;
        delayTime = nil;
        stylefactor = nil;
    end

    local clamped = mc(finalprog,0,1)
    local shouldComplete = false
    local Reversing = false  -- Track if we're in reverse phase
    
    if StyleTable ~= nil then
        if StyleTable.Looped or (StyleTable.Repeat ~= nil and StyleTable.Repeat < 0) then
            local cycleProg = finalprog % 1
            
            -- Handle reverse animation (ping-pong effect)
            if StyleTable.Reverse then
                local cycleNumber = math.floor(finalprog)
                -- Even cycles: normal (0->1), Odd cycles: reverse (1->0)
                if cycleNumber % 2 == 1 then
                    clamped = 1 - cycleProg
                    Reversing = true
                else
                    clamped = cycleProg
                    Reversing = false
                end
            else
                clamped = cycleProg
                Reversing = false
            end
            
        elseif StyleTable.Repeat ~= nil then
            local repeatCycle = math.floor(finalprog)
            local cycleProg = finalprog % 1

            if StyleTable.Reverse then
                -- With reverse, each "repeat" consists of 2 half-cycles (forward + backward)
                local totalHalfCycles = StyleTable.Repeat * 2
                local currentHalfCycle = math.floor(finalprog * 2)
                
                if currentHalfCycle >= totalHalfCycles then
                    shouldComplete = true
                else
                    -- Calculate progress within current half-cycle
                    local halfCycleProg = (finalprog * 2) % 1
                    -- Even half-cycles: forward (0->1), Odd half-cycles: backward (1->0)
                    if currentHalfCycle % 2 == 1 then
                        clamped = 1 - halfCycleProg
                        Reversing = true
                    else
                        clamped = halfCycleProg
                        Reversing = false
                    end
                end
            else
                -- Normal repeat behavior without reverse
                if repeatCycle >= StyleTable.Repeat then
                    shouldComplete = true
                else
                    clamped = cycleProg
                    Reversing = false
                end
            end
            
        elseif StyleTable.Reverse then
            -- Handle reverse without looping or repeating (single ping-pong cycle)
            if finalprog <= 1 then
                -- First half: 0->1 (progress 0 to 0.5 maps to 0->1)
                clamped = finalprog * 2
                if clamped > 1 then clamped = 1 end
                Reversing = false
            elseif finalprog <= 2 then
                -- Second half: 1->0 (progress 1 to 2 maps to 1->0)
                clamped = 2 - finalprog
                Reversing = true
            else
                -- Animation complete after one full cycle
                shouldComplete = true
            end
        end
    end
    
    -- Always run the animation first, now with Reversing parameter
    local ret = Styles[Style](Letter,clamped,Transparency,Color,Size,Position,Amplitude,Reversing)

    -- Check for completion after running the animation
    if shouldComplete or ret == true then
        return true
    end

    if StyleTable == nil or (StyleTable.Repeat == nil and StyleTable.Looped == nil and StyleTable.Reverse == nil) then
        if clamped >= 1 then
            return true;
        end
    end
    
    return nil;
end
function module:Destroy()
    setmetatable(self,nil)
end
function module:Completed()
    local f = tf(self.__Content.Animations,self)
    if f ~= nil then
        tr(self.__Content.Animations,f)
    end
    for i = self.Index,1,-1 do
        local Letter = self.Letters[i]
        self.Letters[i] = nil;
        Letter:Destroy();
    end
    self.Letters = nil;
    if self.DefaultSize then
        tc(self.DefaultSize)
        self.DefaultSize = nil;
    end
    if self.Indexes then
        tc(self.Indexes)
        self.Indexes = nil;
    end
    if self.StylesCount ~= nil then
        for i = #self.StylesCount,1,-1 do
            tc(self.StylesCount[i])
            self.StylesCount[i] = nil;
        end
        tc(self.StylesCount)
        self.StylesCount = nil;
    end
    self.nativeStyleCount = nil;
    if self.DefaultPosition then
        tc(self.DefaultPosition)
        self.DefaultPosition = nil;
    end
    self.Word.TextColor3 = self.color;
    self.Word.TextTransparency = self.transparency;
    self:Destroy();
end
local tableType = "table"
function module:Update()
    for i = 1,#self.Indexes do
        local found = self.Indexes[i]
        if found == nil or found == false then continue end;
        if self.StyleIsTable then
            for x = self.StylesCount[found].Count,1,-1 do
                if tof(self.StylesCount[found].Styles[x]) == tableType then
                   local Completed = updateSingle(self.StylesCount[found].Styles[x].Style,found,self.step,self.transparency,self.color,self.HasUpdate,i,self.Started,self.StepFactor,self.DefaultSize[i],self.DefaultPosition[i],self.Amplitude,self.StylesCount[found].Styles[x])
                    if Completed then
                        self.StylesCount[found].Count -= 1;
                        table.remove(self.StylesCount[found].Styles,x)
                    end
                else
                    local Completed = updateSingle(self.StylesCount[found].Styles[x],found,self.step,self.transparency,self.color,self.HasUpdate,i,self.Started,self.StepFactor,self.DefaultSize[i],self.DefaultPosition[i],self.Amplitude)
                    if Completed then
                        self.StylesCount[found].Count -= 1;
                        table.remove(self.StylesCount[found].Styles,x)
                    end
                end
                
                if self.StylesCount[found] == nil or self.StylesCount[found].Count <= 0 then
                    self.Indexes[i] = false;
                    self.Progress += 1;
                    break
                end
            end
        else
            local Completed = updateSingle(self.Style,found,self.step,self.transparency,self.color,self.HasUpdate,i,self.Started,self.StepFactor,self.DefaultSize[i],self.DefaultPosition[i],self.Amplitude)
            if Completed then
                self.Indexes[i] = false;
                self.Progress += 1;
            end
        end
        if self.Progress >= self.WordLength then
            self:Completed()
            break
        end
    end
end

function module:AddLetter(Letter: TextLabel)
    self.Index += 1;
    if self.HasUpdate then
        self.DefaultSize[self.Index] = Letter.Size;
        self.DefaultPosition[self.Index] = Letter.Position;
        self.Indexes[self.Index] = Letter;
    end;
    self.Letters[self.Index] = Letter;
    Letter.TextTransparency = self.transparency;
    if self.StyleIsTable then
        if self.StylesCount[Letter] == nil then
            self.StylesCount[Letter] = {
                Count = self.nativeStyleCount;
                Styles = {};
            }
            for i = self.nativeStyleCount,1,-1 do
                self.StylesCount[Letter].Styles[i] = self.Style[i]
            end
        end;
        for i = self.StylesCount[Letter].Count,1,-1 do
            if tof(self.Style[i]) == tableType then
                local Completed = updateSingle(self.StylesCount[Letter].Styles[i].Style,Letter,self.step,self.transparency,self.color,self.HasUpdate,self.Index,self.Started,self.StepFactor,self.DefaultSize[self.Index],self.DefaultPosition[self.Index],self.Amplitude or 1,self.StylesCount[Letter].Styles[i])
                if Completed then
                    self.StylesCount[Letter].Count -= 1;
                    table.remove(self.StylesCount[Letter].Styles,i)
                end
            else
                local Completed = updateSingle(self.StylesCount[Letter].Styles[i],Letter,self.step,self.transparency,self.color,self.HasUpdate,self.Index,self.Started,self.StepFactor,self.DefaultSize[self.Index],self.DefaultPosition[self.Index],self.Amplitude or 1)
                if Completed then
                    self.StylesCount[Letter].Count -= 1;
                    table.remove(self.StylesCount[Letter].Styles,i)
                end
            end
            if self.StylesCount[Letter] == nil or self.StylesCount[Letter].Count <0 then
                self.StylesCount[Letter] = nil;
                if self.HasUpdate then
                    self.Indexes[self.Index] = false;
                end
                self.Progress += 1;
                break
            end
        end
    else
        local Completed = updateSingle(self.Style,Letter,self.step,self.transparency,self.color,self.HasUpdate,self.Index,self.Started,self.StepFactor,Letter.Size,Letter.Position,self.Amplitude or 1)

        if Completed then
            if self.HasUpdate then
                self.Indexes[self.Index] = false;
            end
            self.Progress += 1;
        end
    end
    
    if self.Progress >= self.WordLength then
        self:Completed()
    end
end
return function(Content: Types.PlayableType,Word: TextLabel,Params: {[string]: number?}?, Settings: Types.DefaultSettingsType): Types.AnimatorType
    local tab = {
        __Content = Content;
        Word = Word;
        WordLength = #Word.Text;
        Index = 0;
        Progress = 0;
        Style = (Params ~= nil and Params.style) or Settings.Style;
        Started = os.clock();
    }
    tab.StyleIsTable = tof(tab.Style) == "table"
    if not tab.StyleIsTable then
        tab.Style = (Styles[tab.Style] ~= nil and tab.Style) or "Default"
    else
        tab.nativeStyleCount = #tab.Style
        tab.StylesCount = {};
    end;
    tab.HasUpdate = tab.Style ~= nil and tab.Style ~= "Default";
    tab.Letters = {};
    if tab.HasUpdate then
        tab.Indexes = {};
        tab.DefaultSize = {};
        tab.DefaultPosition = {};
    end
    tab.Amplitude = (Params ~= nil and Params.amplitude) or Settings.Amplitude or Defaults.Amplitude
    tab.StepFactor = (Params ~= nil and Params.stepfactor) or Settings.StepFactor or Defaults.StepFactor
    tab.step = (Params ~= nil and Params.step) or Settings.Step or Defaults.Step
    tab.transparency = (Params ~= nil and Params.transparency) or Settings.Transparency or Defaults.Transparency
    tab.color = (Params ~= nil and Params.color) or Settings.Color or Defaults.Color
    return setmetatable(tab,module) :: any
end
