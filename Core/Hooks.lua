---@type string
local Name = ...
---@type Addon
local Addon = select(2, ...)
---@type L
local L = LibStub("AceLocale-3.0"):GetLocale(Name)
local GUI, Util = Addon.GUI, Addon.Util
local Self = Addon


function Self.EnableHooks()
end

function Self.DisableHooks()
end