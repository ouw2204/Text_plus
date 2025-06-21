local Types = require(script.Parent.Parent.Types);
local module = {};
local Defaults = require(script.Parent.Defaults);
module.__index = module;
local tf,tr,tc = table.find,table.remove,table.clear
local Styles = {
    Default = require(script.Parent.Holder.Default)
    ,Rainbow = require(script.Parent.Holder.Rainbow),
    Fade = require(script.Parent.Holder.Fade),
    Wiggle = require(script.Parent.Holder.Wiggle),
    Pop = require(script.Parent.Holder.Pop),
    Shrink = require(script.Parent.Holder.Shrink),
    Rise = require(script.Parent.Holder.Rise),
    Drop = require(script.Parent.Holder.Drop),
}
local mc = math.clamp
local StyleFactors = {
    Wiggle = 15;
    Fade = 15;
    Pop = 15;
    Burn = 20;
};
function updateSingle(Style: string,Letter: TextLabel,Step: number,Transparency: number,Color: Color3,HasUpdate: boolean,Index: number,Started: number,StepFactor: number,Size: UDim2,Position: UDim2,Amplitude: number?,Initial: boolean?)
    if Styles[Style] == nil then
        return true;
    end
    local finalprog = 1
    if HasUpdate then
        local stylefactor = StyleFactors[Style] or 12
        finalprog = ((os.clock() - Started) - (Step*(Index-1)) ) / ( Step*stylefactor*(StepFactor or 1) )
    end
    finalprog = mc(finalprog,0,1)
    local ret = Styles[Style](Letter,finalprog,Transparency,Color,Size,Position,Amplitude,Initial)
    if ret == true or finalprog >=1 then
        return true;
    end
    return nil;
end
function module:Destroy()
    setmetatable(self,nil)
end
function module:Update()
    for i = #self.Indexes,1,-1 do
        local found = self.Indexes[i]
        if found == nil or found == false then return end;

        local Completed = updateSingle(self.Style,found,self.step,self.transparency,self.color,self.HasUpdate,i,self.Started,self.StepFactor,self.DefaultSize[i],self.DefaultPosition[i],self.Amplitude)
        if Completed then
            self.Indexes[i] = false;
            self.Progress += 1;
        end
        if self.Progress >= self.WordLength then
            self:Completed()
            break
        end
    end
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
    if self.DefaultPosition then
        tc(self.DefaultPosition)
        self.DefaultPosition = nil;
    end
    self.Word.TextColor3 = self.color;
    self.Word.TextTransparency = self.transparency;
    self:Destroy();
end
function module:AddLetter(Letter: TextLabel)
    self.Index += 1;
    if self.HasUpdate then
        self.DefaultSize[self.Index] = Letter.Size;
        self.DefaultPosition[self.Index] = Letter.Position;
        self.Indexes[self.Index] = Letter;
    end;
    self.Letters[self.Index] = Letter;
    local Completed = updateSingle(self.Style,Letter,self.step,self.transparency,self.color,self.HasUpdate,self.Index,self.Started,self.StepFactor,Letter.Size,Letter.Position,self.Amplitude or 1,true)
    if Completed then
        if self.HasUpdate then
            self.Indexes[self.Index] = false;
        end
        self.Progress += 1;
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
        Style = (Params ~= nil and Params.style) or Settings.Style or "Default";
        Started = os.clock();
    }
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
