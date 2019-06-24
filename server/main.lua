-----------------------------------------
-- Created and modify by Slewog and PlumesYT
-----------------------------------------

ESX = nil
local PlayersTransforming  = {}
local PlayersSelling       = {}
local PlayersHarvesting = {}
local cidre = 1
local jus = 1
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
	TriggerEvent('esx_service:activateService', 'arboriculturist', Config.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'arboriculturist', _U('arboriculturist_client'), true, true)
TriggerEvent('esx_society:registerSociety', 'arboriculturist', 'Arbo_cultureur', 'society_arboriculturist', 'society_arboriculturist', 'society_arboriculturist', {type = 'public'})
local function Harvest(source, zone)
	if PlayersHarvesting[source] == true then

		local xPlayer  = ESX.GetPlayerFromId(source)
		if zone == "AppleFarm" then
			local itemQuantity = xPlayer.getInventoryItem('apple').count
			if itemQuantity >= 100 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_place'))
				return
			else
				SetTimeout(2000, function()
					xPlayer.addInventoryItem('apple', 1)
					Harvest(source, zone)
				end)
			end
		end
	end
end

RegisterServerEvent('esx_arboriculturistjob:startHarvest')
AddEventHandler('esx_arboriculturistjob:startHarvest', function(zone)
	local _source = source
  	
	if PlayersHarvesting[_source] == false then
		TriggerClientEvent('esx:showNotification', _source, _U('glitch'))
		PlayersHarvesting[_source]=false
	else
		PlayersHarvesting[_source]=true
		TriggerClientEvent('esx:showNotification', _source, _U('apple_taken'))  
		Harvest(_source,zone)
	end
end)


RegisterServerEvent('esx_arboriculturistjob:stopHarvest')
AddEventHandler('esx_arboriculturistjob:stopHarvest', function()
	local _source = source
	
	if PlayersHarvesting[_source] == true then
		PlayersHarvesting[_source]=false
		TriggerClientEvent('esx:showNotification', _source, _U('exit_zone'))
	else
		TriggerClientEvent('esx:showNotification', _source, _U('on_farm'))
		PlayersHarvesting[_source]=true
	end
end)


local function Transform(source, zone)

	if PlayersTransforming[source] == true then

		local xPlayer  = ESX.GetPlayerFromId(source)
		if zone == "TraitementCidre" then
			local itemQuantity = xPlayer.getInventoryItem('apple').count
			
			if itemQuantity <= 0 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_apple'))
				return
			else
				local rand = math.random(0,100)
				if (rand >= 95) then
					SetTimeout(2500, function()
						xPlayer.removeInventoryItem('apple', 1)
						xPlayer.addInventoryItem('cidre', 1)
						TriggerClientEvent('esx:showNotification', source, _U('cidre_pop'))
						Transform(source, zone)
					end)
				else
					SetTimeout(1500, function()
						xPlayer.removeInventoryItem('apple', 1)
						xPlayer.addInventoryItem('apple_jus', 1)
				
						Transform(source, zone)
					end)
				end
			end
		end
	end	
end

RegisterServerEvent('esx_arboriculturistjob:startTransform')
AddEventHandler('esx_arboriculturistjob:startTransform', function(zone)
	local _source = source
  	
	if PlayersTransforming[_source] == false then
		TriggerClientEvent('esx:showNotification', _source, _U('glitch'))
		PlayersTransforming[_source]=false
	else
		PlayersTransforming[_source]=true
		TriggerClientEvent('esx:showNotification', _source, _U('transforming_in_progress')) 
		Transform(_source,zone)
	end
end)

RegisterServerEvent('esx_arboriculturistjob:stopTransform')
AddEventHandler('esx_arboriculturistjob:stopTransform', function()

	local _source = source
	
	if PlayersTransforming[_source] == true then
		PlayersTransforming[_source]=false
		TriggerClientEvent('esx:showNotification', _source, _U('exit_zone'))
		
	else
		TriggerClientEvent('esx:showNotification', _source, _U('trait_apple'))
		PlayersTransforming[_source]=true
		
	end
end)

local function Sell(source, zone)

	if PlayersSelling[source] == true then
		local xPlayer  = ESX.GetPlayerFromId(source)
		
		if zone == 'SellFarm' then
			if xPlayer.getInventoryItem('cidre').count <= 0 then
				cidre = 0
			else
				cidre = 1
			end

			if xPlayer.getInventoryItem('apple_jus').count <= 0 then
				jus = 0
			else
				jus = 1
			end
		
			if cidre == 0 and jus == 0 then
				TriggerClientEvent('esx:showNotification', source, _U('no_product_sale'))
				return
			elseif xPlayer.getInventoryItem('cidre').count <= 0 and jus == 0 then
				TriggerClientEvent('esx:showNotification', source, _U('no_cidre_sale'))
				cidre = 0
				return
			elseif xPlayer.getInventoryItem('apple_jus').count <= 0 and cidre == 0 then
				TriggerClientEvent('esx:showNotification', source, _U('no_jus_sale'))
				jus = 0
				return
			else
				if (jus == 1) then
					SetTimeout(1000, function()
						local money = math.random(10,12)
						xPlayer.removeInventoryItem('apple_jus', 1)
						local societyAccount = nil

						TriggerEvent('esx_addonaccount:getSharedAccount', 'society_arboriculturist', function(account)
							societyAccount = account
						end)
						if societyAccount ~= nil then
							societyAccount.addMoney(money)
							TriggerClientEvent('esx:showNotification', xPlayer.source, _U('comp_earned') .. money)
						end
						Sell(source,zone)
					end)
				elseif (cidre == 1) then
					SetTimeout(1000, function()
						local money = math.random(18,20)
						xPlayer.removeInventoryItem('cidre', 1)
						local societyAccount = nil

						TriggerEvent('esx_addonaccount:getSharedAccount', 'society_arboriculturist', function(account)
							societyAccount = account
						end)
						if societyAccount ~= nil then
							societyAccount.addMoney(money)
							TriggerClientEvent('esx:showNotification', xPlayer.source, _U('comp_earned') .. money)
						end
						Sell(source,zone)
					end)
				end
				
			end
		end
	end
end

RegisterServerEvent('esx_arboriculturistjob:startSell')
AddEventHandler('esx_arboriculturistjob:startSell', function(zone)

	local _source = source
	
	if PlayersSelling[_source] == false then
		TriggerClientEvent('esx:showNotification', _source, _U('glitch'))
		PlayersSelling[_source]=false
	else
		PlayersSelling[_source]=true
		TriggerClientEvent('esx:showNotification', _source, _U('sale_in_prog'))
		Sell(_source, zone)
	end

end)

RegisterServerEvent('esx_arboriculturistjob:stopSell')
AddEventHandler('esx_arboriculturistjob:stopSell', function()

	local _source = source
	
	if PlayersSelling[_source] == true then
		PlayersSelling[_source]=false
		TriggerClientEvent('esx:showNotification', _source, _U('exit_zone'))
		
	else
		TriggerClientEvent('esx:showNotification', _source, _U('sell_farm'))
		PlayersSelling[_source]=true
	end

end)

RegisterServerEvent('esx_arboriculturistjob:getStockItem')
AddEventHandler('esx_arboriculturistjob:getStockItem', function(itemName, count)

	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_arboriculturist', function(inventory)

		local item = inventory.getItem(itemName)

		if item.count >= count then
			inventory.removeItem(itemName, count)
			xPlayer.addInventoryItem(itemName, count)
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
		end

		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_withdrawn') .. count .. ' ' .. item.label)

	end)

end)

ESX.RegisterServerCallback('esx_arboriculturistjob:getStockItems', function(source, cb)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_arboriculturist', function(inventory)
		cb(inventory.items)
	end)

end)

RegisterServerEvent('esx_arboriculturistjob:putStockItems')
AddEventHandler('esx_arboriculturistjob:putStockItems', function(itemName, count)

	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_arboriculturist', function(inventory)

		local item = inventory.getItem(itemName)

		if item.count >= 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
		end

		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('added') .. count .. ' ' .. item.label)

	end)
end)

ESX.RegisterServerCallback('esx_arboriculturistjob:getPlayerInventory', function(source, cb)

	local xPlayer    = ESX.GetPlayerFromId(source)
	local items      = xPlayer.inventory

	cb({
		items      = items
	})

end)

ESX.RegisterUsableItem('cidre', function(source)

    local xPlayer = ESX.GetPlayerFromId(source)

    xPlayer.removeInventoryItem('cidre', 1)

    TriggerClientEvent('esx_status:add', source, 'drunk', 300000)
    --TriggerClientEvent('esx_status:remove', source, 'thirst', 50000)
    --TriggerClientEvent('esx_status:remove', source, 'pee', 30000)
    TriggerClientEvent('esx_optionalneeds:onDrink', source)
    TriggerClientEvent('esx:showNotification', source, _U('used_cidre'))

end)

ESX.RegisterUsableItem('apple', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('apple', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 100000)
	--TriggerClientEvent('esx_status:remove', source, 'shit', 35000)
    --TriggerClientEvent('esx_status:remove', source, 'pee', 15000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	TriggerClientEvent('esx:showNotification', source, _U('used_apple'))

end)

ESX.RegisterUsableItem('apple_jus', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('apple_jus', 1)

    --TriggerClientEvent('esx_status:remove', source, 'shit', 35000)
    --TriggerClientEvent('esx_status:remove', source, 'pee', 15000)
	TriggerClientEvent('esx_status:add', source, 'hunger', 40000)
	TriggerClientEvent('esx_status:add', source, 'thirst', 120000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	TriggerClientEvent('esx:showNotification', source, _U('used_jus'))

end)