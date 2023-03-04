local Name = ...

local Addon = select(2, ...)

local L = LibStub("AceLocale-3.0"):GetLocale(Name)
local RI = LibStub("LibRealmInfo")
local GUI, Options, Util, Unit = Addon.GUI, Addon.Options, Addon.Util, Addon.Unit
local Self = Addon

-- Logging
Self.ECHO_NONE = 0
Self.ECHO_ERROR = 1
Self.ECHO_INFO = 2
Self.ECHO_VERBOSE = 3
Self.ECHO_DEBUG = 4
Self.ECHO_LEVELS = {"ERROR", "INFO", "VERBOSE", "DEBUG"}

-- Max # of log entries before starting to delete old ones
Self.LOG_MAX_ENTRIES = 500
-- Max # of logged addon error messages
Self.LOG_MAX_ERRORS = 10
-- Max # of handled errors per second
Self.LOG_MAX_ERROR_RATE = 10

Self.log = {}
Self.errors = 0
Self.errorPrev = 0
Self.errorRate = 0

-- Versioning
Self.CHANNEL_ALPHA = "alpha"
Self.CHANNEL_BETA = "beta"
Self.CHANNEL_STABLE = "stable"
Self.CHANNELS = {alpha = 1, beta = 2, stable = 3}

function Self:OnInitialize()
    self:ToggleDebug(SchweinDKPDebug or self.DEBUG)

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

---@param debug boolean
function Self:ToggleDebug(debug)
    if debug ~= nil then
        self.DEBUG = debug
    else
        self.DEBUG = not self.DEBUG
    end

    SchweinDKPDebug = self.DEBUG

    if self.DEBUG or self.db then
        self:Info("Debugging " .. (self.DEBUG and "en" or "dis") .. "abled")
    end
end



function Self:HandleChatCommand(msg)
    local args = Util.Tbl.New(self:GetArgs(msg, 10))
    args[11] = nil

    local cmd = tremove(args, 1)

    if cmd == "help" then
        GUI.Roster.Toggle()
    -- Toggle debug mode
    elseif cmd == "debug" then
        self:ToggleDebug()
        -- Export debug log
    elseif cmd == "log" then
        self:LogExport()
    end
end

---@param versionOrUnit string|number
function Self:GetVersion(versionOrUnit)
    local version = (not versionOrUnit or Unit.IsSelf(versionOrUnit)) and Self.VERSION
        or type(versionOrUnit) == "string" and self.versions[Unit.Name(versionOrUnit)]
        or versionOrUnit

    local n = tonumber(version)
    if n then
        return floor(n), Self.CHANNEL_STABLE, Util.Num.Round((n - floor(n)) * 100), 0
    elseif type(version) == "string" then
        local major, channel, minor, revision = version:match("([%d%.]+)-(%a+)(%d+)-?(%d*)")
        if major and channel and minor then
            return tonumber(major), channel, tonumber(minor), tonumber(revision) or 0
        end
    end
end

-------------------------------------------------------
--                      Logging                      --
-------------------------------------------------------

-- Write to log and print if lvl is high enough
---@param line string
function Addon:Echo(lvl, line, ...)
    if lvl == Self.ECHO_DEBUG then
        for i=1, select("#", ...) do
            line = line .. (i == 1 and " - " or ", ") .. Util.Str.ToString((select(i, ...)))
        end
    else
        line = line:format(...)
    end

    self:Log(lvl, line)

    if not self.db or self.db.profile.messages.echo >= lvl then
        self:Print(line)
    end
end

-- Shortcuts for different log levels
function Self:Error(...) self:Echo(Self.ECHO_ERROR, ...) end
function Self:Info(...) self:Echo(Self.ECHO_INFO, ...) end
function Self:Verbose(...) self:Echo(Self.ECHO_VERBOSE, ...) end
function Self:Debug(...) self:Echo(Self.ECHO_DEBUG, ...) end

-- Add an entry to the debug log
function Self:Log(lvl, line)
    tinsert(self.log, ("[%.1f] %s: %s"):format(GetTime(), Self.ECHO_LEVELS[lvl or Self.ECHO_INFO], line or "-"))
    while #self.log > Self.LOG_MAX_ENTRIES do
        Util.Tbl.Shift(self.log)
    end
end

-- Export the debug log
function Self:LogExport(warned)
    if warned then
        local realm = GetRealmName()
        local _, name, _, _, lang, _, region = RI:GetRealmInfo(realm)    
        local txt = ("~ SchweinDKP ~ Version: %s ~ Date: %s ~ Locale: %s ~ Realm: %s-%s (%s) ~"):format(Self.VERSION or "?", date() or "?", GetLocale() or "?", region or "?", name or realm or "?", lang or "?")
        txt = txt .. "\n" .. Util.Tbl.Concat(self.log, "\n")

        GUI.ShowExportWindow("Export log", txt)
    else
        self:Print("Showing the log might freeze your screen for a few seconds, so hang in there!")
        self:ScheduleTimer(Self.LogExport, 0, self, true)
    end
end

