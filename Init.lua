---@type string
local Name = ...
---@type Addon
local Addon = select(2,  ...)
local Version = GetAddOnMetadata("SchweinDKP", "Version")
LibStub("AceAddon-3.0"):NewAddon(Addon, Name, "AceConsole-3.0", "AceComm-3.0", "AceSerializer-3.0", "AceEvent-3.0", "AceTimer-3.0", "AceHook-3.0")

Addon.ABBR = "SDKP"
Addon.VERSION = tonumber(Version) or Version
Addon.DEBUG = true

-- Modules
---@class Module
Addon.Module = {}
local Module = Addon.Module

---@return boolean
function Module:ShouldBeEnabled() return self.enableState end

function Module:CheckState(...)
    if Addon.Util.Bool.XOR(self:ShouldBeEnabled(...), self.enabledState) then
        if not self.initialized then
            self:SetEnabledState(not self.enabledState)
        else
            self[self.enabledState and "Disable" or "Enable"](self)
        end
    end
    self.initialized = true
end

Addon.GUI = Addon:NewModule("GUI", Module, "AceEvent-3.0")
Addon.Options = {}
Addon.Roster = {}

Addon.Locale = {}
Addon.Util = {}



--- Event Sourcing?
--- Repeating timers
--- Event store data model?
--- Addon channel communication
--- 