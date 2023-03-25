--[[ Meta-Data
Meta-Data-Version: 1.0

Code-Name: Convert_StringToBoolean
Code-Type: LUA Function
Code-Version: 1.0
Code-Description: Converts a string value into it's boolean equivalent.
Code-Author: Robert Randazzio
]]--
return (
function (_value)
    if _value == nil then
        return nil
    else
        _value = string.lower(_value)
        if _value == "true" then
            return true;
        elseif _value == "false" then
            return false
        else
            return nil;
        end
    end
end
);
