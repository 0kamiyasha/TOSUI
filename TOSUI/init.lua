local _G = _G

local C_AddOns_GetAddOnEnableState = C_AddOns.GetAddOnEnableState

local AceAddon = _G.LibStub("AceAddon-3.0")

local AddOnName, Engine = ...
local TUI = AceAddon:NewAddon(AddOnName, "AceConsole-3.0", "AceEvent-3.0")

Engine[1] = TUI
_G.TOSUI = Engine

TUI.Data = TUI:NewModule("Data")
TUI.Installer = TUI:NewModule("Installer")
TUI.Setup = TUI:NewModule("Setup", "AceHook-3.0")

do
    function TUI:AddonCompartmentFunc()
        TUI:RunInstaller()
    end

    _G.TOSUI_AddonCompartmentFunc = TUI.AddonCompartmentFunc
end

function TUI:GetAddOnEnableState(addon, character)
    return C_AddOns_GetAddOnEnableState(addon, character)
end

function TUI:IsAddOnEnabled(addon)
    return TUI:GetAddOnEnableState(addon, TUI.myname) == 2
end

function TUI:OnEnable()
    TUI:Initialize()
end

function TUI:OnInitialize()
    self.db = _G.LibStub("AceDB-3.0"):New("TOSUIDB")

    if self.db.global.version and self.db.global.version <= 20260811 then
        self.db:ResetDB()
    end

    self:RegisterChatCommand("tui", "HandleChatCommand")
    self:RegisterChatCommand("tos", "HandleChatCommand")
    self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
end