local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LP = Players.LocalPlayer

local BASE_URL = "https://raw.githubusercontent.com/fakealexxx/alez/refs/heads/main/games/"

local MODULES_BY_PLACE = {
    [71106427459865] = { name = "Word Game", file = "word-game.lua" },
}

local MODULES_BY_GAME = {
    [10766954651] = { name = "Word Game", file = "word-game.lua" },
}

local function findModule()
    return MODULES_BY_PLACE[game.PlaceId] or MODULES_BY_GAME[game.GameId]
end

local function showUnsupported()
    local message = string.format(
        "Kicked by moderator\n\n"
        .. "This game is not supported by Alez.\n\n"
        .. "PlaceId: %d\n"
        .. "GameId: %d",
        game.PlaceId, game.GameId
    )
    
    if RunService:IsStudio() then
        warn("[Alez] " .. message)
        return
    end
    
    pcall(function()
        LP:Kick(message)
    end)
end

local module = findModule()

if not module then
    showUnsupported()
    return
end

local ok, err = pcall(function()
    local source = game:HttpGet(BASE_URL .. module.file)
    local fn = loadstring(source)
    if not fn then
        error("compile failed for " .. module.file)
    end
    fn()
end)

if not ok then
    warn("[Alez] Failed to load module '" .. module.name .. "': " .. tostring(err))
end
