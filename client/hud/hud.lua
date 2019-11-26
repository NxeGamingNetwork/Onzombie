Delay(1000, function()
    EnableFirstPersonCamera(true)
    ShowChat(false)
end)
local web = CreateWebUI(0,0,0,0,1,16)
SetWebAlignment(web, 0,0)
SetWebAnchors(web, 0,0,1,1)
SetWebURL(web, "http://asset/Onzombie/client/hud/hud.html")
SetWebVisibility(web, WEB_HITINVISIBLE)

AddEvent("OnPlayerNetworkUpdatePropertyValue", function(id, name, value)
    if name == "money" then
        ExecuteWebJS(web, "setMoney("..value..");")
        return
    end
end)

AddRemoteEvent("OnRoundStart", function(round)
    ExecuteWebJS(web, "setRound("..round..");")
end)
