local round = 0
local zombies = {}

-- 1006 1007

local function NextRound()
   round = round + 1
   local players = GetAllPlayers()
   for playerId = 1, #players do
    CallRemoteEvent(players[playerId], "OnRoundStart", round)
   end
   local zombiesToSpawn = round
   while zombiesToSpawn > 0 do
    local zombie = CreateNPC(math.random(21, 22), 125773.000000, 80246.000000, 1600.000000, 90.0)
    table.insert(zombies, zombie)
    zombiesToSpawn = zombiesToSpawn - 1
   end
end

local function DestroyZombies()
    for index = 1, #zombies do
        if zombies[index] ~= nil and IsValidNPC(zombies[index]) then
            DestroyNPC(zombies[index])
            zombies[index] = nil
        end
    end
end

AddEvent("OnNPCDeath", function(npc, player)
    for index = 1, #zombies do
        if zombies[index] == npc then
            DestroyNPC(zombies[index])
            zombies[index] = nil
            SetPlayerPropertyValue(player, "money", GetPlayerPropertyValue(player, "money") + 50, true)
            if #zombies == 0 then
                Delay(10000, function()
                    NextRound()
                end)
            end
            return
        end
    end
end)

AddEvent("OnPlayerWeaponShot", function(player, weapon, hitType, hitId, hitX, hitY, hitZ, startX, startY, normalX, normalY, normalZ)
    if hitType == 4 then
        for index = 1, #zombies do
            if zombies[index] == hitId then
                SetPlayerPropertyValue(player, "money", GetPlayerPropertyValue(player, "money") + 5, true)
                return
            end
        end
    end
end)

AddEvent("OnPlayerQuit", function(player)
    if #GetAllPlayers() == 1 then
        DestroyZombies()
        round = 0
    end
end)

AddEvent("OnPlayerJoin", function(player)
    if round == 0 then
        Delay(10000, function()
            NextRound()
        end)
    end
end)

AddEvent("OnPackageStop", DestroyZombies)

local function GetNearestPlayer(npc)
    local zX, zY, zZ = GetNPCLocation(npc)
    local players = GetAllPlayers()
    local targetPlayer = nil
    local oldDistance = 100000000
    for pIndex = 1, #players do
        local dist = GetDistance3D(zX, zY, zZ, GetPlayerLocation(players[pIndex]))
        if dist < oldDistance then
            dist = oldDistance
            targetPlayer = players[pIndex]
        end
    end
    return targetPlayer
end

AddEvent("OnNPCReachTarget", function(npc)
    local player = GetNearestPlayer(npc)
    if player ~= nil and IsValidPlayer(player) then
        SetPlayerHealth(player, GetPlayerHealth(player) - 50)
        --player hp regeneration
        Delay(2500, function()
            SetPlayerHealth(player, 100)
        end)
    end
end)

CreateTimer(function()
    --zombie following target logic
    for zIndex = 1, #zombies do
        if zombies[zIndex] ~= nil and IsValidNPC(zombies[zIndex]) then
            local player = GetNearestPlayer(zombies[zIndex])
            if player ~= nil and IsValidPlayer(player) then
                SetNPCFollowPlayer(zombies[zIndex], player, 200)
            end
        end
    end
end, 1000)