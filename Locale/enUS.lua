local Name = ...

local Addon = select(2, ...)
local Locale = Addon.Locale
local lang = "enUS"

local L = {lang = lang}
setmetatable(L, Locale.MT)
Locale[lang] = L


local L = LibStub("AceLocale-3.0"):NewLocale(Name, lang, lang == Locale.FALLBACK)
if not L then return end

L["ENABLED"] = "Enabled"
L["DISABLED"] = "Disabled"

-- Options
L["OPT_ENABLE"] = "Enable"
L["OPT_ENABLE_DESC"] = "Enable or disable this addon"

-- Options - Messages
L["OPT_ECHO"] = "Chat information"
L["OPT_ECHO_DESC"] = "How much information do you want to see from the addon in chat?"

L["OPT_ECHO_ERROR"] = "Error"
L["OPT_ECHO_INFO"] = "Info"
L["OPT_ECHO_NONE"] = "None"
L["OPT_ECHO_VERBOSE"] = "Verbose"
L["OPT_ECHO_DEBUG"] = "Debug"

L["OPT_MESSAGES"] = "Messages"

L["TIP_MINIMAP_ICON"] = "|cffffff78Left-Click:|r Toggle roster window"

