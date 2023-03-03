local Addon = select(2, ...)
local RI = LibStub("LibRealmInfo")
local Util = Addon.Util

local Self = Addon.Locale

Self.DEFAULT = Util.Select(RI:GetCurrentRegion(), "KR", "koKR", "TW", "zhTW", "CN", "zhCN", "enUS")

Self.FALLBACK = "enUS"

-- Get language for the given realm
---@param realm string?
---@return string
function Self.GetRealmLanguage(realm)
    local lang = select(5, RI:GetRealmInfo(realm or GetRealmName())) or Self.DEFAULT
    return lang == "enGB" and "enUS" or lang
end

-- Get locale
---@param lang string
---@return table
function Self.GetLocale(lang)
    return Self[lang == true and GetLocale() or lang or Self.GetRealmLanguage()] or Self[Self.FALLBACK]
end

-- Meta table for chat message translations
Self.MT = {
    __index = function (table, key)
        return table == Self[Self.FALLBACK] and key or Self[Self.FALLBACK][key]
    end,
    __call = function (table, line, ...)
        return table[line]:format(...)
    end
}
