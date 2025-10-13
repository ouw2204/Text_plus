local Types = require(script.Parent.Types)
local typetxt = script.Name;

return function(Tab: any,Func: (Index: any,Value: any,InnerThread: Types.Thread?,Entity: Instance?) -> (),Thread: Types.Thread)
    local Iterate = {
        Tab = Tab,
        Function = Func,
        __type = typetxt,
    }
    
    return Iterate;
end