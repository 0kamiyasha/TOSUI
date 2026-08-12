local TUI = unpack(TOSUI)
local SE = TUI:GetModule("Setup")

function SE.MRT(addon, import, resolution)
    local D = TUI:GetModule("Data")

    local profile = "mrt" .. (resolution or "")

    if import then
        if type(D[profile]) ~= "string" or D[profile] == "" then
            TUI:Print("MRT profile data is missing for this option.")
            return
        end

        MRT_API:ImportProfile(D[profile], "TOS")

        SE.CompleteSetup(addon)

        TUI.db.char.loaded = true
        TUI.db.global.version = TUI.version

        return
    end

    if not (VMRT.Profile == "TOS" or VMRT.Profiles.TOS) then
        SE.RemoveFromDatabase(addon)

        return
    end

    MRT_API:SetProfile("TOS")
end