local function GetPlayerStatus(serverId)
    local status = lib.callback.await('getPlayerStatus', source, serverId)
    return type(status) == "string" and status or "none"
end

local function HasStatus(serverId)
    return GetPlayerStatus(serverId) ~= "none"
end

RegisterCommand("setstatus", function()
    local input = lib.inputDialog('Set Your Status', {
        { type = 'input', label = 'Text', description = 'How would your character appear?', required = true, min = 4, max = 100 },
    })
    if not input then return end
    local serverId = GetPlayerServerId(PlayerId())
    TriggerServerEvent('bostra_status:setPlayerStatus', input[1], serverId)
end, false)

RegisterCommand("clearstatus", function()
    local serverId = GetPlayerServerId(PlayerId())
    TriggerServerEvent('bostra_status:setPlayerStatus', nil, serverId)
end, false)

RegisterCommand("getstatus", function()
    local serverId = GetPlayerServerId(PlayerId())
    local status = lib.callback.await('getPlayerStatus', source, serverId)
    if status then
        lib.notify({ title = "Your status: " .. status })
    else
        lib.notify({ title = "You have not set a status." })
    end
end, false)

local options = {
    label = "Observe",
    name = "observe",
    icon = "fas fa-eye",
    distance = Config.Distance,
    canInteract = function(data)
        local serverId, _ = lib.getClosestPlayer(GetEntityCoords(cache.ped), 3.0, false)
        return HasStatus(GetPlayerServerId(serverId))
    end,
    onSelect = function(data)
        local serverId, _ = lib.getClosestPlayer(GetEntityCoords(cache.ped), 3.0, false)
        local serverId = GetPlayerServerId(serverId)
        local status = GetPlayerStatus(serverId)
        if status then
            lib.notify({ type = 'success', title = "Player has status: " .. status })
        end
    end
}
exports.ox_target:addGlobalPlayer(options)