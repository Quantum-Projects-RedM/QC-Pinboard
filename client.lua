local RSGCore = exports['rsg-core']:GetCoreObject()

local prompt = GetRandomIntInRange(0, 0xffffff)
local menubutton
local active = false
local city = ""
local poster_table = {}
local charidentifier
local group

function Send_Poster(bool)
    SetNuiFocus(bool, bool)

    guiEnabled = bool
    SendNUIMessage({
		resourceName = GetCurrentResourceName(),
        type = "ui",
        status = bool,
    })
end

function Show_Poster(bool)
    SetNuiFocus(bool, bool)
    guiEnabled = bool
    SendNUIMessage({
		resourceName = GetCurrentResourceName(),
        type = "poster_table",
        status = bool,
		charidentifier = charidentifier,
		group = group,
		table_for_json = poster_table
		})
end

CreateThread(function()

	for k,v in pairs(Config.Posters) do
		exports['rsg-core']:createPrompt(v.name, v.coords, 0xF3830D8E, 'Open ' .. v.name, {
			type = 'client',
			event = 'qc-pinboard:client_getPoster',
			args = {v.city},
		})
	end

end)

RegisterNetEvent('qc-pinboard:client_getPoster', function(b)
	--print('args ' .. json.encode(args))
	--local _city = args.city
	--local a = table.unpack({"Velantine"})
	--print(a)
	local _city = b
	TriggerServerEvent("qc-pinboard:get_posters", _city)

	active = true
	Wait(1000)
	Show_Poster(true)

end)

RegisterNetEvent('qc-pinboard:send_list')
AddEventHandler('qc-pinboard:send_list', function(table,x,y)
	poster_table = table
	charidentifier = x
	for k,_ in pairs(y) do
		if Config.Groups[k] then
			group = true
			break
		end
		group = false
	end
end)

Citizen.CreateThread(function()
	for k,v in pairs(Config.Posters) do
		local blips = N_0x554d9d53f696d002(1664425300, v.coords[1], v.coords[2], v.coords[3])
		SetBlipSprite(blips, 1735233562, 1)
		SetBlipScale(blips, 1.0)
		Citizen.InvokeNative(0x9CB1A1623062F402, blips, "Notice Board")
	end
end)


RegisterNUICallback('send_to_poster', function(data, cb)
    for k,v in pairs(Config.Posters) do
		local coords = GetEntityCoords(PlayerPedId())
		if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.coords[1], v.coords[2], v.coords[3], false) < 10.0 then
			if data.Title ~= "" then
				local s = data.Link
				--TriggerEvent("vorp:TipBottom", "You pinned a paper to the notice board", 4000)
				TriggerServerEvent("qc-pinboard:set_link", data.Title, s:gsub("%'", ""), v.city)
				Citizen.Wait(1000)
				TriggerServerEvent("qc-pinboard:get_posters", v.city)
				Send_Poster(false, false)
				Show_Poster(false, false)
				SetNuiFocus(false, false)
				guiEnabled = false
				active = false
			else
				Send_Poster(false, false)
				Show_Poster(false, false)
				SetNuiFocus(false, false)
				guiEnabled = false
				active = false
			end
		end
	end
end)

RegisterNUICallback('exit', function(data, cb)
    Send_Poster(false, false)
	Show_Poster(false, false)
    SetNuiFocus(false, false)
    guiEnabled = false
	active = false
	cb('ok')
end)


RegisterNUICallback('removepin', function(data, cb)
    Send_Poster(false, false)
	Show_Poster(false, false)
    SetNuiFocus(false, false)
    guiEnabled = false
	active = false
	cb('ok')
	TriggerServerEvent("qc-pinboard:removeposter", data.id)
end)
