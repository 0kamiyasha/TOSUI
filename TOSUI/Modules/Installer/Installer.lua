--[[--------------------------------------------------------------------
    Installer module — wires the custom TOSUIInstallerFrame.

    Pages.lua sets I.installer = { Pages, StepTitles, ... } during TOC load.
    Do NOT clear I.installer in OnInitialize — Ace runs that after page scripts
    and would wipe the page table (silent /tui install).
--------------------------------------------------------------------]]--

local TUI = unpack(TOSUI)
local I = TUI:GetModule("Installer")

function I:OnEnable()
    if _G.TOSUIInstaller then
        self.InstallerFrame = _G.TOSUIInstaller
    end
end

function I:Queue(installerTable)
    local frame = self.InstallerFrame or _G.TOSUIInstaller
    if not frame or not frame.Show then
        TUI:Print("Installer frame is not available. Check for Lua errors.")
        return
    end

    if installerTable then
        self.installer = installerTable
    end

    if not self.installer then
        TUI:Print("Installer pages are not loaded for this game version.")
        return
    end

    frame:Show(self.installer)
end
