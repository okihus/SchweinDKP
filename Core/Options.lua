---@type string
local Name = ...

---@type Addon
local Addon = select(2, ...)

---@type L
local L = LibStub("AceLocale-3.0"):GetLocale(Name)
local C = LibStub("AceConfig-3.0")
local CD = LibStub("AceConfigDialog-3.0")
local CR = LibStub("AceConfigRegistry-3.0")
local LDB = LibStub("LibDataBroker-1.1")
local LDBIcon = LibStub("LibDBIcon-1.0")

local GUI, Locale, Util = Addon.GUI, Addon.Locale, Addon.Util

---@class Options
local Self = Addon.Options

Self.DEFAULTS = {
    profile = {
        enabled = true,
        messages = {
            echo = Addon.ECHO_INFO
        }
    },
}

Self.WIDTH_HALF = 1.7

-- Custom options
Self.CAT_GENERAL = "GENERAL"
Self.CAT_MESSAGES = "MESSAGES"

Self.it = Util.Iter()
Self.registered = false
Self.frames = {}

function Self.Register()
    Self.registered = true

    C:RegisterOptionsTable(Name, Self.RegisterGeneral)
    Self.frames.General = CD:AddToBlizOptions(Name)

    -- Messages
    C:RegisterOptionsTable(Name .. " Messages", Self.RegisterMessages)
    Self.frames.Messages = CD:AddToBlizOptions(Name .. " Messages", L["OPT_MESSAGES"], Name)

    C:RegisterOptionsTable(Name .. " Profiles", LibStub("AceDBOptions-3.0"):GetOptionsTable(Addon.db))
    Self.frames.Profiles = CD:AddToBlizOptions(Name .. " Profiles", "Profiles", Name)
end

-- Show the options panel
function Self.Show(name)
    local panel = Self.frames[name or "General"]

    -- Have to call it twice because of a blizzard UI bug
    InterfaceOptionsFrame_OpenToCategory(panel)
    InterfaceOptionsFrame_OpenToCategory(panel)
end

-- Apply custom options to an options table
function Self.ApplyCustomOptions(cat, options)
    for _,entry in Self.CustomOptions:Iter() do
        if entry.cat == cat then
            local data = Util.Fn.Val(entry.options, cat, entry.path)
            data.order = data.order or Self.it()
            Util.Tbl.Set(options, entry.path, data)
        end
    end
end

function Self.RegisterGeneral()
    local it = Self.it

    local options = {
        name = Name,
        type = "group",
        args = {
            enable = {
                name = L['OPT_ENABLE'],
                desc = L['OPT_ENABLE_DESC'],
                type = "toggle",
                order = it(),
                set = function (_, val)
                    Addon.db.profile.enabled = val
                    Addon:Info(L[val and "ENABLED" or "DISABLED"])
                    Addon[val and "Enable" or "Disable"](Addon)
                end,
                get = function (_) return Addon.db.profile.enabled end,
                width = Self.WIDTH_HALF
            }
        }
    }

    Self.ApplyCustomOptions(Self.CAT_GENERAL, options.args)

    return options
end

function Self.RegisterMessages()
    local it = Self.it

    local options = {
        name = L["OPT_MESSAGES"],
        type = "group",
        childGroups = "tab",
        args = {
            echo = {
                name = L["OPT_ECHO"],
                desc = L["OPT_ECHO_DESC"],
                type = "select",
                order = it(),
                values = {
                    [Addon.ECHO_NONE] = L["OPT_ECHO_NONE"],
                    [Addon.ECHO_ERROR] = L["OPT_ECHO_ERROR"],
                    [Addon.ECHO_INFO] = L["OPT_ECHO_INFO"],
                    [Addon.ECHO_VERBOSE] = L["OPT_ECHO_VERBOSE"],
                    [Addon.ECHO_DEBUG] = L["OPT_ECHO_DEBUG"]
                },
                set = function (info, val) Addon.db.profile.messages.echo = val end,
                get = function () return Addon.db.profile.echo end
            }
        }
    }

    Self.ApplyCustomOptions(Self.CAT_MESSAGES, options.args)

    return options
end

-------------------------------------------------------
--                   Minimap Icon                    --
-------------------------------------------------------

function Self.RegisterMinimapIcon()
    local plugin = LDB:NewDataObject(Name, {
        type = "data source",
        text = Name,
        icon = "Interface\\Buttons\\UI-GroupLoot-Dice-Up"
    })

    -- OnClick
    plugin.OnClick = function (_, btn)
        if btn == "RightButton" then
            Self.Show()
        else
            GUI.Roster.Toggle()
        end
    end

    -- OnTooltip
    plugin.OnTooltipShow = function (ToolTip)
        ToolTip:AddLine(Name)
        ToolTip:AddLine(L["TIP_MINIMAP_ICON"], 1, 1, 1)
    end

    -- Icon
    if not SchweinDKPIconDB then SchweinDKPIconDB = {} end
    LDBIcon:Register(Name, plugin, SchweinDKPIconDB)
end