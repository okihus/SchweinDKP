local Addon = select(2, ...)

local Self = Addon.Util
setmetatable(Self, LibStub:GetLibrary("LibUtil"))

---@type Registrar
Self.Registrar = {}