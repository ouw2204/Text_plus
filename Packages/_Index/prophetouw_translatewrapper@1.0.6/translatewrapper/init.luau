local module = {};
local RunService = game:GetService("RunService")
local IsServer = RunService:IsServer()
local LocalizationService = game:GetService("LocalizationService");

local translator;
local Cache = {};
local maxRetries = 10;
if not IsServer and game.Players.LocalPlayer ~= nil then
    function recursion()
        if translator ~= nil then return end;
        task.spawn(function()
            local success,result = pcall(function()
                return LocalizationService:GetTranslatorForPlayerAsync(game.Players.LocalPlayer);
            end)
            if success then
                if Cache.Default == nil then
                    Cache.Default = result;
                end;
                translator = result;
            else
                if maxRetries > 0 then
                    maxRetries -= 1;
                    task.delay(1,recursion)
                end
            end
        end)
    end
    recursion()
end;
function module.SetLanguage(LanguageCode: string)
    if IsServer then return end;
    task.spawn(function()
        local success,result = pcall(function()
            if LanguageCode ~= nil then
                if Cache[LanguageCode] then
                    return Cache[LanguageCode];
                else
                    local result = LocalizationService:GetTranslatorForLocaleAsync(LanguageCode);
                    if result ~= nil then
                        Cache[LanguageCode] = result;
                        return result
                    end
                end
            else
                if Cache.Default then
                    return Cache.Default;
                else
                    local result = LocalizationService:GetTranslatorForPlayerAsync(game.Players.LocalPlayer)
                    Cache.Default = result;
                    return result;
                end
                
            end
        end)
        if success and translator ~= result then
            translator = result;
        end
    end)
end
function  module.TranslateByKey(Key: string, Args: {[any]: any}?)
    if IsServer then return end;
    local translation = "Key formatted translation not found!";
    if translator ~= nil then
        pcall(function()
            translation = translator:FormatByKey(Key, Args);
        end)
    end
    return translation;
end
function module.Translate(Text: string, Object: Instance?)
    if IsServer then return Text end;
    if Text:match("^%s*$") then return Text end;
    if translator == nil then
        return Text;
    end
    return translator:Translate(Object or game,Text)
end

return module;