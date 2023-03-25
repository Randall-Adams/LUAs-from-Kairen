--[[ Meta-Data
Meta-Data-Version: 1.0

Code-Name: OutputPlayerData2
Code-Type: LUA Class
Code-Version: 1.0
Code-Description: Outputs the player's data to Kairen.
Code-Author: Robert Randazzio
]]--
return (
function ()
    local i
    i = 1
    while i < 5 do
        if i ~= LanPlayers[0] and LanPlayers[0] ~= "-" and LanPlayers[i] ~= nil then
            _filepath = RF.EQOA.Net_Streams.o.LanPlayOutput.self .. EQOA.Player.Profile.Name.Value() .. "-" .. i .. Extension_ReadWrites
            if FAPI.IO.File_Exists(_filepath) == false then
                file = io.open(_filepath,"w+");
                if file ~= nil then
                    file:write(EQOA.Player.Location.X.Value());
                    file:write("\n");
                    file:write(EQOA.Player.Location.Y.Value());
                    file:write("\n");
                    file:write(EQOA.Player.Location.Z.Value());
                    file:write("\n");
                    file:write(EQOA.Player.Location.F.Value());
                    --FAPI.RunOptions.Alert_OutputPlayerData.Try()
                    file:close();
                elseif 1 == 2 then
                    --SilentMode = false
                    --print(_filepath)
                    --SilentMode = true
                    --os.execute("mkdir " .. RF.EQOA.Net_Streams.o.LanPlayOutput.self)
                    --os.execute("mkdir " .. _filepath)
                    file = io.open(_filepath,"w+");
                    file:write(EQOA.Player.Location.X.Value());
                    file:write("\n");
                    file:write(EQOA.Player.Location.Y.Value());
                    file:write("\n");
                    file:write(EQOA.Player.Location.Z.Value());
                    file:write("\n");
                    file:write(EQOA.Player.Location.F.Value());
                    file:close();
                end
            end
        end
        i = i + 1
    end
end
);