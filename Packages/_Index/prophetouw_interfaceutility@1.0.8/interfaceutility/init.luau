--!strict
local TextService = game:GetService("TextService");
local Helper = require(script.OuwInterfaceUtilityHelper);
local m = {};
local Camera = workspace.CurrentCamera;
local ScaledTextSizeDecimalOffset = 1000;
--[=[
    @class InterfaceUtility
]=]

--[=[
    Get the billboard's size on the player's screen. Works if the billboard's not parented as it uses the properties.
    @param BillboardGui BillboardGui
    @returns Vector2
]=]
function m.getBillboardGuiScreenSize(BillboardGui: BillboardGui?)
    if BillboardGui == nil then return Vector2.zero end;
    return Helper.getBillboardGuiScreenSize(BillboardGui);
end

--[=[
    Get the size of the text in pixels.
    @function GetTextLength
    @within InterfaceUtility
    @param Text string
    @param Font Enum.Font
    @param Size number
    @returns number
]=]
function m.GetTextLength(Text: string, TextObject: any,TextSize: number?,TextFont: Enum.Font?,AbsoluteSize: Vector2?,Scale: number?)
    if Text == nil or (TextObject == nil and (TextSize == nil or TextFont == nil or AbsoluteSize == nil)) then return 0 end;
    AbsoluteSize = AbsoluteSize or TextObject.AbsoluteSize
    local MaxScale = math.max(Camera.ViewportSize.Y,1/AbsoluteSize.Y^2.25);
    local UnScaled = (TextSize or AbsoluteSize.Y);
    local ScaleActual = Scale or 1;
    local Y =  math.clamp(UnScaled*ScaleActual,0,MaxScale)
    local Difference = Y/UnScaled
    return TextService:GetTextSize(Text, Y, TextFont or TextObject.Font, Vector2.new(3000*Difference, Y)).X/Difference;
end


function BackTrack(Object: any) : ({Instance},Vector2)
    if Object == nil then return {}, Vector2.zero end;
    local Count = 1;
    local Trace = {
        [1] = Object;
    }
    local CurrentAbs = nil;
    local BillboardShutdown = Object:FindFirstAncestorWhichIsA("BillboardGui") ~= nil;
    while Object ~= nil do
        Object = Object.Parent;
        if Object ~= nil and Object:IsA("GuiBase") == true and Object.Parent ~= nil and Object.Parent:IsA("GuiBase") and Object.ClassName ~= "ScreenGui" and ((Object.AbsoluteSize.X == 0 and Object.AbsoluteSize.Y == 0) or BillboardShutdown) then
            Count = Count + 1;
            Trace[Count] = Object;
        else
            --[[
                We do not need to add this to the backtrack since there is nothing before it, otherwise it would scale its own Size to start the backtrace
            ]]
            local Abs = (BillboardShutdown and Vector2.new()) or Object.AbsoluteSize
			if Abs.X == 0 and Abs.Y == 0 then
				if Object:IsA("BillboardGui") then
                    CurrentAbs = m.getBillboardGuiScreenSize(Object)
                else
                    
                    CurrentAbs = Camera.ViewportSize;
                end
			else
                CurrentAbs = Abs;
            end 
            break;
        end
    end
    return Trace,CurrentAbs or Vector2.zero;
end
--[=[
    Get the absolute size of a ui object
    @function GetAbsoluteSize
    @within InterfaceUtility
    @param Object any
    @return absolutesize, parent absolute size
]=]
function m.GetAbsoluteSize(Object: any): (Vector2,Vector2)
    if Object == nil then return Vector2.zero,Vector2.zero end;
    local Abs = Object.AbsoluteSize;
    local AbsParent = nil;
    if Object ~= nil and Object.Parent ~= nil and Object.Parent:IsA("GuiBase") then
        AbsParent = Object.Parent.AbsoluteSize;
    end
    if Abs.X ~= 0 or Abs.Y ~= 0 then
        return Abs,AbsParent;
    end
    local Trace ,Size  = BackTrack(Object);
    local Previous = nil;
    for i = #Trace,1,-1 do
        local v: any = Trace[i];
        if v == nil then break end;
        Previous = Size
        Size = Vector2.new((Size.X * v.Size.X.Scale) + v.Size.X.Offset , (Size.Y * v.Size.Y.Scale) + v.Size.Y.Offset)
    end
    return Size,Previous;
end
--[=[
    Get the scaled text length instead of offset
    @function GetScaledTextLength
    @within InterfaceUtility
    @param Text string
    @param TextObject TextLabel
    @param TextSize number?
    @param TextFont Enum.Font?
    @param AbsoluteSize Vector2?
    @return scaled text x size
]=]
function m.GetScaledTextLength(Text: string, TextObject: TextLabel,TextSize: number?,TextFont: Enum.Font?,AbsoluteSize: Vector2?)
    --initial sanity checks
    if TextObject.Parent == nil or TextObject.Parent:IsA("GuiBase") == false then return 0 end;
    local currentSize,ParentSize = m.GetAbsoluteSize(TextObject);
	local Fetched = m.GetTextLength(Text, TextObject,TextSize,TextFont,currentSize,ScaledTextSizeDecimalOffset);
    return (Fetched) /ParentSize.X;

end
return m;