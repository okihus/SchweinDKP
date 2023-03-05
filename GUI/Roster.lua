local Name = ...

local Addon = select(2, ...)

local L = LibStub("AceLocale-3.0"):GetLocale(Name)
local AceGUI = LibStub("AceGUI-3.0")

local GUI, Util, Options = Addon.GUI, Addon.Util, Addon.Options

local Self = GUI.Roster

Self.frames = {}

Self.buttons = {}
Self.open = {}
Self.status = {width = 700, height = 300}
Self.confirm = {roll = nil, unit = nil}

---@type Texture
local HIGHLIGHT = UIParent:CreateTexture(nil, "OVERLAY")
HIGHLIGHT:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-ItemButton-Highlight")
HIGHLIGHT:SetTexCoord(.1, .6, .1, .7)
HIGHLIGHT:SetBlendMode("ADD")

function Self.Show()
    if Self.frames.window then
        Self.frames.window.frame:Show()
    else
        Addon:Debug("GUI.Roster.Show")
        local f

        local window = GUI("Window")
            .SetLayout(nil)
            .SetFrameStrata("MEDIUM")
            .SetTitle("Schwein DKP")
            .SetResizeBounds(360, 120)
            .SetPoint("CENTER")
            .SetStatusTable(Self.status)
            .SetCallback("OnClose", function (self)
                Self.status.width = self.frame:GetWidth()
                Self.status.height = self.frame:GetHeight()
                self:Release()
                GUI(HIGHLIGHT).SetParent(UIParent).Hide()
                Util.Tbl.Wipe(Self.frames, Self.buttons, Self.open, Self.confirm)
            end)()

        -- Darker background
        GUI(select(2, window.frame:GetRegions()))
            .SetColorTexture(0, 0, 0, 1)
            .SetVertexColor(0, 0, 0, .8)
        local OnRelease = window.OnRelease
        window.OnRelease = function (self, ...)
            GUI(select(2, self.frame:GetRegions()))
                .SetTexture([[Interface\Tooltips\UI-Tooltip-Background]])
                .SetVertexColor(0, 0, 0, .75)
            self.OnRelease = OnRelease
            self:OnRelease(...)
        end

        Self.frames.window = window

        -- BUTTONS

        -- Options button
        f = GUI("Icon")
            .SetImage("Interface\\Buttons\\UI-OptionsButton")
            .SetImageSize(14, 14).SetHeight(16).SetWidth(16)
            .SetCallback("OnClick", function (self)
                Options.Show()
                GameTooltip:Hide()
            end)
            .SetCallback("OnEnter", GUI.TooltipText)
            .SetCallback("OnLeave", GUI.TooltipHide)
            .SetUserData("text", OPTIONS)
            .AddTo(window)()
        f.OnRelease = GUI.ResetIcon
        f.image:SetPoint("TOP", 0, -1)
        f.frame:SetParent(window.frame)
        f.frame:SetPoint("TOPRIGHT", window.closebutton, "TOPLEFT", -8, -8)
        f.frame:SetFrameStrata("HIGH")
        f.frame:Show()

        Self.buttons.options = f

        Self.Update()
    end
end

-- Check if the frame is currently being shown
---@return boolean
function Self.IsShown()
    return Self.frames.window and Self.frames.window.frame:IsShown()
end

-- Hide the frame
function Self.Hide()
    if Self:IsShown() then Self.frames.window.frame:Hide() end
end

-- Toggle the frame
function Self.Toggle()
    if Self:IsShown() then Self.Hide() else Self.Show() end
end


function Self.Update()
    if Self.frames.window then

        Self.DoLayout(false, true)
    end
end

function Self.DoLayout(now, next, frame)
    frame = frame

    if frame then
        if now then
            frame:DoLayout()
        end
        if next then
            Self:ScheduleTimer(frame.DoLayout, 0, frame)
        end
    end
end

