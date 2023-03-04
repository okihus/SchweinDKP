---@type Addon
local Addon = select(2, ...)
local Util = Addon.Util
---@class Unit
local Self = Addon.Unit

Self.GROUP_RANK_LEADER = 2
Self.GROUP_RANK_ASSISTANT = 1


function Self.IsUnit(unit, otherUnit)
    return unit == otherUnit or Util.Str.IsSet(unit) and Util.Str.IsSet(otherUnit) and UnitIsUnit(unit, otherUnit)
end

function Self.IsSelf(unit)
    return Self.IsUnit(unit, "player")
end