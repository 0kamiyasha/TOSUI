local TUI = unpack(TOSUI)

local tonumber = tonumber

TUI.title = C_AddOns.GetAddOnMetadata("TOSUI", "Title")
TUI.version = tonumber(C_AddOns.GetAddOnMetadata("TOSUI", "Version"))
TUI.myLocalizedClass, TUI.myclass = UnitClass("player")
TUI.myname = UnitName("player")

function TUI:Initialize()
    -- Tell EllesmereUI an external pack owns first-run install flow.
    if self:IsAddOnEnabled("EllesmereUI") and EllesmereUI and EllesmereUI.RegisterExternalInstaller then
        EllesmereUI.RegisterExternalInstaller(self.title or "TOSUI")
    end

    if self:IsAddOnEnabled("TOSQOL") then
        C_AddOns.DisableAddOn("TOSQOL")
    end

    if not self:IsAddOnEnabled("WagoUI") and self.db.global.profiles and not self.db.char.loaded and not InCombatLockdown() then
        StaticPopupDialogs["LoadProfiles"] = {
            text = "Do you wish to load your installed profiles onto this character?",
            button1 = "Yes",
            button2 = "No",
            OnAccept = function() self:LoadProfiles() end,
            OnCancel = function() self.db.char.loaded = true end
        }

        StaticPopup_Show("LoadProfiles")
    end
end
