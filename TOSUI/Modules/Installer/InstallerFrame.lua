local TUI = unpack(TOSUI)
local I = TUI:GetModule("Installer")

local TOSUIInstaller = {}
I.InstallerFrame = TOSUIInstaller
_G.TOSUIInstaller = TOSUIInstaller

local FRAME_WIDTH = 800
local FRAME_HEIGHT = 600
local STEP_PANEL_WIDTH = 200
local CONTENT_PANEL_WIDTH = FRAME_WIDTH - STEP_PANEL_WIDTH

function TOSUIInstaller:CreateModernButton(parent, text, width, height, buttonType)
    local btn = _G.CreateFrame("Button", nil, parent, "BackdropTemplate")
    btn:SetSize(width or 120, height or 32)

    btn:SetBackdrop({
        bgFile = "Interface\\AddOns\\TOSUI\\Media\\Textures\\UI-Background-Rock",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 4,
        insets = { left = 1, right = 1, top = 1, bottom = 1 }
    })

    if buttonType == "class" then
        btn:SetBackdropColor(0.10, 0.08, 0.14, 0.95)
        btn:SetBackdropBorderColor(0, 0, 0, 0.8)

        local fontString = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        fontString:SetPoint("CENTER")
        fontString:SetText(text or "Button")
        fontString:SetTextColor(0.9, 0.9, 0.9, 1)
        btn:SetFontString(fontString)

        btn:SetScript("OnEnter", function()
            btn:SetBackdropColor(0.22, 0.16, 0.32, 0.95)
            btn:SetBackdropBorderColor(0, 0, 0, 1)
            fontString:SetTextColor(1, 1, 1, 1)
        end)

        btn:SetScript("OnLeave", function()
            btn:SetBackdropColor(0.10, 0.08, 0.14, 0.95)
            btn:SetBackdropBorderColor(0, 0, 0, 0.8)
            fontString:SetTextColor(0.9, 0.9, 0.9, 1)
        end)
    else
        btn:SetBackdropColor(0.14, 0.10, 0.22, 0.95)
        btn:SetBackdropBorderColor(0, 0, 0, 0.8)

        local fontString = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        fontString:SetPoint("CENTER")
        fontString:SetText(text or "Button")
        fontString:SetTextColor(0.9, 0.9, 0.9, 1)
        btn:SetFontString(fontString)

        btn:SetScript("OnEnter", function()
            btn:SetBackdropColor(0.28, 0.18, 0.42, 0.95)
            btn:SetBackdropBorderColor(0, 0, 0, 1)
            fontString:SetTextColor(1, 1, 1, 1)
        end)

        btn:SetScript("OnLeave", function()
            btn:SetBackdropColor(0.14, 0.10, 0.22, 0.95)
            btn:SetBackdropBorderColor(0, 0, 0, 0.8)
            fontString:SetTextColor(0.9, 0.9, 0.9, 1)
        end)
    end

    return btn
end

function TOSUIInstaller:CreateModernDropdown(parent, width, height)
    local dropdown = _G.CreateFrame("Frame", nil, parent, "BackdropTemplate")
    dropdown:SetSize(width or 200, height or 32)

    dropdown:SetBackdrop({
        bgFile = "Interface\\AddOns\\TOSUI\\Media\\Textures\\UI-Background-Rock",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 4,
        insets = { left = 1, right = 1, top = 1, bottom = 1 }
    })
    dropdown:SetBackdropColor(0.14, 0.10, 0.22, 0.95)
    dropdown:SetBackdropBorderColor(0, 0, 0, 0.8)

    local dropdownText = dropdown:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    dropdownText:SetPoint("LEFT", dropdown, "LEFT", 10, 0)
    dropdownText:SetText("Select an option...")
    dropdownText:SetTextColor(0.9, 0.9, 0.9, 1)

    local arrow = dropdown:CreateTexture(nil, "OVERLAY")
    arrow:SetSize(12, 12)
    arrow:SetPoint("RIGHT", dropdown, "RIGHT", -10, 0)
    arrow:SetTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up")

    local menu = _G.CreateFrame("Frame", nil, dropdown, "BackdropTemplate")
    menu:SetFrameStrata("FULLSCREEN_DIALOG")
    menu:SetBackdrop({
        bgFile = "Interface\\AddOns\\TOSUI\\Media\\Textures\\UI-Background-Rock",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 4,
        insets = { left = 1, right = 1, top = 1, bottom = 1 }
    })
    menu:SetBackdropColor(0.14, 0.10, 0.22, 0.95)
    menu:SetBackdropBorderColor(0, 0, 0, 0.8)
    menu:SetPoint("TOPLEFT", dropdown, "BOTTOMLEFT", 0, -2)
    menu:SetWidth(width or 200)
    menu:Hide()

    local scrollFrame = _G.CreateFrame("ScrollFrame", nil, menu)
    scrollFrame:SetPoint("TOPLEFT", menu, "TOPLEFT", 8, -8)
    scrollFrame:SetPoint("BOTTOMRIGHT", menu, "BOTTOMRIGHT", -28, 8) 

    local scrollContent = _G.CreateFrame("Frame", nil, scrollFrame)
    scrollContent:SetSize(1, 1) 
    scrollFrame:SetScrollChild(scrollContent)

    local scrollBar = _G.CreateFrame("Slider", nil, menu, "BackdropTemplate")
    scrollBar:SetPoint("TOPRIGHT", menu, "TOPRIGHT", -8, -8)
    scrollBar:SetPoint("BOTTOMRIGHT", menu, "BOTTOMRIGHT", -8, 8)
    scrollBar:SetWidth(16)
    scrollBar:SetOrientation("VERTICAL")
    scrollBar:SetMinMaxValues(0, 100)
    scrollBar:SetValue(0)
    scrollBar:Hide() 

    scrollBar:SetBackdrop({
        bgFile = "Interface\\AddOns\\TOSUI\\Media\\Textures\\UI-Background-Rock",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 4,
        insets = { left = 1, right = 1, top = 1, bottom = 1 }
    })
    scrollBar:SetBackdropColor(0.08, 0.06, 0.12, 0.8)
    scrollBar:SetBackdropBorderColor(0, 0, 0, 0.6)

    local thumb = scrollBar:CreateTexture(nil, "OVERLAY")
    thumb:SetTexture("Interface\\Buttons\\WHITE8X8")
    thumb:SetVertexColor(1.0, 0.80, 0.15, 0.9) 
    scrollBar:SetThumbTexture(thumb)

    scrollBar:SetScript("OnValueChanged", function(_, value)
        local maxScroll = scrollContent:GetHeight() - scrollFrame:GetHeight()
        if maxScroll > 0 then
            scrollFrame:SetVerticalScroll(value * maxScroll / 100)
        end
    end)

    menu:SetScript("OnMouseWheel", function(_, delta)
        if scrollBar:IsShown() then
            local currentValue = scrollBar:GetValue()
            local newValue = math.max(0, math.min(100, currentValue - delta * 10))
            scrollBar:SetValue(newValue)
        end
    end)
    menu:EnableMouseWheel(true)

    dropdown.menu = menu
    dropdown.scrollFrame = scrollFrame
    dropdown.scrollContent = scrollContent
    dropdown.scrollBar = scrollBar
    dropdown.text = dropdownText
    dropdown.arrow = arrow
    dropdown.options = {}
    dropdown.selectedIndex = nil
    dropdown.selectedOption = nil
    dropdown.maxVisibleItems = 8 

    dropdown:SetScript("OnMouseDown", function()
        if menu:IsShown() then
            menu:Hide()
        else
            dropdown:ShowMenu()
        end
    end)

    dropdown:SetScript("OnHide", function()
        menu:Hide()
    end)

    dropdown:SetScript("OnEnter", function()
        dropdown:SetBackdropColor(0.28, 0.18, 0.42, 0.95)
        dropdown:SetBackdropBorderColor(0, 0, 0, 1)
        dropdownText:SetTextColor(1, 1, 1, 1)
    end)

    dropdown:SetScript("OnLeave", function()
        dropdown:SetBackdropColor(0.14, 0.10, 0.22, 0.95)
        dropdown:SetBackdropBorderColor(0, 0, 0, 0.8)
        dropdownText:SetTextColor(0.9, 0.9, 0.9, 1)
    end)

    function dropdown:AddOption(optionText, value, onClick)
        local option = {
            text = optionText,
            value = value,
            onClick = onClick
        }
        table.insert(self.options, option)
        self:UpdateMenu()
    end

    function dropdown:UpdateMenu()

        for _, child in ipairs({self.scrollContent:GetChildren()}) do
            child:Hide()
            child:SetParent(nil)
        end

        local itemHeight = 25
        local numItems = #self.options
        local maxHeight = self.maxVisibleItems * itemHeight
        local actualHeight = math.min(numItems * itemHeight, maxHeight)
        local contentHeight = numItems * itemHeight

        self.menu:SetHeight(actualHeight + 16) 

        self.scrollContent:SetHeight(math.max(contentHeight, actualHeight))
        self.scrollContent:SetWidth(self.scrollFrame:GetWidth())

        if contentHeight > actualHeight then
            self.scrollBar:Show()
            self.scrollFrame:SetPoint("BOTTOMRIGHT", self.menu, "BOTTOMRIGHT", -28, 8)
        else
            self.scrollBar:Hide()
            self.scrollFrame:SetPoint("BOTTOMRIGHT", self.menu, "BOTTOMRIGHT", -8, 8)
        end

        self.scrollBar:SetValue(0)
        self.scrollFrame:SetVerticalScroll(0)

        for i, option in ipairs(self.options) do
            local item = _G.CreateFrame("Button", nil, self.scrollContent, "BackdropTemplate")
            item:SetSize(self.scrollContent:GetWidth() - 8, itemHeight - 2)
            item:SetPoint("TOPLEFT", self.scrollContent, "TOPLEFT", 4, -(i-1) * itemHeight - 2)

            item:SetBackdrop({
                bgFile = "Interface\\Buttons\\WHITE8X8",
                edgeFile = nil,
                tile = false,
                tileSize = 0,
                edgeSize = 0,
                insets = { left = 0, right = 0, top = 0, bottom = 0 }
            })
            item:SetBackdropColor(0, 0, 0, 0)

            local itemText = item:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            itemText:SetPoint("LEFT", item, "LEFT", 8, 0)
            itemText:SetText(option.text)
            itemText:SetTextColor(0.9, 0.9, 0.9, 1)

            item:SetScript("OnEnter", function()
                item:SetBackdropColor(0.3, 0.3, 0.3, 0.5)
                itemText:SetTextColor(1, 1, 1, 1)
            end)

            item:SetScript("OnLeave", function()
                item:SetBackdropColor(0, 0, 0, 0)
                itemText:SetTextColor(0.9, 0.9, 0.9, 1)
            end)

            item:SetScript("OnClick", function()
                self.selectedIndex = i
                self.selectedOption = option
                self.text:SetText(option.text)
                self.menu:Hide()
                if option.onClick then
                    option.onClick(option.value, option.text)
                end
            end)
        end
    end

    function dropdown:ShowMenu()
        if #self.options > 0 then
            self:UpdateMenu()

            local screenHeight = _G.GetScreenHeight()
            local dropdownBottom = dropdown:GetBottom()
            local dropdownTop = dropdown:GetTop()
            local menuHeight = self.menu:GetHeight()

            if dropdownBottom - menuHeight > 0 then

                self.menu:ClearAllPoints()
                self.menu:SetPoint("TOPLEFT", dropdown, "BOTTOMLEFT", 0, -2)
            else

                self.menu:ClearAllPoints()
                self.menu:SetPoint("BOTTOMLEFT", dropdown, "TOPLEFT", 0, 2)
            end

            self.menu:Show()
        end
    end

    function dropdown:ClearOptions()
        self.options = {}
        self.selectedIndex = nil
        self.selectedOption = nil
        self.text:SetText("Select an option...")
        self:UpdateMenu()
    end

    function dropdown:GetSelectedValue()
        if self.selectedOption then
            return self.selectedOption.value
        end
        return nil
    end

    function dropdown:GetSelectedText()
        if self.selectedOption then
            return self.selectedOption.text
        end
        return nil
    end

    return dropdown
end

function TOSUIInstaller:CountRecentlyInstalled()
    if not self.recentlyInstalled then return 0 end
    local count = 0
    for _ in pairs(self.recentlyInstalled) do
        count = count + 1
    end
    return count
end

local STATUS_COLORS = {
    uptodate = {
        bg = {0.05, 0.35, 0.08, 0.95},
        border = {0.20, 0.90, 0.30, 1},
        text = {0.40, 1.00, 0.45, 1},
        bgSel = {0.08, 0.45, 0.12, 0.98},
        borderSel = {0.35, 1.00, 0.45, 1},
    },
    outdated = {
        bg = {0.40, 0.05, 0.05, 0.95},
        border = {0.95, 0.20, 0.20, 1},
        text = {1.00, 0.35, 0.35, 1},
        bgSel = {0.50, 0.08, 0.08, 0.98},
        borderSel = {1.00, 0.35, 0.35, 1},
    },
    notinstalled = {
        bg = {0.12, 0.12, 0.14, 0.95},
        border = {0.45, 0.45, 0.50, 1},
        text = {0.85, 0.85, 0.88, 1},
        bgSel = {0.18, 0.16, 0.24, 0.98},
        borderSel = {0.70, 0.55, 1.00, 1},
    },
    default = {
        bg = {0.08, 0.07, 0.10, 0.90},
        border = {0.30, 0.30, 0.35, 1},
        text = {0.90, 0.90, 0.92, 1},
        bgSel = {0.14, 0.10, 0.22, 0.98},
        borderSel = {0.70, 0.55, 1.00, 1},
    },
}

function TOSUIInstaller:ApplyStepButtonStatus(btn, status, selected)
    local c = STATUS_COLORS[status] or STATUS_COLORS.default
    if selected then
        btn:SetBackdropColor(unpack(c.bgSel))
        btn:SetBackdropBorderColor(unpack(c.borderSel))
    else
        btn:SetBackdropColor(unpack(c.bg))
        btn:SetBackdropBorderColor(unpack(c.border))
    end
    local text = btn:GetFontString() or btn._statusText
    if text then
        text:SetTextColor(unpack(c.text))
    end
    btn.versionStatus = status
end

function TOSUIInstaller:GetVersionStatusForStep(stepTitle, stepIndex)

    if stepIndex == 1 or stepTitle == "Welcome" or stepTitle == "Installation Complete" then
        return "default"
    end

    local addonMap = {
        ["EllesmereUI"] = "EllesmereUI",
        ["BigWigs"] = "BigWigs",
        ["Blizzard_EditMode"] = "Blizzard_EditMode",
        ["MRT"] = "MRT",
        ["Class Layout"] = "Blizzard_CooldownViewer",
    }

    local addonName = addonMap[stepTitle]
    if not addonName then
        return "default"
    end

    if self.recentlyInstalled and self.recentlyInstalled[addonName] then
        return "uptodate"
    end

    local currentVersion = tonumber(TUI.version)
    local profiles = TUI.db and TUI.db.global and TUI.db.global.profiles
    if not profiles then
        return "notinstalled"
    end

    local installedVersion = profiles[addonName]
    if installedVersion == nil then
        return "notinstalled"
    end

    -- Legacy boolean true, or matching version number/string.
    if installedVersion == true then
        return "uptodate"
    end

    local installedNum = tonumber(installedVersion)
    if currentVersion and installedNum and installedNum == currentVersion then
        return "uptodate"
    end
    if tostring(installedVersion) == tostring(TUI.version) then
        return "uptodate"
    end

    return "outdated"
end

function TOSUIInstaller:CreateFrame()
    if self.frame then
        return self.frame
    end

    if not self.recentlyInstalled then
        self.recentlyInstalled = {}
    end

    local frame = _G.CreateFrame("Frame", "TOSUIInstallerFrame", _G.UIParent, "BackdropTemplate")
    frame:SetSize(FRAME_WIDTH, FRAME_HEIGHT)
    frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    frame:SetFrameStrata("DIALOG")
    frame:SetToplevel(true)
    frame:EnableMouse(true)
    frame:SetMovable(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)

    frame:SetBackdrop({
        bgFile = "Interface\\AddOns\\TOSUI\\Media\\Textures\\UI-Background-Rock",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileSize = 32,
        edgeSize = 4,
        insets = { left = 1, right = 1, top = 1, bottom = 1 }
    })
    frame:SetBackdropColor(0.08, 0.06, 0.12, 0.95)
    frame:SetBackdropBorderColor(0, 0, 0, 0.8)

    local header = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    header:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -8)
    header:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -8, -8)
    header:SetHeight(70)
    header:SetBackdrop({
        bgFile = "Interface\\AddOns\\TOSUI\\Media\\Textures\\UI-Background-Marble",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 4,
        insets = { left = 1, right = 1, top = 1, bottom = 1 }
    })
    header:SetBackdropColor(0.14, 0.10, 0.22, 0.95)
    header:SetBackdropBorderColor(0, 0, 0, 0.8)

    local logo = header:CreateTexture(nil, "ARTWORK")
    logo:SetSize(56, 56)
    logo:SetPoint("LEFT", header, "LEFT", 10, 0)
    logo:SetTexture("Interface\\AddOns\\TOSUI\\Media\\Textures\\LogoTOSUI.tga")
    logo:SetTexCoord(0, 1, 0, 1)

    local title = header:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("LEFT", logo, "RIGHT", 12, 0)
    title:SetText("|cffffd700TOS|r|cff9b4dffUI|r Installer")
    title:SetFont("Fonts\\FRIZQT__.TTF", 28)

    local closeBtn = _G.CreateFrame("Button", nil, header)
    closeBtn:SetSize(32, 32)
    closeBtn:SetPoint("TOPRIGHT", header, "TOPRIGHT", 0, 0)

    closeBtn:SetNormalTexture("Interface\\AddOns\\TOSUI\\Media\\Textures\\UI-Panel-MinimizeButton-Up")
    closeBtn:SetPushedTexture("Interface\\AddOns\\TOSUI\\Media\\Textures\\UI-Panel-MinimizeButton-Down")
    closeBtn:SetHighlightTexture("Interface\\AddOns\\TOSUI\\Media\\Textures\\UI-Panel-MinimizeButton-Up")
    closeBtn:SetDisabledTexture("Interface\\AddOns\\TOSUI\\Media\\Textures\\UI-Panel-MinimizeButton-Disabled")

    closeBtn:GetHighlightTexture():SetBlendMode("ADD")
    closeBtn:GetHighlightTexture():SetAlpha(0.3)

    closeBtn:SetScript("OnClick", function() self:Hide() end)

    local stepPanel = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    stepPanel:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -8)
    stepPanel:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 8, 8)
    stepPanel:SetWidth(STEP_PANEL_WIDTH)
    stepPanel:SetBackdrop({
        bgFile = "Interface\\AddOns\\TOSUI\\Media\\Textures\\UI-Background-Rock",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 4,
        insets = { left = 1, right = 1, top = 1, bottom = 1 }
    })
    stepPanel:SetBackdropColor(0.06, 0.05, 0.10, 0.95)
    stepPanel:SetBackdropBorderColor(0, 0, 0, 0.8)

    local contentPanel = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    contentPanel:SetPoint("TOPLEFT", stepPanel, "TOPRIGHT", 8, 0)
    contentPanel:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -8, 8)
    contentPanel:SetBackdrop({
        bgFile = "Interface\\AddOns\\TOSUI\\Media\\Textures\\UI-Background-Marble",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 4,
        insets = { left = 1, right = 1, top = 1, bottom = 1 }
    })
    contentPanel:SetBackdropColor(0.10, 0.08, 0.14, 0.95)
    contentPanel:SetBackdropBorderColor(0, 0, 0, 0.8)

    local stepList = CreateFrame("ScrollFrame", nil, stepPanel, "BackdropTemplate")
    stepList:SetPoint("TOPLEFT", stepPanel, "TOPLEFT", 10, -10)
    stepList:SetPoint("BOTTOMRIGHT", stepPanel, "BOTTOMRIGHT", -30, 50)

    local scrollBar = CreateFrame("Slider", nil, stepList, "BackdropTemplate")
    scrollBar:SetPoint("TOPRIGHT", stepList, "TOPRIGHT", 20, 0)
    scrollBar:SetPoint("BOTTOMRIGHT", stepList, "BOTTOMRIGHT", 20, 0)
    scrollBar:SetWidth(16)
    scrollBar:SetBackdrop({
        bgFile = "Interface\\AddOns\\TOSUI\\Media\\Textures\\UI-Background-Rock",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 4,
        insets = { left = 1, right = 1, top = 1, bottom = 1 }
    })
    scrollBar:SetBackdropColor(0.08, 0.06, 0.12, 0.8)
    scrollBar:SetBackdropBorderColor(0, 0, 0, 0.6)
    scrollBar:SetOrientation("VERTICAL")
    scrollBar:SetValueStep(1)
    scrollBar:SetObeyStepOnDrag(true)

    local thumb = scrollBar:CreateTexture(nil, "OVERLAY")
    thumb:SetTexture("Interface\\Buttons\\WHITE8X8")
    thumb:SetVertexColor(1.0, 0.80, 0.15, 0.9) 
    scrollBar:SetThumbTexture(thumb)

    stepList.scrollBar = scrollBar
    stepList:EnableMouseWheel(true)

    stepList:SetScript("OnMouseWheel", function(_, delta)
        local current = scrollBar:GetValue()
        local min, max = scrollBar:GetMinMaxValues()
        if delta > 0 then
            scrollBar:SetValue(math.max(min, current - 20))
        else
            scrollBar:SetValue(math.min(max, current + 20))
        end
    end)

    scrollBar:SetScript("OnValueChanged", function(_, value)
        stepList:SetVerticalScroll(value)
    end)

    local stepContent = CreateFrame("Frame", nil, stepList)
    stepContent:SetSize(STEP_PANEL_WIDTH - 40, 1)
    stepList:SetScrollChild(stepContent)

    local stepContentRegion = CreateFrame("Frame", nil, contentPanel)
    stepContentRegion:SetSize(CONTENT_PANEL_WIDTH - 64, FRAME_HEIGHT - 220)
    stepContentRegion:SetPoint("TOP", contentPanel, "TOP", 0, -30)
    stepContentRegion:SetPoint("LEFT", contentPanel, "LEFT", 32, 0)
    stepContentRegion:SetPoint("RIGHT", contentPanel, "RIGHT", -32, 0)

    local subtitle = stepContentRegion:CreateFontString(nil, "OVERLAY")
    subtitle:SetPoint("TOP", stepContentRegion, "TOP", 0, 0)
    subtitle:SetWidth(CONTENT_PANEL_WIDTH - 96)
    subtitle:SetWordWrap(true)
    subtitle:SetJustifyH("CENTER")
    subtitle:SetFont("Fonts\\FRIZQT__.TTF", 24, "OUTLINE")

    local tutorialImage = stepContentRegion:CreateTexture(nil, "ARTWORK")
    tutorialImage:SetSize(140, 140)
    tutorialImage:SetPoint("TOP", subtitle, "BOTTOM", 0, -20)
    tutorialImage:Hide()

    local desc1 = stepContentRegion:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    desc1:SetPoint("TOP", subtitle, "BOTTOM", 0, -20)
    desc1:SetWordWrap(true)
    desc1:SetWidth(CONTENT_PANEL_WIDTH - 96)
    desc1:SetJustifyH("CENTER")
    desc1:SetFont("Fonts\\FRIZQT__.TTF", 16, "OUTLINE")

    local desc2 = stepContentRegion:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    desc2:SetPoint("TOP", desc1, "BOTTOM", 0, -15)
    desc2:SetWordWrap(true)
    desc2:SetWidth(CONTENT_PANEL_WIDTH - 96)
    desc2:SetJustifyH("CENTER")
    desc2:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")

    local desc3 = stepContentRegion:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    desc3:SetPoint("TOP", desc2, "BOTTOM", 0, -15)
    desc3:SetWordWrap(true)
    desc3:SetWidth(CONTENT_PANEL_WIDTH - 96)
    desc3:SetJustifyH("CENTER")
    desc3:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")

    local option1 = self:CreateModernButton(stepContentRegion, "Option 1", 180, 40)
    option1:SetPoint("TOP", desc3, "BOTTOM", 0, -30)
    option1:Hide()

    local option2 = self:CreateModernButton(stepContentRegion, "Option 2", 180, 40)
    option2:SetPoint("TOP", option1, "BOTTOM", 0, -15)
    option2:Hide()

    local option3 = self:CreateModernButton(stepContentRegion, "Option 3", 180, 40)
    option3:SetPoint("TOP", option2, "BOTTOM", 0, -15)
    option3:Hide()

    local option4 = self:CreateModernButton(stepContentRegion, "Option 4", 180, 40)
    option4:SetPoint("TOP", option3, "BOTTOM", 0, -15)
    option4:Hide()

    local option1Alt = self:CreateModernButton(contentPanel, "Option 1", 180, 40)
    option1Alt:Hide()

    local option2Alt = self:CreateModernButton(contentPanel, "Option 2", 180, 40)
    option2Alt:Hide()

    local option3Alt = self:CreateModernButton(contentPanel, "Option 3", 180, 40)
    option3Alt:Hide()

    local option4Alt = self:CreateModernButton(contentPanel, "Option 4", 180, 40)
    option4Alt:Hide()

    local optionDropdown = self:CreateModernDropdown(stepContentRegion, 300, 32)
    optionDropdown:SetPoint("TOP", desc3, "BOTTOM", 0, -40)
    optionDropdown:Hide()

    local setupButton = self:CreateModernButton(stepContentRegion, "Setup", 120, 32)
    setupButton:SetPoint("TOP", optionDropdown, "BOTTOM", 0, -15)
    setupButton:Hide()

    local dynamicOptionsFrame = _G.CreateFrame("Frame", nil, stepContentRegion)
    dynamicOptionsFrame:SetPoint("TOP", desc3, "BOTTOM", 0, -80)
    dynamicOptionsFrame:SetSize(CONTENT_PANEL_WIDTH - 64, 250)
    dynamicOptionsFrame:Hide()

    local navPanel = _G.CreateFrame("Frame", nil, frame)
    navPanel:SetPoint("BOTTOMLEFT", stepPanel, "BOTTOMLEFT", 0, 0)
    navPanel:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -8, 8)
    navPanel:SetHeight(50)

    local prevBtn = self:CreateModernButton(navPanel, "Previous", 100, 32)
    prevBtn:SetPoint("BOTTOMLEFT", navPanel, "BOTTOMLEFT", 10, 5)
    prevBtn:SetScript("OnClick", function() self:PreviousStep() end)

    local nextBtn = self:CreateModernButton(navPanel, "Continue", 100, 32)
    nextBtn:SetPoint("BOTTOMRIGHT", navPanel, "BOTTOMRIGHT", -10, 5)
    nextBtn:SetScript("OnClick", function() self:NextStep() end)

    local skipBtn = self:CreateModernButton(navPanel, "Skip", 80, 32)
    skipBtn:SetPoint("BOTTOMRIGHT", nextBtn, "BOTTOMLEFT", -5, 0)
    skipBtn:SetScript("OnClick", function() self:NextStep() end)

    self.frame = frame
    self.header = header
    self.stepPanel = stepPanel
    self.contentPanel = contentPanel
    self.stepList = stepList
    self.stepContent = stepContent
    self.stepContentRegion = stepContentRegion
    self.subtitle = subtitle
    self.tutorialImage = tutorialImage
    self.desc1 = desc1
    self.desc2 = desc2
    self.desc3 = desc3
    self.option1 = option1
    self.option2 = option2
    self.option3 = option3
    self.option4 = option4
    self.option1Alt = option1Alt
    self.option2Alt = option2Alt
    self.option3Alt = option3Alt
    self.option4Alt = option4Alt
    self.optionDropdown = optionDropdown
    self.setupButton = setupButton
    self.dynamicOptionsFrame = dynamicOptionsFrame
    self.prevBtn = prevBtn
    self.nextBtn = nextBtn
    self.skipBtn = skipBtn

    self.currentStep = 1
    self.stepButtons = {}

    frame:Hide()

    return frame
end

function TOSUIInstaller:CreateStepButtons(installer)
    if not installer or not installer.StepTitles then
        return
    end

    for _, btn in pairs(self.stepButtons) do
        btn:Hide()
        btn:SetParent(nil)
    end
    self.stepButtons = {}

    local STEP_BTN_H = 28
    local STEP_BTN_GAP = 8
    local stepStride = STEP_BTN_H + STEP_BTN_GAP

    for i, title in ipairs(installer.StepTitles) do
        local btn = _G.CreateFrame("Button", nil, self.stepContent, "BackdropTemplate")
        btn:SetSize(STEP_PANEL_WIDTH - 40, STEP_BTN_H)
        btn:SetPoint("TOPLEFT", self.stepContent, "TOPLEFT", 0, -(i - 1) * stepStride)

        -- Solid backdrop so status colors are visible (marble textures wash out tints).
        btn:SetBackdrop({
            bgFile = "Interface\\Buttons\\WHITE8X8",
            edgeFile = "Interface\\Buttons\\WHITE8X8",
            edgeSize = 1,
            insets = { left = 1, right = 1, top = 1, bottom = 1 }
        })

        local text = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        text:SetPoint("CENTER")
        text:SetText(title)
        btn:SetFontString(text)
        btn._statusText = text

        local versionStatus = self:GetVersionStatusForStep(title, i)
        self:ApplyStepButtonStatus(btn, versionStatus, false)

        btn.stepIndex = i
        btn:SetScript("OnClick", function() self:GoToStep(i) end)
        btn:SetScript("OnEnter", function()
            self:ApplyStepButtonStatus(btn, btn.versionStatus or "default", true)
        end)
        btn:SetScript("OnLeave", function()
            self:ApplyStepButtonStatus(btn, btn.versionStatus or "default", i == self.currentStep)
        end)

        self.stepButtons[i] = btn
    end

    self.stepContent:SetHeight(#installer.StepTitles * stepStride)
end

function TOSUIInstaller:UpdateStepButtons()
    if not self.stepButtons then
        return
    end

    for i, btn in pairs(self.stepButtons) do
        if self.installer and self.installer.StepTitles then
            local stepTitle = self.installer.StepTitles[i]
            if stepTitle then
                local newStatus = self:GetVersionStatusForStep(stepTitle, i)
                self:ApplyStepButtonStatus(btn, newStatus, i == self.currentStep)
            end
        end
    end
end

function TOSUIInstaller:RefreshAllStepButtons()
    self:UpdateStepButtons()
end

function TOSUIInstaller:Show(installer)
    if not installer then
        return
    end

    self:CreateFrame()
    self.installer = installer

    self:CreateStepButtons(installer)

    self.frame:Show()

    self:GoToStep(1)
end

function TOSUIInstaller:Hide()
    if self.frame then
        self.frame:Hide()
    end
end

function TOSUIInstaller:GoToStep(step)
    if not self.installer or not self.installer.Pages or not self.installer.Pages[step] then
        return
    end

    self.currentStep = step

    self:ClearContent()
    self:UpdateStepButtons()

    if self.prevBtn then
        self.prevBtn:SetEnabled(step > 1)
    end

    if self.nextBtn and self.installer.StepTitles then
        local isLast = step >= #self.installer.StepTitles
        self.nextBtn:SetEnabled(true)

        if isLast then
            self.nextBtn:SetText("Finish")
            if self.skipBtn then
                self.skipBtn:Hide()
            end
        else
            self.nextBtn:SetText("Continue")
            if self.skipBtn then
                self.skipBtn:Show()
            end
        end
    end

    local proxy = {
        Title = self.subtitle,
        SubTitle = self.subtitle,  
        Desc1 = self.desc1,
        Desc2 = self.desc2,
        Desc3 = self.desc3,
        Option1 = self.option1,
        Option2 = self.option2,
        Option3 = self.option3,
        Option4 = self.option4,
        Next = self.nextBtn,
        Prev = self.prevBtn,
        Skip = self.skipBtn,
        ShowTutorialImage = function(imagePath) return self:ShowTutorialImage(imagePath) end,
        ShowChoiceList = function(_, choices) return self:ShowChoiceList(choices) end,
        SetFrameStrata = function(_, strata)
            if self.frame then self.frame:SetFrameStrata(strata) end
        end,
    }
    _G.PluginInstallFrame = proxy
    _G.TOSUIInstallFrame = proxy

    local SE = TUI:GetModule("Setup")
    if SE and SE.Setup then
        local originalSetup = SE.Setup
        local installerSelf = self
        SE.Setup = function(setupModule, addonName, ...)
            local result = originalSetup(setupModule, addonName, ...)

            if addonName and installerSelf.recentlyInstalled then
                installerSelf.recentlyInstalled[addonName] = true

                if installerSelf.RefreshAllStepButtons then
                    installerSelf:RefreshAllStepButtons()
                end
            end

            return result
        end
    end

    self.installer.Pages[step]()

    if step == 1 then
        self.desc2:SetText("If updating, click addons highlighted in red and 'Setup'")
    end

    self:RepositionOptionButtons()
    self:SetSubtitleFont()
end

function TOSUIInstaller:ShowChoiceList(choices)
    choices = choices or {}
    self._usingChoiceList = true
    self._choiceCallbacks = {}

    self.option1:Hide()
    self.option2:Hide()
    self.option3:Hide()
    self.option4:Hide()
    self.optionDropdown:Hide()
    self.setupButton:Hide()
    self.optionDropdown:ClearOptions()

    if #choices == 0 then
        return
    end

    if #choices == 1 then
        self.option1:ClearAllPoints()
        self.option1:SetPoint("TOP", self.desc3, "BOTTOM", 0, -40)
        self.option1:SetText(choices[1].label or "Setup")
        self.option1:SetScript("OnClick", choices[1].onClick)
        self.option1:Show()
        return
    end

    for i, choice in ipairs(choices) do
        self._choiceCallbacks[i] = choice.onClick
        self.optionDropdown:AddOption(choice.label or ("Option " .. i), i, function(value)
            self.selectedOptionIndex = value
        end)
    end

    -- Prefill first choice so Setup works without reopening the menu.
    self.selectedOptionIndex = 1
    if self.optionDropdown.options and self.optionDropdown.options[1] then
        self.optionDropdown.selectedIndex = 1
        self.optionDropdown.selectedOption = self.optionDropdown.options[1]
        if self.optionDropdown.text then
            self.optionDropdown.text:SetText(choices[1].label or "Option 1")
        end
    end

    self.optionDropdown:ClearAllPoints()
    self.optionDropdown:SetPoint("TOP", self.desc3, "BOTTOM", 0, -40)
    self.optionDropdown:Show()
    self.setupButton:ClearAllPoints()
    self.setupButton:SetPoint("TOP", self.optionDropdown, "BOTTOM", 0, -15)
    self.setupButton:Show()
    self.setupButton:SetScript("OnClick", function()
        local cb = self._choiceCallbacks and self._choiceCallbacks[self.selectedOptionIndex]
        if cb then
            cb()
        end
    end)
end

function TOSUIInstaller:RepositionOptionButtons()
    if self._usingChoiceList then
        return
    end

    local visibleButtons = {}
    if self.option1:IsShown() then table.insert(visibleButtons, self.option1) end
    if self.option2:IsShown() then table.insert(visibleButtons, self.option2) end
    if self.option3:IsShown() then table.insert(visibleButtons, self.option3) end
    if self.option4:IsShown() then table.insert(visibleButtons, self.option4) end

    local buttonCount = #visibleButtons
    if buttonCount == 0 then return end

    for _, btn in ipairs(visibleButtons) do
        btn:ClearAllPoints()
    end

    self.optionDropdown:Hide()
    self.setupButton:Hide()

    if buttonCount == 1 then

        visibleButtons[1]:SetPoint("TOP", self.desc3, "BOTTOM", 0, -40)
        visibleButtons[1]:Show()
    elseif buttonCount > 1 then

        for _, btn in ipairs(visibleButtons) do
            btn:Hide()
        end

        self.optionDropdown:ClearOptions()

        for i, btn in ipairs(visibleButtons) do
            local btnText = btn:GetFontString():GetText()

            self.optionDropdown:AddOption(btnText, i, function(value)

                self.selectedOptionIndex = value
                self.selectedOptionButton = visibleButtons[value]
            end)
        end

        self.optionDropdown:Show()
        self.setupButton:Show()

        self.setupButton:SetScript("OnClick", function()
            if self.selectedOptionButton then
                local btnScript = self.selectedOptionButton:GetScript("OnClick")
                if btnScript then
                    btnScript()
                end
            end
        end)
    end
end

function TOSUIInstaller:NextStep()
    if not self.installer or not self.installer.StepTitles then
        self:Hide()
        return
    end

    -- On the final step the button reads "Finish" — reload so imported profiles apply.
    if self.currentStep >= #self.installer.StepTitles then
        ReloadUI()
        return
    end

    self:GoToStep(self.currentStep + 1)
end

function TOSUIInstaller:PreviousStep()
    if self.currentStep > 1 then
        self:GoToStep(self.currentStep - 1)
    end
end

function TOSUIInstaller:SetSubtitleFont()

    if self.subtitle then
        self.subtitle:SetFont("Fonts\\FRIZQT__.TTF", 24, "OUTLINE")
        self.subtitle:SetTextColor(1, 1, 1, 1) 
    end
end

function TOSUIInstaller:ClearContent()
    self:HideEllesmereImportPicker()
    self._usingChoiceList = false
    self._choiceCallbacks = nil
    self.selectedOptionIndex = nil

    self.subtitle:SetText("")
    self.desc1:SetText("")
    self.desc2:SetText("")
    self.desc3:SetText("")

    self.subtitle:ClearAllPoints()
    if self.currentStep == 1 then

        self.subtitle:SetPoint("TOP", self.stepContentRegion, "TOP", 0, -50)
    else

        self.subtitle:SetPoint("TOP", self.stepContentRegion, "TOP", 0, 0)
    end

    self.subtitle:SetWidth(CONTENT_PANEL_WIDTH - 96)
    self.desc1:SetWidth(CONTENT_PANEL_WIDTH - 96)
    self.desc2:SetWidth(CONTENT_PANEL_WIDTH - 96)
    self.desc3:SetWidth(CONTENT_PANEL_WIDTH - 96)

    self:SetSubtitleFont()

    self.tutorialImage:Hide()
    self.desc1:ClearAllPoints()
    self.desc1:SetPoint("TOP", self.subtitle, "BOTTOM", 0, -20)

    self.option1:Hide()
    self.option1:SetScript("OnClick", nil)
    self.option2:Hide()
    self.option2:SetScript("OnClick", nil)
    self.option3:Hide()
    self.option3:SetScript("OnClick", nil)
    self.option4:Hide()
    self.option4:SetScript("OnClick", nil)

    self.optionDropdown:Hide()
    self.optionDropdown:ClearOptions()
    self.setupButton:Hide()
    self.setupButton:SetScript("OnClick", nil)

    self.dynamicOptionsFrame:Hide()
    self:ClearDynamicOptions()
end

function TOSUIInstaller:ClearDynamicOptions()
    if not self.dynamicButtons then
        self.dynamicButtons = {}
    end

    for _, btn in pairs(self.dynamicButtons) do
        btn:Hide()
        btn:SetParent(nil)
    end
    self.dynamicButtons = {}
end

function TOSUIInstaller:ShowTutorialImage(imagePath)
    if imagePath and self.tutorialImage then
        self.tutorialImage:SetTexture(imagePath)
        self.tutorialImage:Show()

        if self.currentStep == 1 then

            self.subtitle:ClearAllPoints()
            self.subtitle:SetPoint("TOP", self.stepContentRegion, "TOP", 0, -45)
            self.subtitle:SetWidth(CONTENT_PANEL_WIDTH - 96) 

            self.tutorialImage:ClearAllPoints()
            self.tutorialImage:SetPoint("TOP", self.subtitle, "BOTTOM", 0, -30)

            self.desc1:ClearAllPoints()
            self.desc1:SetPoint("TOP", self.tutorialImage, "BOTTOM", 0, -30)
            self.desc1:SetWidth(CONTENT_PANEL_WIDTH - 96) 
        else

            self.tutorialImage:ClearAllPoints()
            self.tutorialImage:SetPoint("TOP", self.subtitle, "BOTTOM", 0, -20)

            self.desc1:ClearAllPoints()
            self.desc1:SetPoint("TOP", self.tutorialImage, "BOTTOM", 0, -20)
            self.desc1:SetWidth(CONTENT_PANEL_WIDTH - 96) 
        end
    else

        self.tutorialImage:Hide()

        if self.currentStep ~= 1 then
            self.subtitle:ClearAllPoints()
            self.subtitle:SetPoint("TOP", self.stepContentRegion, "TOP", 0, 0)
            self.subtitle:SetWidth(CONTENT_PANEL_WIDTH - 96) 
        end

        self.desc1:ClearAllPoints()
        self.desc1:SetPoint("TOP", self.subtitle, "BOTTOM", 0, -20)
        self.desc1:SetWidth(CONTENT_PANEL_WIDTH - 96) 
    end
end

function TOSUIInstaller:ExtractAddonNameFromCurrentStep()
    if not self.installer or not self.installer.StepTitles or not self.currentStep then
        return nil
    end

    local stepTitle = self.installer.StepTitles[self.currentStep]
    if not stepTitle then
        return nil
    end

    local addonMap = {
        ["EllesmereUI"] = "EllesmereUI",
        ["BigWigs"] = "BigWigs",
        ["Blizzard_EditMode"] = "Blizzard_EditMode",
        ["MRT"] = "MRT",
        ["Class Layout"] = "Blizzard_CooldownViewer",
    }

    return addonMap[stepTitle]
end

function TOSUIInstaller:MarkAsRecentlyInstalled(addonName)
    if not self.recentlyInstalled then
        self.recentlyInstalled = {}
    end
    self.recentlyInstalled[addonName] = true
end

function TOSUIInstaller:RefreshStepButtonStatus(stepTitle)
    if not self.installer or not self.installer.StepTitles or not self.stepButtons then
        return
    end

    -- Accept either a sidebar title ("Class Layout") or an addon key ("Blizzard_CooldownViewer").
    local titleAliases = {
        Blizzard_CooldownViewer = "Class Layout",
        ["Class Layout"] = "Class Layout",
    }
    local matchTitle = titleAliases[stepTitle] or stepTitle

    for i, title in ipairs(self.installer.StepTitles) do
        if title == matchTitle or title == stepTitle then
            local btn = self.stepButtons[i]
            if btn then
                self:ApplyStepButtonStatus(btn, self:GetVersionStatusForStep(title, i), i == self.currentStep)
            end
            break
        end
    end
end

function TOSUIInstaller:SetupAddonAndRefreshStatus(addonName, ...)
    local SE = TUI:GetModule("Setup")
    if SE and SE.Setup then
        SE:Setup(addonName, ...)
        self:MarkAsRecentlyInstalled(addonName)
        self:RefreshStepButtonStatus(addonName)
        C_Timer.After(0.2, function()
            self:RefreshStepButtonStatus(addonName)
        end)
    end
end

function TOSUIInstaller:HideEllesmereImportPicker()
    if self.euiImportFrame then
        self.euiImportFrame:Hide()
    end
    self.euiImportSession = nil
end

function TOSUIInstaller:EnsureEllesmereImportPicker()
    -- Recreate if an older layout was cached this session.
    if self.euiImportFrame and not self.euiImportFrame._tosLayoutV3 then
        self.euiImportFrame:Hide()
        self.euiImportFrame:SetParent(nil)
        self.euiImportFrame = nil
    end

    if self.euiImportFrame then
        return self.euiImportFrame
    end

    local parent = self.stepContentRegion
    local frame = CreateFrame("Frame", nil, parent)
    -- Anchored under desc1 in ShowEllesmereImportPicker to avoid text overlap.
    frame:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, -110)
    frame:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", 0, 10)
    frame:Hide()
    frame._tosLayoutV3 = true

    local selectAll = self:CreateModernButton(frame, "Select All", 110, 26)
    selectAll:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)

    local deselectAll = self:CreateModernButton(frame, "Deselect All", 110, 26)
    deselectAll:SetPoint("LEFT", selectAll, "RIGHT", 8, 0)

    local layoutCheck = CreateFrame("CheckButton", nil, frame, "ChatConfigCheckButtonTemplate")
    layoutCheck:SetPoint("LEFT", deselectAll, "RIGHT", 16, 0)
    layoutCheck:SetChecked(true)
    layoutCheck.Text:SetText("Include Layout")
    layoutCheck.Text:SetTextColor(0.9, 0.9, 0.9, 1)

    local countFs = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    countFs:SetPoint("TOPLEFT", selectAll, "BOTTOMLEFT", 0, -6)
    countFs:SetTextColor(1.0, 0.80, 0.15, 1)

    -- Leave clear room for the default scroll bar (~24px) plus status column padding.
    local scroll = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -52)
    scroll:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -36, 44)

    local content = CreateFrame("Frame", nil, scroll)
    content:SetSize(1, 1)
    scroll:SetScrollChild(content)

    local importBtn = self:CreateModernButton(frame, "Import Selected", 150, 30, "primary")
    importBtn:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -4, 0)

    local cancelBtn = self:CreateModernButton(frame, "Back", 100, 30)
    cancelBtn:SetPoint("RIGHT", importBtn, "LEFT", -8, 0)

    frame.selectAll = selectAll
    frame.deselectAll = deselectAll
    frame.layoutCheck = layoutCheck
    frame.countFs = countFs
    frame.scroll = scroll
    frame.content = content
    frame.importBtn = importBtn
    frame.cancelBtn = cancelBtn
    frame.rows = {}

    self.euiImportFrame = frame
    return frame
end

local function RefreshEllesmereCount(self)
    local frame = self.euiImportFrame
    local session = self.euiImportSession
    if not frame or not session then
        return
    end

    local selected, total = 0, 0
    for _, row in ipairs(frame.rows) do
        total = total + 1
        if row.check:GetChecked() then
            selected = selected + 1
        end
    end
    frame.countFs:SetText(format("Import will include %d of %d modules", selected, total))
end

function TOSUIInstaller:ShowEllesmereImportPicker(opts)
    opts = opts or {}
    if not EllesmereUI or not EllesmereUI.DecodeImportString or not EllesmereUI.ImportProfile then
        TUI:Print("EllesmereUI import API is unavailable. Update EllesmereUI.")
        return
    end

    local payload, err = EllesmereUI.DecodeImportString(opts.importString)
    if not payload or type(payload.data) ~= "table" then
        TUI:Print("Could not decode EllesmereUI profile: " .. tostring(err or "unknown error"))
        return
    end

    self.subtitle:SetText("EllesmereUI Import")
    self.desc1:SetText("Choose which modules to import. Unchecked modules keep your current EllesmereUI settings.")
    self.desc2:SetText("")
    self.desc3:SetText("")
    self.tutorialImage:Hide()
    self.option1:Hide()
    self.option2:Hide()
    self.option3:Hide()
    self.option4:Hide()
    if self.optionDropdown then self.optionDropdown:Hide() end
    if self.setupButton then self.setupButton:Hide() end
    if self.dynamicOptionsFrame then self.dynamicOptionsFrame:Hide() end

    local frame = self:EnsureEllesmereImportPicker()
    frame:ClearAllPoints()
    frame:SetPoint("TOPLEFT", self.desc1, "BOTTOMLEFT", 0, -16)
    frame:SetPoint("BOTTOMRIGHT", self.stepContentRegion, "BOTTOMRIGHT", 0, 10)

    local content = frame.content
    for _, row in ipairs(frame.rows) do
        row:Hide()
        row:SetParent(nil)
    end
    wipe(frame.rows)

    -- Measure after show so GetWidth() is valid.
    frame:Show()
    local rowWidth = math.max(200, (frame.scroll:GetWidth() or (CONTENT_PANEL_WIDTH - 120)) - 4)
    local statusWidth = 88
    local nameWidth = math.max(80, rowWidth - statusWidth - 36)

    local addonMap = EllesmereUI._ADDON_DB_MAP or {}
    local addons = payload.data.addons or {}
    local y = 0
    local ROW_H = 28

    for _, entry in ipairs(addonMap) do
        local folder = entry.folder
        local canon = entry.canon or folder
        local inPayload = addons[canon] ~= nil or addons[folder] ~= nil
        if inPayload then
            local loaded = true
            if EllesmereUI.IsModuleAddonLoaded then
                loaded = EllesmereUI.IsModuleAddonLoaded(folder)
            end

            local row = CreateFrame("Frame", nil, content)
            row:SetSize(rowWidth, ROW_H)
            row:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -y)

            local status = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            status:SetPoint("RIGHT", row, "RIGHT", -2, 0)
            status:SetWidth(statusWidth)
            status:SetJustifyH("RIGHT")
            status:SetWordWrap(false)
            if loaded then
                status:SetText("|cff66ff66Ready|r")
            else
                status:SetText("|cff999999Not Loaded|r")
            end

            local check = CreateFrame("CheckButton", nil, row, "ChatConfigCheckButtonTemplate")
            check:SetPoint("LEFT", row, "LEFT", 0, 0)
            check:SetEnabled(loaded)
            check:SetChecked(loaded)
            check.Text:ClearAllPoints()
            check.Text:SetPoint("LEFT", check, "RIGHT", 4, 0)
            check.Text:SetWidth(nameWidth)
            check.Text:SetJustifyH("LEFT")
            check.Text:SetWordWrap(false)
            check.Text:SetText(entry.display or canon)
            if loaded then
                check.Text:SetTextColor(1, 1, 1, 1)
            else
                check.Text:SetTextColor(0.55, 0.55, 0.55, 1)
            end
            check:SetScript("OnClick", function()
                RefreshEllesmereCount(self)
            end)

            row.check = check
            row.canon = canon
            row.folder = folder
            row.canImport = loaded
            frame.rows[#frame.rows + 1] = row
            y = y + ROW_H
        end
    end

    content:SetSize(rowWidth, math.max(y, 1))
    frame.layoutCheck:SetChecked(true)

    self.euiImportSession = {
        payload = payload,
        profileName = opts.profileName or "TOS",
        scale = opts.scale,
        onDone = opts.onDone,
    }

    frame.selectAll:SetScript("OnClick", function()
        for _, row in ipairs(frame.rows) do
            if row.canImport then
                row.check:SetChecked(true)
            end
        end
        RefreshEllesmereCount(self)
    end)

    frame.deselectAll:SetScript("OnClick", function()
        for _, row in ipairs(frame.rows) do
            row.check:SetChecked(false)
        end
        RefreshEllesmereCount(self)
    end)

    frame.cancelBtn:SetScript("OnClick", function()
        self:HideEllesmereImportPicker()
        if self.currentStep then
            self:GoToStep(self.currentStep)
        end
    end)

    frame.importBtn:SetScript("OnClick", function()
        self:CommitEllesmereImportPicker()
    end)

    RefreshEllesmereCount(self)
end

function TOSUIInstaller:ShowSetupSuccess(message)
    message = message or "Success"

    if not self.successFrame then
        local banner = CreateFrame("Frame", "TOSUIInstallStepComplete", UIParent, "BackdropTemplate")
        banner:SetSize(280, 56)
        banner:SetPoint("TOP", UIParent, "TOP", 0, -120)
        banner:SetFrameStrata("FULLSCREEN_DIALOG")
        banner:SetBackdrop({
            bgFile = "Interface\\Buttons\\WHITE8X8",
            edgeFile = "Interface\\Buttons\\WHITE8X8",
            edgeSize = 1,
        })
        banner:SetBackdropColor(0.06, 0.05, 0.10, 0.95)
        banner:SetBackdropBorderColor(1.0, 0.80, 0.15, 0.9)

        local text = banner:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        text:SetPoint("CENTER")
        text:SetTextColor(1.0, 0.80, 0.15, 1)
        banner.text = text
        banner:Hide()

        banner:SetScript("OnShow", function(f)
            if f.fadeOut then
                f.fadeOut:Cancel()
            end
            f:SetAlpha(1)
            f.fadeOut = C_Timer.NewTimer(2.5, function()
                if f:IsShown() then
                    UIFrameFadeOut(f, 0.4, 1, 0)
                    C_Timer.After(0.45, function()
                        f:Hide()
                        f:SetAlpha(1)
                    end)
                end
            end)
        end)

        self.successFrame = banner
        _G.TOSUIInstallStepComplete = banner
    end

    self.successFrame.text:SetText(message)
    self.successFrame.message = message
    self.successFrame:Show()
    PlaySound(SOUNDKIT and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON or 856)
end

function TOSUIInstaller:CommitEllesmereImportPicker()
    local session = self.euiImportSession
    local frame = self.euiImportFrame
    if not session or not frame or not EllesmereUI or not EllesmereUI.ImportProfile then
        return
    end

    local selectedCount = 0
    for _, row in ipairs(frame.rows) do
        if row.check:GetChecked() then
            selectedCount = selectedCount + 1
        end
    end
    if selectedCount == 0 then
        TUI:Print("Select at least one EllesmereUI module to import.")
        return
    end

    local deepCopy = EllesmereUI._DeepCopy
    local filtered = deepCopy and deepCopy(session.payload) or session.payload
    if type(filtered) ~= "table" or type(filtered.data) ~= "table" then
        TUI:Print("EllesmereUI import payload is invalid.")
        return
    end

    local selected = {}
    for _, row in ipairs(frame.rows) do
        if row.check:GetChecked() then
            selected[row.canon] = true
            selected[row.folder] = true
        end
    end

    local isPartial = false
    if filtered.data.addons then
        for folder in pairs(filtered.data.addons) do
            if not selected[folder] then
                filtered.data.addons[folder] = nil
                isPartial = true
            end
        end
    end

    if not selected["EllesmereUICooldownManager"] then
        filtered.data.cdmSpells = nil
    end

    -- Keep recipient spec assignments unless they opt into EUI's interactive auto-assign.
    filtered.data.assignedSpecs = nil

    local includeLayout = frame.layoutCheck:GetChecked()
    if filtered.data.unlockLayout then
        if includeLayout and EllesmereUI.FilterLayoutToFolders and EllesmereUI.BuildImportKeyToFolder then
            local ul = filtered.data.unlockLayout
            local meta = filtered.data.unlockLayoutMeta
            local k2f = EllesmereUI.BuildImportKeyToFolder(ul, meta and meta.keyToFolder)
            filtered.data.unlockLayout = EllesmereUI.FilterLayoutToFolders(ul, selected, k2f)
        else
            filtered.data.unlockLayout = nil
            filtered.data.layoutExcluded = true
        end
    end
    filtered.data.unlockLayoutMeta = nil

    if isPartial then
        filtered.data.partialImport = true
    end

    local ok, err = EllesmereUI.ImportProfile(filtered, session.profileName)
    if not ok then
        TUI:Print("EllesmereUI import failed: " .. tostring(err or "unknown error"))
        return
    end

    if EllesmereUIDB and session.scale then
        EllesmereUIDB.ppUIScale = session.scale
    end

    self:HideEllesmereImportPicker()
    self:MarkAsRecentlyInstalled("EllesmereUI")

    if session.onDone then
        session.onDone(true)
    end

    -- Restore the Ellesmere step UI (resolution picker) so the panel is not blank.
    if self.currentStep then
        self:GoToStep(self.currentStep)
    end

    if self.desc3 then
        self.desc3:SetText("|cff66ff66Import successful!|r Click Continue for the next step.")
        self.desc3:Show()
    end

    self:RefreshAllStepButtons()
    TUI:Print("EllesmereUI profile imported successfully.")
end

function TOSUIInstaller:CreateCompatibilityLayer()
    local proxy = {
        Title = self.subtitle,
        SubTitle = self.subtitle,
        Desc1 = self.desc1,
        Desc2 = self.desc2,
        Desc3 = self.desc3,
        Option1 = self.option1,
        Option2 = self.option2,
        Option3 = self.option3,
        Option4 = self.option4,
        Next = self.nextBtn,
        Prev = self.prevBtn,
        Skip = self.skipBtn,
        IsShown = function() return self.frame and self.frame:IsShown() end,
        Show = function() end,
        Hide = function() end,
        ShowTutorialImage = function(imagePath) return self:ShowTutorialImage(imagePath) end,
        ShowChoiceList = function(_, choices) return self:ShowChoiceList(choices) end,
        SetFrameStrata = function(_, strata)
            if self.frame then self.frame:SetFrameStrata(strata) end
        end,
    }

    _G.PluginInstallFrame = proxy
    _G.TOSUIInstallFrame = proxy
end

local installerFrame = TOSUIInstaller
installerFrame:CreateFrame()
installerFrame:CreateCompatibilityLayer()

_G.TOSUIInstaller = installerFrame
