local TUI = unpack(TOSUI)
local SE = TUI:GetModule("Setup")

-- Catalog of supported Ellesmere slots. Installer only shows entries that have
-- real packaged strings in TOSUI_Data (D[key][1] is a non-empty string).
SE.EllesmereCatalog = {
    { key = "ellesmereui",            label = "Default 1440p" },
    { key = "ellesmereui1080p",       label = "Default 1080p" },
    { key = "ellesmereui4k",          label = "Default 4K" },
    { key = "ellesmereuiuw",          label = "Default Ultrawide" },
    { key = "ellesmereuidps",         label = "DPS 1440p" },
    { key = "ellesmereuidps1080p",    label = "DPS 1080p" },
    { key = "ellesmereuidps4k",       label = "DPS 4K" },
    { key = "ellesmereuidpsuw",       label = "DPS Ultrawide" },
    { key = "ellesmereuihealer",      label = "Healer 1440p" },
    { key = "ellesmereuihealer1080p", label = "Healer 1080p" },
    { key = "ellesmereuihealer4k",    label = "Healer 4K" },
    { key = "ellesmereuihealeruw",    label = "Healer Ultrawide" },
    { key = "ellesmereuitank",        label = "Tank 1440p" },
    { key = "ellesmereuitank1080p",   label = "Tank 1080p" },
    { key = "ellesmereuitank4k",      label = "Tank 4K" },
    { key = "ellesmereuitankuw",      label = "Tank Ultrawide" },
}

function SE.HasEllesmereProfile(key)
    return SE.HasPackagedString(key)
end

function SE.GetAvailableEllesmereOptions()
    local options = {}
    for _, entry in ipairs(SE.EllesmereCatalog) do
        if SE.HasEllesmereProfile(entry.key) then
            options[#options + 1] = {
                key = entry.key,
                label = entry.label,
            }
        end
    end
    return options
end

local function ResolveProfileKey(profileKey)
    if not profileKey or profileKey == "" then
        return "ellesmereui"
    end

    -- Legacy resolution-only args from older pages / LoadProfiles callers.
    if profileKey == "1080p" or profileKey == "4k" or profileKey == "uw" then
        return "ellesmereui" .. profileKey
    end

    return profileKey
end

-- Keep the TOS installer as a single-window experience: decode the packaged
-- Ellesmere string, let the user pick modules (all checked by default), then
-- call EllesmereUI.ImportProfile with a filtered payload — same merge rules as
-- Ellesmere's own Profiles import UI, without leaving TOSUIInstallerFrame.
function SE.EllesmereUI(_, profileKey)
    local D = TUI:GetModule("Data")
    local key = ResolveProfileKey(profileKey)
    local data = D[key]

    if not data or type(data[1]) ~= "string" or data[1] == "" then
        TUI:Print("EllesmereUI profile data is missing for this option.")
        return
    end

    if not _G.EllesmereUI then
        TUI:Print("Enable EllesmereUI to import this profile.")
        return
    end

    if InCombatLockdown() then
        TUI:Print("Leave combat to import EllesmereUI.")
        return
    end

    local installer = _G.TOSUIInstaller
    if not installer or not installer.ShowEllesmereImportPicker then
        TUI:Print("Installer module picker is unavailable.")
        return
    end

    installer:ShowEllesmereImportPicker({
        importString = data[1],
        profileName = "TOS",
        scale = data[2],
        onDone = function(accepted)
            if not accepted then
                return
            end

            SE.CompleteSetup("EllesmereUI")
            TUI.db.char.loaded = true
            TUI.db.global.version = TUI.version
        end,
    })
end
