local TUI = unpack(TOSUI)
local SE = TUI:GetModule("Setup")

local function IsLayoutExisting()
    local layouts = C_EditMode.GetLayouts()

    for i, v in ipairs(layouts.layouts) do
        if v.layoutName == "TOS" then

            return Enum.EditModePresetLayoutsMeta.NumValues + i
        end
    end
end

local function ImportBlizzard_EditMode(addon, resolution)
    local D = TUI:GetModule("Data")

    local layouts, info
    local layout = "blizzardeditmode" .. (resolution or "")

    layouts = C_EditMode.GetLayouts()

    for i = #layouts.layouts, 1, -1 do
        if layouts.layouts[i].layoutName == "TOS" then
            tremove(layouts.layouts, i)
        end
    end

    if #layouts.layouts >= 5 then
        if TOSUIInstallFrame then
            TOSUIInstallFrame.Desc3:SetText("|cffff0000Failed to install: maximum Edit Mode layouts already reached.|r")
        end

        return
    end

    if type(D[layout]) ~= "string" or D[layout] == "" then
        TUI:Print("Edit Mode profile data is missing for this option.")
        return
    end

    info = C_EditMode.ConvertStringToLayoutInfo(D[layout])
    info.layoutName = "TOS"
    info.layoutType = Enum.EditModeLayoutType.Account

    tinsert(layouts.layouts, info)
    C_EditMode.SaveLayouts(layouts)

    local newIndex = Enum.EditModePresetLayoutsMeta.NumValues + #layouts.layouts

    C_EditMode.OnLayoutAdded(newIndex, true, true)
    C_EditMode.SetAccountSetting(22, 0)

    SE.CompleteSetup(addon)

    TUI.db.char.loaded = true
    TUI.db.global.version = TUI.version
end

function SE.Blizzard_EditMode(addon, import, resolution)
    if import then
        ImportBlizzard_EditMode(addon, resolution)

        return
    end

    local layout = IsLayoutExisting()

    if not layout then
        SE.RemoveFromDatabase(addon)

        return
    end

    C_EditMode.SetActiveLayout(layout)
    C_EditMode.SetAccountSetting(0, 0)
end