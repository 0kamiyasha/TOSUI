local TUI = unpack(TOSUI)
local SE = TUI:GetModule("Setup")

local chatCommands = {}

function TUI:RunInstaller()
    local I = self:GetModule("Installer")

    if InCombatLockdown() then
        self:Print("Leave combat to open the installer.")
        return
    end

    if not C_AddOns.DoesAddOnExist("TOSUI_Data") then
        self:Print("TOSUI_Data is missing. Install it next to TOSUI.")
        return
    end

    I:Queue(I.installer)
end

function TUI:LoadProfiles()
    for k in pairs(self.db.global.profiles) do
        if self:IsAddOnEnabled(k) and not (k == "Blizzard_CooldownViewer" and C_CVar.GetCVar("cooldownViewerEnabled") == "0") then
            SE:Setup(k)
        end
    end

    self.db.char.loaded = true

    ReloadUI()
end

function chatCommands.install()
    TUI:RunInstaller()
end

function TUI:HandleChatCommand(input)
    input = strtrim(strlower(input or ""))

    -- Bare /tui or /tos (and /tui install) all open the installer.
    if input == "" or input == "install" then
        self:RunInstaller()
        return
    end

    local command = chatCommands[input]
    if not command then
        self:Print("Usage: /tui, /tos, or /tui install")
        return
    end

    command()
end

function TUI:ACTIVE_TALENT_GROUP_CHANGED()
    if not self.db.global.profiles or not self.db.global.profiles.Blizzard_EditMode or not self.db.char.loaded or InCombatLockdown() then
        return
    end

    SE:Setup("Blizzard_EditMode")
end