--[[ Meta-Data
Meta-Data-Version: 1.0

Code-Name: RunOptions
Code-Type: LUA Function
Code-Version: 1.1
Code-Description: This function is used to control when code for options should be ran.
Code-Author: Robert Randazzio
]]--
--Notes:
--"TestFunctionThree = nil" can be done to erase the original function as the RunOptions function seems 
--to copy it, and not reference it
--or just name the original function the fapi.ro.whatev and then rewrite it later it when you re-establish it?

return (
function (_newItem, _do, _etName, _intervalToRun)
    local self = {};
    if _newItem == nil then return nil end
    if _do == nil then _do = false end
    self.Item = _newItem
    self.Do = _do
    if _etName ~= nil and _intervalToRun ~= nil then
        GameLoop.et.check("SETUP", _etName, _intervalToRun)
        function self.Try(_forceInsteadOfTry)
            if (self.Do == true and GameLoop.et.check(_etName)) or (_forceInsteadOfTry ~= nil and _forceInsteadOfTry == true) then
                if self.Item ~= nil then
                    return self.Item()
                else
                    --item is nil
                    print("0| error - RunOptions.self.Item() == nil")
                end
            end
        end
    else
        function self.Try(_forceInsteadOfTry)
            if (self.Do == true) or (_forceInsteadOfTry ~= nil and _forceInsteadOfTry == true) then
                if self.Item ~= nil then
                    return self.Item()
                else
                    --item is nil
                    print("0| error - RunOptions.self.Item() == nil")
                end
            end
        end 
    end
    return self;
end
);
