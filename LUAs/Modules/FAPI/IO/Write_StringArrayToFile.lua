--[[ Meta-Data
Meta-Data-Version: 1.0

Code-Name: Write_StringArrayToFile
Code-Type: LUA Function
Code-Version: 1.0
Code-Description: Writes an array to a file.
Code-Author: Robert Randazzio
]]--

return(
function(_filepath, _stringArray, _keepFileOpen)
    if _stringArray ~= nil then
        i = 1
        _file = io.open(_filepath,"w+");
        while _stringArray[i] ~= nil do
        print("_stringArray[" .. i .. "] = " .. _stringArray[i])
            _file:write(_stringArray[i]);
            _file:write("\n");
            i = i + 1
        end
        print("_stringArray[" .. i .. "] = nil")
        if _keepFileOpen ~= nil and _keepFileOpen == true then
            return _file
        else
            _file:close();            
        end
    end
end
);
