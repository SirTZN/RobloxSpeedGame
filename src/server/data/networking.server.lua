--[[
    Where live data is handled, on both the client and server side
    Uses knit to transmit on both
]]

local RS = game:GetService("ReplicatedStorage")
local knit = require(RS.Packages.Knit)
local datastore = require(game:GetService("ServerScriptService").libs.datastore)

local data_network = knit.CreateService {
    Name = "data_network"
}

live_player_data = setmetatable({}, {
    __index = function()
        return {}
    end
})

function data_network:init(plr)
    local default_data = {
        speed_coins = 0,
        speed = 1,
    }

    live_player_data[plr.UserId] = datastore.get(plr)

    if not live_player_data[plr.UserId] then
        live_player_data[plr.UserId] = default_data
        print("Set player to default attributes (user not in database)")
    end
end

function data_network:get_data(plr)
    return live_player_data[plr.UserId]
end

function data_network:get_attribute(plr, attribute)
    return live_player_data[plr.UserId][attribute]
end

function data_network:set_attribute(plr, attribute, value)
    live_player_data[plr.UserId][attribute] = value
end 

function data_network:add_attribute(plr, attribute, value)
    live_player_data[plr.UserId][attribute] += value
end 

--[[
    Client Replicated Functions
]]

function data_network.Client:get_data(plr)
    return self.Server:get_data(plr)
end

function data_network.Client:get_attribute(plr)
    return self.Server:get_attribute(plr)
end

print("Server Networking Fully Initialized")

knit.Start():catch(warn)