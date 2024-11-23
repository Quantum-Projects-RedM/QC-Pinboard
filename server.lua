local RSGCore = exports['rsg-core']:GetCoreObject()

RegisterServerEvent("qc-pinboard:get_posters")
AddEventHandler("qc-pinboard:get_posters", function(city)
    local _source = source
    local tablex = {}
    local _source = source
	local xPlayer = RSGCore.Functions.GetPlayer(_source)
    local group = RSGCore.Functions.GetPermission(_source)
    local cid = xPlayer.PlayerData.citizenid
    MySQL.Async.fetchAll('SELECT * FROM posters WHERE city=@city', {['@city'] = city}, function (result)
        if #result > 0 then
            for i=1, #result, 1 do
                tablex[i] = {
                    title = result[i].title,
                    poster_link = result[i].poster_link,
                    charidentifier = result[i].charidentifier,
                    id = result[i].id,
                }
            end
        end
        TriggerClientEvent("qc-pinboard:send_list",_source,tablex,cid,group)
    end)
end)

RegisterServerEvent("qc-pinboard:set_link")
AddEventHandler("qc-pinboard:set_link", function(title,poster_link,city)
    local _source = source
    local xPlayer = RSGCore.Functions.GetPlayer(_source)
    local xPlayerName = xPlayer.PlayerData.charinfo.firstname .. ' ' .. xPlayer.PlayerData.charinfo.lastname
    if poster_link ~= nil then 
        local cid = xPlayer.PlayerData.citizenid
        Discord(Config.webhook,title,poster_link, 3447003,city, xPlayerName)
        local parameters = { ['title'] = title,  ['poster_link'] = poster_link, ['city'] = city, ['charidentifier'] = cid}
        MySQL.Async.execute("INSERT INTO posters ( `title`, `poster_link`, `city`, `charidentifier`) VALUES ( @title, @poster_link, @city, @charidentifier)" ,parameters,
        function(rowsChanged)
        end)
    end
end)

RegisterServerEvent("qc-pinboard:removeposter")
AddEventHandler("qc-pinboard:removeposter", function(id)
    local _source = source
    MySQL.update('DELETE FROM posters WHERE id = ?', { id })
end)

RSGCore.Commands.Add('clearpins', 'clear all the pins', {}, false, function(source)
    MySQL.Async.execute("TRUNCATE TABLE posters", {})
end, 'admin')


function Discord(webhook, title, description, color,city, name)
    local logs = ""
    local avatar = Config.webhookIMG
    if string.match(description, "http") then
        logs = {
          {
              ["color"] = color,
              ["title"] = title,
              ["image"]={["url"]= description},
              ["footer"] = {["text"]="Town: "..city,["icon_url"]= Config.webhookIMG}
          }
        }
    else
        logs = {
            {
                ["color"] = color,
                ["title"] = title,
                ["description"] = description,
                ["footer"] = {["text"]="Town: "..city,["icon_url"]= Config.webhookIMG}
            }
          }
    end
        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({["username"] = name ,["avatar_url"] = avatar ,embeds = logs}), { ['Content-Type'] = 'application/json' })
  end


  local function CheckVersion()
    PerformHttpRequest('https://raw.githubusercontent.com/Quantum-Projects-RedM/QC-VersionCheckers/master/QC-Pinboard.txt', function(err, newestVersion, headers)
        local currentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version')
        local resourceName = GetCurrentResourceName()
        local contactInfo = "Please Check Github For An Update"

        if not newestVersion then
            print("\n^1[Quantum Projects]^7 Unable to perform version check.\n")
            return
        end

        local isLatestVersion = newestVersion:gsub("%s+", "") == currentVersion:gsub("%s+", "")
        if isLatestVersion then
            print(("^3[Quantum Projects]^7: You are running the latest version of ^2%s^7 (^2%s^7)."):format(resourceName, currentVersion))
        else
            print("\n^6========================================^7")
            print("^3[Quantum Projects]^7 Version Checker")
            print("")
            print(("^3Version Check^7:\n ^2Current^7: %s\n ^2Latest^7: %s\n"):format(currentVersion, newestVersion))
            print(("^1You are running an outdated version of %s.\n%s^7"):format(resourceName, contactInfo))
            print("^6========================================^7\n")
        end
    end)
end

CheckVersion()
