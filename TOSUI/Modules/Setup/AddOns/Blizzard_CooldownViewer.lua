local TUI = unpack(TOSUI)
local SE = TUI:GetModule("Setup")

local function GetClassKey()
    local _, class = UnitClass("player")

    return class and strlower(class)
end

local function GetSpecName()
    local specIndex = GetSpecialization()

    if specIndex then
        local _, specName = GetSpecializationInfo(specIndex)

        return specName
    end
end

local function GetLayoutName(layout)
    return layout and (layout.layoutName or layout.name) or nil
end

local function CompactLayouts(layoutManager)
    local newLayouts = {}

    for _, layout in pairs(layoutManager.layouts) do
        if layout then
            newLayouts[#newLayouts + 1] = layout
            layout.layoutID = #newLayouts
        end
    end

    for k in pairs(layoutManager.layouts) do
        layoutManager.layouts[k] = nil
    end

    for i, layout in ipairs(newLayouts) do
        layoutManager.layouts[i] = layout
    end
end

-- Remove any layout whose name is in `names`, except IDs listed in `keepIDs`.
local function RemoveLayoutsByName(layoutManager, names, keepIDs)
    if not names or not next(names) then
        return 0
    end

    local toRemove = {}

    for layoutID, layout in pairs(layoutManager.layouts) do
        local layoutName = GetLayoutName(layout)

        if layoutName and names[layoutName] and not (keepIDs and keepIDs[layoutID]) then
            toRemove[#toRemove + 1] = layoutID
        end
    end

    if #toRemove == 0 then
        return 0
    end

    table.sort(toRemove, function(a, b) return a > b end)

    for _, layoutID in ipairs(toRemove) do
        layoutManager.layouts[layoutID] = nil
    end

    CompactLayouts(layoutManager)

    return #toRemove
end

local function FindLayoutIDByName(layoutManager, layoutName)
    if not layoutName then
        return nil
    end

    for layoutID, layout in pairs(layoutManager.layouts) do
        if GetLayoutName(layout) == layoutName then
            return layoutID
        end
    end
end

local function ImportClassCooldowns()
    local D = TUI:GetModule("Data")

    if InCombatLockdown() then return false end
    if not CooldownViewerSettings then return false end

    local classData = D[GetClassKey()]
    if not classData then return false end

    local layoutManager = CooldownViewerSettings:GetLayoutManager()
    if not layoutManager then return false end

    -- Import first so we can read the real layout names from the payload
    local ok, layoutIDs = pcall(layoutManager.CreateLayoutsFromSerializedData, layoutManager, classData)
    if not ok or not layoutIDs or #layoutIDs == 0 then return false end

    local keepIDs = {}
    local importedNames = {}
    local preferredName
    local specName = GetSpecName()

    for _, layoutID in ipairs(layoutIDs) do
        keepIDs[layoutID] = true

        local layout = layoutManager.layouts[layoutID]
        local layoutName = GetLayoutName(layout)

        if layoutName then
            importedNames[layoutName] = true

            if specName and layoutName:find(specName, 1, true) then
                preferredName = layoutName
            end
        end
    end

    -- Drop prior copies with the same names; keep the layouts we just imported.
    RemoveLayoutsByName(layoutManager, importedNames, keepIDs)

    local activeLayoutID = FindLayoutIDByName(layoutManager, preferredName)

    if not activeLayoutID then
        for layoutName in pairs(importedNames) do
            activeLayoutID = FindLayoutIDByName(layoutManager, layoutName)
            if activeLayoutID then
                break
            end
        end
    end

    if activeLayoutID then
        layoutManager:SetActiveLayoutByID(activeLayoutID)
    end

    layoutManager:SaveLayouts()

    if StaticPopup1Button2Text and StaticPopup1Button2Text:GetText() == "Ignore" then
        StaticPopup1Button2:Click()
    end

    return true
end

function SE.Blizzard_CooldownViewer(addon, class)
    local success = ImportClassCooldowns()

    if success then
        SE.CompleteSetup(addon)
    end
end

function SE.GetPlayerClassDisplayName()
    local _, className = UnitClass("player")

    return LOCALIZED_CLASS_NAMES_MALE[className] or className
end
