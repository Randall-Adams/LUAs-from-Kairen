print("Loading Settings")
GameLoop.et.check("SETUP", mode, 100)
--SilentMode = false
----RF.EQOA.Net_Streams.o.LanPlayOutput = RF.NewFolder("LanPlayOutput", RF.EQOA.Net_Streams.o.self)
--_G.FAPI.Kanizah.OutputPlayerData2 = dofile(FAPI.DirectoryLocation .. "Kanizah/OutputPlayerData2.lua");

-- Process Outside Commands
FAPI.RunOptions.ProcessOutsideCommands = FAPI.RunOptions.New(FAPI.Kanizah.ProcessOutsideCommands, true)
FAPI.RunOptions.Alert_ProcessOutsideCommands = FAPI.RunOptions.New(FAPI.Kanizah.Alert_ProcessOutsideCommands, false)

-- Output PlayerData
--FAPI.RunOptions.OutputPlayerData = FAPI.RunOptions.New(_G.FAPI.Kanizah.OutputPlayerData, false, "OutputPlayerData", 1000)
--FAPI.RunOptions.Alert_OutputPlayerData = FAPI.RunOptions.New(FAPI.Kanizah.Alert_OutputPlayerData, false)
--FAPI.RunOptions.Alert_OutputPlayerData_ConsoleOutput = FAPI.RunOptions.New(FAPI.Kanizah.Alert_OutputPlayerData_ConsoleOutput, false)
----FAPI.RunOptions.OutputPlayerData2 = FAPI.RunOptions.New(_G.FAPI.Kanizah.OutputPlayerData2, true, "OutputPlayerData2", 3000)

-- Handle Automatic NPC Spawning
FAPI.RunOptions.UpdateSpawnNests = FAPI.RunOptions.New(_G.SpawnHandler.UpdateSpawnNests, true, "UpdateSpawnNests", 1000)

-- From Dev Main
dofile(RF.EQOA.LUAs.Modules.FAPI.self .. "Classes/Kanizah.lua")

--SquareIsPressed = FAPI.CE.Address.New("[pcsx2-r3878.exe+0040239C]+975", "Byte", "SquareIsPressed")
CrossIsPressed = FAPI.CE.Address.New("[pcsx2-r3878.exe+0040239C]+976", "Integer", "CrossIsPressed")
SquareIsPressed = FAPI.CE.Address.New("[pcsx2-r3878.exe+0040239C]+975", "Integer", "SquareIsPressed")
TargetID = FAPI.CE.Address.New("[pcsx2-r3878.exe+004023B0]+B90", "Integer", "TargetID", 4)
function CrossPressCheck()
    if CrossIsPressed.Value() == 1 then
        if PopupBox.TextBoxOn.Value() == 1 then
            --PopupBox.Close()
            print("Cross Press Detected")
            Dialogue.Read()
        end
    end
end
function SquarePressCheck()
    if SquareIsPressed.Value() == 1 then
        if PopupBox.TextBoxOn.Value() == 0 then
            --NPCs.HailPlayer(TargetID.Value())
            --NPCs.Interact(TargetID.Value(), "StartDialogue")
            NPCs.Interact(TargetID.Value(), "DeltaDialogue")
        end
    end
end


Dialogue = {};
Dialogue.NPC = {};
Dialogue.NPCs = {};
Dialogue.NPCs.index = 0;
Dialogue.NPCs.Add = (function(_npcName)
        Dialogue.NPCs.index = Dialogue.NPCs.index + 1
        Dialogue.NPC[Dialogue.NPCs.index] = {};
        Dialogue.NPC[Dialogue.NPCs.index].Name = _npcName
        Dialogue.NPC[Dialogue.NPCs.index].MyIndex = Dialogue.NPCs.index
        Dialogue.NPC[Dialogue.NPCs.index].CurrentIndex = 1
        Dialogue.NPC[Dialogue.NPCs.index].MaxIndex = 0
        Dialogue.NPC[Dialogue.NPCs.index].Try = (function()
                print("007| trying with " .. Dialogue.NPC[Dialogue.NPCs.index].Name)
                --Dialogue.TryNext = 0
                --if Dialogue.NPC[Dialogue.NPCs.index].Dialogue[Dialogue.NPC[Dialogue.NPCs.index].CurrentIndex + 1].Try ~= nil then
                print("trynext is: " .. Dialogue.TryNext)
                if Dialogue.NPC[Dialogue.NPCs.index].Dialogue[Dialogue.NPC[Dialogue.NPCs.index].CurrentIndex] ~= nil then
                    Dialogue.NPC[Dialogue.NPCs.index].Dialogue[Dialogue.NPC[Dialogue.NPCs.index].CurrentIndex].Try(); 
                    if Dialogue.NPC[Dialogue.NPCs.index].CurrentIndex < Dialogue.NPC[Dialogue.NPCs.index].MaxIndex then
                        Dialogue.NPC[Dialogue.NPCs.index].CurrentIndex = Dialogue.NPC[Dialogue.NPCs.index].CurrentIndex + 1
                        print("008| incrementing with " .. Dialogue.NPC[Dialogue.NPCs.index].Name)
                        Dialogue.TryNext = Dialogue.NPC[Dialogue.NPCs.index].MyIndex
                        --Dialogue.TryNext = Dialogue.NPCs.index --unsure if this way will work
                    else
                        --Dialogue.NPC[Dialogue.NPCs.index].CurrentIndex = Dialogue.NPC[Dialogue.NPCs.index].CurrentIndex + 1
                        --Dialogue.NPC[Dialogue.NPCs.index].CurrentIndex = 0 --this is temp, it should change
                        Dialogue.NPC[Dialogue.NPCs.index].CurrentIndex = 0 --this is temp, it should change
                        print("008| setting to 0 with " .. Dialogue.NPC[Dialogue.NPCs.index].Name)
                        print("trynext is b: " .. Dialogue.TryNext)
                        Dialogue.TryNext = 0
                        print("trynext is b: " .. Dialogue.TryNext)
                    end
                end
                print("trynext is: " .. Dialogue.TryNext)
            end
            )
            print("Adding Dialogue to " .. _npcName)
        return Dialogue.NPCs.index
    end
    )
Dialogue.TryNext = 0;
Dialogue.Try = (function(_npcName)
        print("003| trying with " .. Dialogue.NPC[Dialogue.NPCs.index].Name)
        if PopupBox.TextBoxOn.Value() == 0 then
            print("004| trying with " .. Dialogue.NPC[Dialogue.NPCs.index].Name)
            for key, value in pairs(Dialogue.NPC) do
                print("005| trying with " .. Dialogue.NPC[Dialogue.NPCs.index].Name)
                print("005| key = " .. key .. " | value.Name = " .. value.Name)
                if value.Name == _npcName then
                    print("006| trying with " .. Dialogue.NPC[Dialogue.NPCs.index].Name)
                    Dialogue.NPC[key].Try()
                end
            end
        end
    end
    )
Dialogue.Read = (function()
print("Reading Dialogue")
        PopupBox.Close()
        if Dialogue.TryNext ~= 0 then
            print("trynext is: " .. Dialogue.TryNext)
            --Dialogue.NPC[Dialogue.TryNext].Dialogue[Dialogue.NPC[Dialogue.TryNext].CurrentIndex].Try()
            Dialogue.NPC[Dialogue.TryNext].Try()
        end
    end
    )

GPi = Dialogue.NPCs.Add("Guard Perinen")
Dialogue.NPC[GPi].MaxIndex = 1
Dialogue.NPC[GPi].Dialogue = {}
--Dialogue.NPC[Dialogue.NPCs.index].CurrentIndex = 1
Dialogue.NPC[GPi].Dialogue[Dialogue.NPC[GPi].MaxIndex] = {}
--Dialogue.NPC[GPi].Dialogue[Dialogue.NPC[GPi].MaxIndex].Try = (function()
Dialogue.NPC[GPi].Dialogue[Dialogue.NPC[GPi].MaxIndex].Try = (function()
        print("speaking with guard perinen 1")
        NPC[GPi].Speak("Oh, hey " .. AddressList["PlayerName"].Value() .. "! How ya been?", "PopupBox")
    end
    )
Dialogue.NPC[GPi].MaxIndex = Dialogue.NPC[GPi].MaxIndex + 1
Dialogue.NPC[GPi].Dialogue[Dialogue.NPC[GPi].MaxIndex] = {}
Dialogue.NPC[GPi].Dialogue[Dialogue.NPC[GPi].MaxIndex].Try = (function()
        print("speaking with guard perinen 2")
        NPC[GPi].Speak("I ain't seentcha in FOREVER! But for real though...", "PopupBox")
    end
    )
Dialogue.NPC[GPi].MaxIndex = Dialogue.NPC[GPi].MaxIndex + 1
Dialogue.NPC[GPi].Dialogue[Dialogue.NPC[GPi].MaxIndex] = {}
Dialogue.NPC[GPi].Dialogue[Dialogue.NPC[GPi].MaxIndex].Try = (function()
        print("speaking with guard perinen 2")
        NPC[GPi].Speak("Where have you been?", "PopupBox")
    end
    )
Dialogue.NPC[GPi].MaxIndex = Dialogue.NPC[GPi].MaxIndex + 1
Dialogue.NPC[GPi].Dialogue[Dialogue.NPC[GPi].MaxIndex] = {}
Dialogue.NPC[GPi].Dialogue[Dialogue.NPC[GPi].MaxIndex].Try = (function()
        print("speaking with guard perinen 2")
        NPC[GPi].Speak("I was beginning to worry that you might have died.... 8D", "PopupBox")
    end
    )
    
    
GPi = Dialogue.NPCs.Add("Stable Boy")
Dialogue.NPC[GPi].MaxIndex = 1
Dialogue.NPC[GPi].Dialogue = {}
--Dialogue.NPC[Dialogue.NPCs.index].CurrentIndex = 1
Dialogue.NPC[GPi].Dialogue[Dialogue.NPC[GPi].MaxIndex] = {}
--Dialogue.NPC[GPi].Dialogue[Dialogue.NPC[GPi].MaxIndex].Try = (function()
Dialogue.NPC[GPi].Dialogue[Dialogue.NPC[GPi].MaxIndex].Try = (function()
        print("speaking with guard perinen 1")
        NPC[GPi].Speak("I'm not a boy, I'm a man!!!", "PopupBox")
    end
    )
    
GPi = Dialogue.NPCs.Add("Banker Smothe")
Dialogue.NPC[GPi].MaxIndex = 1
Dialogue.NPC[GPi].Dialogue = {}
--Dialogue.NPC[Dialogue.NPCs.index].CurrentIndex = 1
Dialogue.NPC[GPi].Dialogue[Dialogue.NPC[GPi].MaxIndex] = {}
--Dialogue.NPC[GPi].Dialogue[Dialogue.NPC[GPi].MaxIndex].Try = (function()
Dialogue.NPC[GPi].Dialogue[Dialogue.NPC[GPi].MaxIndex].Try = (function()
        print("speaking with guard perinen 1")
        NPC[GPi].Speak("You a broke beeyatch, bitch.", "PopupBox")
    end
    )
    
    
--self.Speak("Hail " .. AddressList["PlayerName"].Value(), "PopupBox")
PopupBox = {};
PopupBox.TextBox = FAPI.CE.Address.New("[pcsx2-r3878.exe+00400C60]+578", "String", "TextBox", "57", "TypeGameChat");
PopupBox.TextBoxOn = FAPI.CE.Address.New("[pcsx2-r3878.exe+00400C60]+3EC", "Integer", "TextBoxOn", "1");
PopupBox.UKTextBox = FAPI.CE.Address.New("[pcsx2-r3878.exe+00400B40]+6B0", "String", "UKTextBox", "57", "TypeGameChat");
PopupBox.Show = (function(_message)
        PopupBox.TextBox.Value(_message)
        PopupBox.TextBoxOn.Value(1)
    end
    );
PopupBox.Close = (function()
        PopupBox.TextBoxOn.Value(0)
    end
    );
PopupBox.Show2 = (function(_message, _channel, _speaker)
        local ChannelMessage
        if _channel == "Say" then
            ChannelMessage = " says: "
        elseif _channel == "Shout" then
            ChannelMessage = " shouts at you: "
        elseif _channel == "Tell" then
            ChannelMessage = " whispers to you: "
        end
        PopupBox.Show(_speaker .. ChannelMessage .. _message)
        --PopupBox.TextBoxOn.Value(1)
    end
    );

FAPI.RunOptions.CrossPressCheck = FAPI.RunOptions.New(CrossPressCheck, true, "CrossPressCheck", 100)
FAPI.RunOptions.SquarePressCheck = FAPI.RunOptions.New(SquarePressCheck, true, "SquarePressCheck", 100)

-- From Dev World Pop
_G.Kanizah.AddOutputByAddressName("MyX");
_G.Kanizah.AddOutputByAddressName("MyY");
_G.Kanizah.AddOutputByAddressName("MyZ");
_G.Kanizah.AddOutputByAddressName("MyF");
--_G.Kanizah.AddOutputByFunctionReference("MyZone", EQOA.Player.Location.Zone);
--_G.Kanizah.AddOutputByDefinition("MyNestX");
--_G.Kanizah.AddOutputByDefinition("MyNestY");
--_G.Kanizah.AddOutputByDefinition("MyRow");
--_G.Kanizah.AddOutputByDefinition("MyColumn");
local i = 1
local imax = 50
while 1 == 2  do
--while i <= imax do
    _G.Kanizah.CurrentIndex = _G.Kanizah.CurrentIndex + 1
    _G.Kanizah.OutputArray[_G.Kanizah.CurrentIndex] = (function() if _G.NPCs[i] == nil then return "nil" else return _G.NPCs[i].Name(); end end);
    _G.Kanizah.AdditionalDataArray[_G.Kanizah.CurrentIndex] = "NPC" .. i .. "Name"
    _G.Kanizah.CurrentIndex = _G.Kanizah.CurrentIndex + 1
    _G.Kanizah.OutputArray[_G.Kanizah.CurrentIndex] = (function() if _G.NPCs[i] == nil then return "nil" else return _G.NPCs[i].X(); end end);
    _G.Kanizah.AdditionalDataArray[_G.Kanizah.CurrentIndex] = "NPC" .. i .. "X"
    _G.Kanizah.CurrentIndex = _G.Kanizah.CurrentIndex + 1
    _G.Kanizah.OutputArray[_G.Kanizah.CurrentIndex] = (function() if _G.NPCs[i] == nil then return "nil" else return _G.NPCs[i].Y(); end end);
    _G.Kanizah.AdditionalDataArray[_G.Kanizah.CurrentIndex] = "NPC" .. i .. "Y"
    _G.Kanizah.CurrentIndex = _G.Kanizah.CurrentIndex + 1
    _G.Kanizah.OutputArray[_G.Kanizah.CurrentIndex] = (function() if _G.NPCs[i] == nil then return "nil" else return _G.NPCs[i].Z(); end end);
    _G.Kanizah.AdditionalDataArray[_G.Kanizah.CurrentIndex] = "NPC" .. i .. "Z"
    _G.Kanizah.CurrentIndex = _G.Kanizah.CurrentIndex + 1
    _G.Kanizah.OutputArray[_G.Kanizah.CurrentIndex] = (function() if _G.NPCs[i] == nil then return "nil" else return _G.NPCs[i].F(); end end);
    _G.Kanizah.AdditionalDataArray[_G.Kanizah.CurrentIndex] = "NPC" .. i .. "F"
    i = i + 1
end
i = nil
imax = nil
--SilentMode = false;

_G.FAPI.RunOptions.UpdateVisualNPCs = FAPI.RunOptions.New(_G.NPCs.UpdateVisualNPCs, true, "UpdateVisualNPCs", 100);
--_G.FAPI.RunOptions.UpdateKanizah = FAPI.RunOptions.New(_G.Kanizah.UpdateOutput, true, "UpdateKanizah", 1000); --this does not process command file
_G.FAPI.RunOptions.UpdateKanizah = FAPI.RunOptions.New(_G.Kanizah.Update, true, "UpdateKanizah", 1000); --this does kanizah.updateoutput and processcommandfile
_G.FAPI.RunOptions.UpdateKanizahInput = FAPI.RunOptions.New(_G.Kanizah.UpdateInput, true, "UpdateKanizahInput", 1000);
--NPCs.Spawn("Randall_Adams")

--RF.EQOA.Net_Streams.o.self = RF.EQOA.Net_Streams.o.self .. "..//"
--GameLoop.MyTimer.interval_timer = 5000;
--GameLoop.MyTimer.timer.Interval = GameLoop.MyTimer.interval_timer;
function c() 
    os.execute("taskkill -f -im pcsx2-r3878.exe")
    sleep(200)
    closeCE()
end
-- Spots Code
Spot = {};
Spots = {};
Spots.NumberOfSpots = 0;
Spots.Add = (function(_spotName, _spotX, _spotY, _spotZ, _lockHeight, _tunFace, _odusface, _camZoom, _camUD, _loc)
        local i = 1
        local spotNameTaken = false;
        while Spot[i] ~= nil do
            if Spot[i].SpotName == _spotName then
                spotNameTaken = true;
            end
            i = i + 1
        end
        if spotNameTaken == false then
            Spots.NumberOfSpots = Spots.NumberOfSpots + 1
            local _thisSpot = {};
            _thisSpot.SpotName = _spotName;
            _thisSpot.SpotX = _spotX;
            _thisSpot.SpotY = _spotY;
            _thisSpot.SpotZ = _spotZ;
            _thisSpot.SpotLockHeight = _lockHeight;
            _thisSpot.TunFace = _tunFace;
            _thisSpot.OdusFace = _odusface;
            _thisSpot.CamZoom = _camZoom;
            _thisSpot.CamUD = _camUD;
            _thisSpot.Loc = _loc
            _thisSpot.Index = Spots.NumberOfSpots;
            Spot[Spots.NumberOfSpots] = _thisSpot;
        end
    end
    );
function GotoSpot(_spotName)
        local i = 1
        while Spot[i] ~= nil do
            if Spot[i].SpotName == _spotName then
            co2("Spot Found at Index: " .. i);
            co2("Spot Details:");
            co2("   x = " .. Spot[i].SpotX);
            co2("   y = " .. Spot[i].SpotY);
            co2("   z = " .. Spot[i].SpotZ);
            co2("  LH = " .. tostring(Spot[i].SpotLockHeight));
                addresslist_getMemoryRecordByDescription(getAddressList(), "JP").Value = 500;
                sleep("50");
                addresslist_getMemoryRecordByDescription(getAddressList(), "JP").Value = 5;
                addresslist_getMemoryRecordByDescription(getAddressList(), "JP").Active = true;
                sleep("2000");
            --addresslist_getMemoryRecordByDescription(getAddressList(), "EW").Value = Spot[i].SpotX;
            --addresslist_getMemoryRecordByDescription(getAddressList(), "NS").Value = Spot[i].SpotY;
            --addresslist_getMemoryRecordByDescription(getAddressList(), "JP").Value = Spot[i].SpotZ;
                addresslist_getMemoryRecordByDescription(getAddressList(), "Loc").Value = Spot[i].Loc;
                
               -- writeInteger("[pcsx2-r3878.exe+0040239C]+6d8") = Spot[i].SpotX
                ----writeInteger("[pcsx2-r3878.exe+0040239C]+6e0") = Spot[i].SpotY
                --AddressList["MyY"].Value(Spot[i].SpotY)
                --AddressList["MyZ"].Value(Spot[i]._spotZ)
                --addresslist_getMemoryRecordByDescription(getAddressList(), "Jump Pointer").Value = Spot[i].SpotZ;
                ----readInteger("[pcsx2-r3878.exe+0040239C]+6dc") = Spot[i].SpotZ
                sleep("5");
                --if Spot[i].SpotLockHeight == true then
                    --memoryrecord_freeze(addresslist_getMemoryRecordByDescription(getAddressList(), "Jump Pointer"));
                addresslist_getMemoryRecordByDescription(getAddressList(), "JP").Active = Spot[i].SpotLockHeight;
                
            addresslist_getMemoryRecordByDescription(getAddressList(), "TunFace").Value = Spot[i].TunFace;
            addresslist_getMemoryRecordByDescription(getAddressList(), "OdusFace").Value = Spot[i].OdusFace;
            addresslist_getMemoryRecordByDescription(getAddressList(), "CamZoom").Value = Spot[i].CamZoom;
            addresslist_getMemoryRecordByDescription(getAddressList(), "CamUD").Value = Spot[i].CamUD;
                --end
                return;
            end
            i = i + 1
        end
        co2("Spot Not Found");
end
--[[
        GotoSpot("arena");
        SetGroundSpot("arena");
    ]]--
function SetGroundSpot(_spotName)
    co2("Making Ground Spot: " .. _spotName);
    co2("At  x: " .. addresslist_getMemoryRecordByDescription(getAddressList(), "EW").Value)
    co2("    y: " .. addresslist_getMemoryRecordByDescription(getAddressList(), "NS").Value)
    co2("    z: " .. addresslist_getMemoryRecordByDescription(getAddressList(), "JP").Value)

    Spots.Add(_spotName, addresslist_getMemoryRecordByDescription(getAddressList(), "EW").Value, addresslist_getMemoryRecordByDescription(getAddressList(), "NS").Value, addresslist_getMemoryRecordByDescription(getAddressList(), "JP").Value, false, addresslist_getMemoryRecordByDescription(getAddressList(), "TunFace").Value, addresslist_getMemoryRecordByDescription(getAddressList(), "OdusFace").Value, addresslist_getMemoryRecordByDescription(getAddressList(), "CamZoom").Value, addresslist_getMemoryRecordByDescription(getAddressList(), "CamUD").Value, addresslist_getMemoryRecordByDescription(getAddressList(), "Loc").Value);
end
function SetAirSpot(_spotName)
    co2("Making Ground Spot: " .. _spotName);
    co2("At  x: " .. addresslist_getMemoryRecordByDescription(getAddressList(), "EW").Value)
    co2("    y: " .. addresslist_getMemoryRecordByDescription(getAddressList(), "NS").Value)
    co2("    z: " .. addresslist_getMemoryRecordByDescription(getAddressList(), "JP").Value)

    Spots.Add(_spotName, addresslist_getMemoryRecordByDescription(getAddressList(), "EW").Value, addresslist_getMemoryRecordByDescription(getAddressList(), "NS").Value, addresslist_getMemoryRecordByDescription(getAddressList(), "JP").Value, true);
end

----_G.LanPlayers = {};
----_G.LanPlayers[0] = "-"
----_G.FAPI.Kanizah.UpdateLanPlayers = dofile(FAPI.DirectoryLocation .. "Kanizah/UpdateLanPlayers.lua");
----_G.FAPI.RunOptions.UpdateLanPlayers = FAPI.RunOptions.New(_G.FAPI.Kanizah.UpdateLanPlayers, true, "UpdateLanPlayers", 3000)
--FAPI.RunOptions.UpdateVisualNPCs.Try(true)
NPCs.Spawn("Guard Perinen")


print("All Settings Loaded.")
