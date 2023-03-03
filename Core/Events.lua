local Name = ...

local Addon = select(2, ...)
local AceComm = LibStub("AceComm-3.0")

local L = LibStub("AceLocale-3.0"):GetLocale(Name)
local Locale, Util = Addon.Locale, Addon.Util
local Self = Addon

function Self.RegisterEvents()
    Self:RegisterEvent("RAID_ROSTER_UPDATE", "GROUP_CHANGED")
end

function Self.UnregisterEvents()
    Self:UnregisterEvent("RAID_ROSTER_UPDATE")
end

function Self.GROUP_CHANGED()
    print('Group changed')
end