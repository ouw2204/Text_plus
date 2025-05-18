local Wraps = script:WaitForChild("Wraps");
local WrapsLoaded = {
    Default = require(Wraps.Default);
};
export type PlayableType = {

};
export type textPlusType = {
    New: (Content: string) -> PlayableType
}
local MainMetatable = require(script.MainMetatable)
return {
    New = function(Content: string)
        return setmetatable({
            Sequence = {};
        },MainMetatable)
    end
}:: textPlusType