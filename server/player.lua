AddEvent("OnPlayerJoin", function(player)
    -- Gas station
    SetPlayerSpawnLocation(player, 125773.000000, 80246.000000, 1645.000000, 90.0)
    Delay(2000, function()
        --SetPlayerPropertyValue(player, "perks", {}, true)
        SetPlayerPropertyValue(player, "money", 1000, true)
        -- Pistol spawn
        SetPlayerWeapon(player, 3, 160, true, 1, true)
    end)
end)