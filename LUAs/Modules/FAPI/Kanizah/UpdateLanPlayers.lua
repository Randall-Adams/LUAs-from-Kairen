--[[ Meta-Data
Meta-Data-Version: 1.0

Code-Name: UpdateLanPlayers
Code-Type: LUA Class
Code-Version: 1.0
Code-Description: none
Code-Author: Robert Randazzio
]]--
return (
function ()
    --SilentMode = false
    local i = 1
    while i < 5 do
        print("Trying " .. i)
        if _G.LanPlayers[i] ~= nil and _G.LanPlayers[0] ~= i then
            local _filepath
            _filepath = RF.EQOA.Net_Streams.o.LanPlayOutput.self .. _G.LanPlayers[i] .. "-" .. LanPlayers[0] .. Extension_ReadWrites
            if FAPI.IO.File_Exists(_filepath) then
                local LanPlayer = io.open(_filepath,"r+")
                if LanPlayer ~= nil then
                    print("Player " .. i .. " is " .. _G.LanPlayers[i])
                    -- update the player's data here
                    local NPCName = _G.LanPlayers[i]
                    local NPCX = FAPI.IO.ReadNextLine(LanPlayer, "--")
                    local NPCY = FAPI.IO.ReadNextLine(LanPlayer, "--")
                    local NPCZ = FAPI.IO.ReadNextLine(LanPlayer, "--")
                    local NPCF = FAPI.IO.ReadNextLine(LanPlayer, "--")
                    local thisNPC
                    thisNPC = NPCs.Find("Name", NPCName, "NPC")
                    if thisNPC ~= nil then
                        print("Found")
                        thisNPC.X(NPCX)
                        thisNPC.Y(NPCY)
                        thisNPC.Z(NPCZ)
                        thisNPC.F(NPCF)
                    else
                        print("Unfound")
                    end
                    LanPlayer:close();
                    os.remove(_filepath)
                else
                    print("No file for player " .. i)
                end
            --else
            --    print(" nil somehow")
            else
                print("No file for player " .. i)
            end
        end
        i = i + 1
    end
    --SilentMode = true
end
);