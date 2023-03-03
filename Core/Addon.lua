local Name = ...

local Addon = select(2, ...)

local L = LibStub("AceLocale-3.0"):GetLocale(Name)
local RI = LibStub("LibRealmInfo")
local GUI, Options, Util = Addon.GUI, Addon.Options, Addon.Util
local Self = Addon

function Self:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New(Name .. "DB", Options.DEFAULTS, true)

    self:SetEnabledState(self.db.profile.enabled)

    Options.Register()

    self:RegisterChatCommand(Name, "HandleChatCommand")
    self:RegisterChatCommand("sdkp", "HandleChatCommand")

    -- Register chat commands
end

function Self:OnEnable()
    self:EnableHooks()
    self:RegisterEvents()
end

function Self:OnDisable()
    self:UnregisterEvents()
    self:DisableHooks()
end

function Self:HandleChatCommand(msg)
    local args = Util.Tbl.New(self:GetArgs(msg, 10))
    args[11] = nil

    local cmd = tremove(args, 1)

    if cmd == "help" then
        GUI.Roster.Toggle()
    end
end