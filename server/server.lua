local Statuses = {}

RegisterNetEvent('bostra_status:setPlayerStatus', function(status, serverId)
    local serverId = tonumber(serverId)
    if not serverId then return end

    if not status then
        Statuses[serverId] = nil
    else
        Statuses[serverId] = status
    end

    TriggerClientEvent('ox_lib:notify', source, { type = 'success', title = "Status set." })
end)

lib.callback.register('getPlayerStatus', function(source, serverId)
    if not serverId then return end

    local serverId = tonumber(serverId)
    local status = Statuses[serverId]

    if not status then
        return nil
    end

    return status
end)
