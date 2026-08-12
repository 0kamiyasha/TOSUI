local TUI = unpack(TOSUI)
local SE = TUI:GetModule("Setup")

local function LoadData()
    if not TUI:IsAddOnEnabled("TOSUI_Data") then
        C_AddOns.EnableAddOn("TOSUI_Data")
    end

    C_AddOns.LoadAddOn("TOSUI_Data")
end

-- Shared resolution slots. Installer pages only surface labels when D[base..suffix]
-- already contains a non-empty packaged string.
SE.ResolutionCatalog = {
    { suffix = "",      label = "1440p" },
    { suffix = "1080p", label = "1080p" },
    { suffix = "4k",    label = "4K" },
    { suffix = "uw",    label = "Ultrawide" },
}

function SE.HasPackagedString(key)
    LoadData()

    local D = TUI:GetModule("Data")
    local data = D and D[key]
    if type(data) == "string" then
        return data ~= ""
    end
    if type(data) == "table" then
        return type(data[1]) == "string" and data[1] ~= ""
    end

    return false
end

function SE.GetAvailableResolutionOptions(baseKey)
    local options = {}

    for _, entry in ipairs(SE.ResolutionCatalog) do
        local key = baseKey .. entry.suffix
        if SE.HasPackagedString(key) then
            options[#options + 1] = {
                key = key,
                suffix = entry.suffix,
                label = entry.label,
            }
        end
    end

    return options
end

function SE:Setup(addon, ...)
    local setup = self[addon]

    LoadData()
    setup(addon, ...)
end

local SETUP_DISPLAY_NAMES = {
    Blizzard_CooldownViewer = "Class Layout",
    Blizzard_EditMode = "Edit Mode",
}

function SE.CompleteSetup(addon)
    local displayName = (addon and SETUP_DISPLAY_NAMES[addon]) or addon or "Profile"
    local successMessage = displayName .. " imported"

    if _G.TOSUIInstaller and TOSUIInstaller.ShowSetupSuccess then
        TOSUIInstaller:ShowSetupSuccess(successMessage)
    elseif TOSUIInstallStepComplete then
        if TOSUIInstallStepComplete:IsShown() then
            TOSUIInstallStepComplete:Hide()
        end

        TOSUIInstallStepComplete.message = "Success"
        TOSUIInstallStepComplete:Show()
    else
        TUI:Print(successMessage .. " successfully.")
    end

    if not addon then
        return
    end

    TUI.db.global.profiles = TUI.db.global.profiles or {}
    TUI.db.global.profiles[addon] = TUI.version

    if _G.TOSUIInstaller then
        if TOSUIInstaller.MarkAsRecentlyInstalled then
            TOSUIInstaller:MarkAsRecentlyInstalled(addon)
        end
        if TOSUIInstaller.RefreshAllStepButtons then
            TOSUIInstaller:RefreshAllStepButtons()
        end
    end
end

function SE.IsProfileExisting(table)
    local db = LibStub("AceDB-3.0"):New(table)
    local profiles = db:GetProfiles()

    for i = 1, #profiles do
        if profiles[i] == "TOS" then

            return true
        end
    end
end

function SE.RemoveFromDatabase(addon)
    TUI.db.global.profiles[addon] = nil

    if TUI.db.global.profiles and not next(TUI.db.global.profiles) then
        for k in pairs(TUI.db.char) do
            k = nil
        end

        TUI.db.global.profiles = nil
    end
end

function SE.SetFrameStrata(frame, strata)
    frame:SetFrameStrata(strata)
end