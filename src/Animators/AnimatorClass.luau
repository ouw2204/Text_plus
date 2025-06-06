local Types = require(script.Parent.Parent.Types);
local module = {};
local Defaults = require(script.Parent.Defaults);
module.__index = module;
local Styles = {
    Default = require(script.Parent.Holder.Default)
    ,Rainbow = require(script.Parent.Holder.Rainbow)
}
function  updateSingle(Style: string,Letter: TextLabel,Step: number,Transparency: number,Color: Color3,HasUpdate: boolean,Index: number,Started: number,StyleFactor: number,Size: UDim2,Position: UDim2)
    if Styles[Style] == nil then
        return true;
    end
    if StyleFactor then
        Step *= StyleFactor
    end
    local finalprog = 1
    if HasUpdate then
        finalprog = ((os.clock() - Started) - (Step*(Index-1)) ) / Step
    end
    local ret = Styles[Style](Letter,finalprog,Transparency,Color,Size,Position)
    if ret == true or finalprog >=1 then
        return true;
    end
end
function module:Destroy()
    setmetatable(self,nil)
end
function  module:Completed()
    for i = self.Index,1,-1 do
        self.Letters[i]:Destroy();
        self.Letters[i] = nil;
    end
    self.Word.TextColor3 = self.color;
    self.Word.TextTransparency = self.transparency;
end
function module:AddLetter(Letter: TextLabel)
    if self.HasUpdate then
        self.DefaultSize[Letter] = Letter.Size;
        self.DefaultPosition[Letter] = Letter.Size;
        self.Indexes[Letter] = self.Index
    end;
    table.insert(self.Letters, Letter)
    local Completed = updateSingle(self.Style,Letter,self.step,self.transparency,self.color,self.HasUpdate,self.Index,self.Started,self.StyleFactor,Letter.Size,Letter.Position)
    if Completed then
        self.Progress += 1;
    end
    if self.Progress >= self.WordLength then
        self:Completed()
    end
    self.Index += 1;
end
return function(Word: TextLabel,Params: {[string]: number?}?, Settings: Types.DefaultSettingsType): Types.AnimatorType
    local tab = {
        Word = Word;
        WordLength = #Word.Text;
        Index = 1;
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
    tab.step = (Params ~= nil and Params.step) or Settings.Step or Defaults.Step
    tab.transparency = (Params ~= nil and Params.transparency) or Settings.Transparency or Defaults.Transparency
    tab.color = (Params ~= nil and Params.color) or Settings.Color or Defaults.Color
    return setmetatable(tab,module) :: any
end
