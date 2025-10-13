local m = {};
local mds = "ModuleScript";
for _,v in ipairs(script.Parent.Parent.Styles:GetChildren()) do
    if not (v.ClassName == mds) then continue end;
    m[v.Name] = require(v)
end

return m;