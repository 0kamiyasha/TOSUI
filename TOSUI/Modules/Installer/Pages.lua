local TUI = unpack(TOSUI)
local I = TUI:GetModule("Installer")
local SE = TUI:GetModule("Setup")

local function ShowResolutionChoices(addon, baseKey)
    local options = SE.GetAvailableResolutionOptions(baseKey)
    if #options == 0 then
        TOSUIInstallFrame.Desc1:SetText("No profiles are packaged for this step yet.")
        return
    end

    local choices = {}
    for _, opt in ipairs(options) do
        local suffix = opt.suffix ~= "" and opt.suffix or nil
        choices[#choices + 1] = {
            label = opt.label,
            onClick = function()
                SE:Setup(addon, true, suffix)
            end,
        }
    end

    if TOSUIInstallFrame.ShowChoiceList then
        TOSUIInstallFrame:ShowChoiceList(choices)
        return
    end

    TOSUIInstallFrame.Option1:Show()
    TOSUIInstallFrame.Option1:SetText(choices[1].label)
    TOSUIInstallFrame.Option1:SetScript("OnClick", choices[1].onClick)
    if choices[2] then
        TOSUIInstallFrame.Option2:Show()
        TOSUIInstallFrame.Option2:SetText(choices[2].label)
        TOSUIInstallFrame.Option2:SetScript("OnClick", choices[2].onClick)
    end
end

I.installer = {
    Title = "TOSUI Installation",
    Name = "TOSUI",
    tutorialImage = "Interface\\AddOns\\TOSUI\\Media\\Textures\\LogoTOSUI.tga",
    Pages = {
        [1] = function()
            TOSUIInstallFrame.SubTitle:SetFormattedText("Welcome to %s", TUI.title)

            if not TUI.db.global.profiles then
                TOSUIInstallFrame.Desc1:SetText("To start the installation process, click on 'Continue'")

                return
            end

            TOSUIInstallFrame.Desc2:SetText("To load your installed profiles onto this character, click on 'Load Profiles'")
            TOSUIInstallFrame.Desc3:SetText("To start the installation process again, click on 'Continue'")
            TOSUIInstallFrame.Option1:Show()
            TOSUIInstallFrame.Option1:SetScript("OnClick", function() TUI:LoadProfiles() end)
            TOSUIInstallFrame.Option1:SetText("Load Profiles")
        end,
        [2] = function()
            TOSUIInstallFrame.SubTitle:SetText("EllesmereUI")

            if not TUI:IsAddOnEnabled("EllesmereUI") then
                TOSUIInstallFrame.Desc1:SetText("Enable EllesmereUI to unlock this step")

                return
            end

            local options = SE.GetAvailableEllesmereOptions and SE.GetAvailableEllesmereOptions() or {}
            if #options == 0 then
                TOSUIInstallFrame.Desc1:SetText("No EllesmereUI profiles are packaged yet.")
                return
            end

            TOSUIInstallFrame.Desc2:SetText("Pick a profile, then Setup. You'll choose which EllesmereUI modules to import here (everything is checked by default).")

            local choices = {}
            for _, opt in ipairs(options) do
                choices[#choices + 1] = {
                    label = opt.label,
                    onClick = function()
                        SE:Setup("EllesmereUI", opt.key)
                    end,
                }
            end

            if TOSUIInstallFrame.ShowChoiceList then
                TOSUIInstallFrame:ShowChoiceList(choices)
            else
                -- Fallback for older installer frames: first two options only.
                TOSUIInstallFrame.Option1:Show()
                TOSUIInstallFrame.Option1:SetText(choices[1].label)
                TOSUIInstallFrame.Option1:SetScript("OnClick", choices[1].onClick)
                if choices[2] then
                    TOSUIInstallFrame.Option2:Show()
                    TOSUIInstallFrame.Option2:SetText(choices[2].label)
                    TOSUIInstallFrame.Option2:SetScript("OnClick", choices[2].onClick)
                end
            end
        end,
        [3] = function()
            TOSUIInstallFrame.SubTitle:SetText("BigWigs")

            if not TUI:IsAddOnEnabled("BigWigs") then
                TOSUIInstallFrame.Desc1:SetText("Enable BigWigs to unlock this step")

                return
            end

            TOSUIInstallFrame.Desc2:SetText("Pick a resolution, then Setup.")
            ShowResolutionChoices("BigWigs", "bigwigs")
        end,
        [4] = function()
            TOSUIInstallFrame.SubTitle:SetText("Blizzard_EditMode")
            TOSUIInstallFrame.Desc2:SetText("Pick a resolution, then Setup.")
            ShowResolutionChoices("Blizzard_EditMode", "blizzardeditmode")
        end,
        [5] = function()
            TOSUIInstallFrame.SubTitle:SetText("MRT")

            if not TUI:IsAddOnEnabled("MRT") then
                TOSUIInstallFrame.Desc1:SetText("Enable MRT to unlock this step")

                return
            end

            TOSUIInstallFrame.Desc2:SetText("Pick a resolution, then Setup.")
            ShowResolutionChoices("MRT", "mrt")
        end,
        [6] = function()
            local color = C_ClassColor.GetClassColor(TUI.myclass)
            local hex = color:GenerateHexColorMarkup()
            local class = strlower(TUI.myclass)

            TOSUIInstallFrame.SubTitle:SetText("Class Layout")

            if C_CVar.GetCVar("cooldownViewerEnabled") == "0" then
                TOSUIInstallFrame.Desc1:SetText("Enable the Cooldown Manager to unlock this step")

                return
            end

            TOSUIInstallFrame.Desc2:SetText("Click on the button below to setup your Class Layout")
            TOSUIInstallFrame.Desc3:SetFormattedText("Your class: %s%s%s", hex, TUI.myLocalizedClass, "|r")
            TOSUIInstallFrame.Option1:Show()
            TOSUIInstallFrame.Option1:SetScript("OnClick", function() SE:Setup("Blizzard_CooldownViewer", class) end)
            TOSUIInstallFrame.Option1:SetText("Setup Class Layout")
        end,
        [7] = function()
            TOSUIInstallFrame.SubTitle:SetText("Installation Complete")
            TOSUIInstallFrame.Desc1:SetText("You have completed the installation process")
            TOSUIInstallFrame.Desc2:SetText("Please click on 'Reload' to save your settings and reload your UI")
            TOSUIInstallFrame.Option1:Show()
            TOSUIInstallFrame.Option1:SetScript("OnClick", function() ReloadUI() end)
            TOSUIInstallFrame.Option1:SetText("Reload")
        end
    },
    StepTitles = {
        [1] = "Welcome",
        [2] = "EllesmereUI",
        [3] = "BigWigs",
        [4] = "Blizzard_EditMode",
        [5] = "MRT",
        [6] = "Class Layout",
        [7] = "Installation Complete"
    },
    StepTitlesColorSelected = {155/255, 77/255, 255/255},
    StepTitleWidth = 200,
    StepTitleButtonWidth = 180,
    StepTitleTextJustification = "RIGHT"
}
