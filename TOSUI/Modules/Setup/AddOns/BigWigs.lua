local TUI = unpack(TOSUI)
local SE = TUI:GetModule("Setup")

local function ImportBigWigs(addon, resolution)
    local D = TUI:GetModule("Data")

    local profile = "bigwigs" .. (resolution or "")
    local data = D[profile]
    if type(data) ~= "table" or type(data[1]) ~= "string" or data[1] == "" then
        TUI:Print("BigWigs profile data is missing for this option.")
        return
    end

    BigWigsAPI.RegisterProfile(TUI.title, data[1], "TOS", function(callback)
        if not callback then

            return
        end

        BigWigsAPI.ImportBossOptions(TUI.title, data[2])

        SE.CompleteSetup(addon)

        TUI.db.char.loaded = true
        TUI.db.global.version = TUI.version
    end)
end

function SE.BigWigs(addon, import, resolution)
    if import then
        ImportBigWigs(addon, resolution)

        return
    end

    if not SE.IsProfileExisting(BigWigs3DB) then
        SE.RemoveFromDatabase(addon)

        return
    end

    BigWigsLoader.db:SetProfile("TOS")
end