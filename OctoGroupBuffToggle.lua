-- Octo Group Buff Toggle - OctoWoW / Vanilla 1.12

local MAX_MEMBERS = 4
local MAX_BUFFS = 16
local ICON_SIZE = 20
local ICON_GAP = 2
local ICONS_PER_ROW = 8
local buffFrames = {}
local updateElapsed = 0
local targetBuffFrame

local function BuffsEnabled()
    return OctoGroupBuffsDB and OctoGroupBuffsDB.enabled == true
end

local function TargetBuffsEnabled()
    return OctoGroupBuffsDB and OctoGroupBuffsDB.targetEnabled == true
end

local function HideMemberBuffs(member)
    local container = buffFrames[member]
    if not container then return end
    local index
    for index = 1, MAX_BUFFS do container.buttons[index]:Hide() end
    container:Hide()
end

local function BuffOnEnter()
    if not this.unit or not this.buffIndex then return end
    GameTooltip:SetOwner(this, "ANCHOR_RIGHT")
    GameTooltip:SetUnitBuff(this.unit, this.buffIndex)
end

local function CreateMemberBuffs(member)
    local partyFrame = getglobal("PartyMemberFrame" .. member)
    if not partyFrame then return nil end

    local container = CreateFrame("Frame", "OctoGroupBuffsMember" .. member, UIParent)
    container:SetWidth(ICONS_PER_ROW * (ICON_SIZE + ICON_GAP))
    container:SetHeight(2 * (ICON_SIZE + ICON_GAP))
    container:SetPoint("TOPLEFT", partyFrame, "TOPRIGHT", 8, -4)
    container.buttons = {}

    local index
    for index = 1, MAX_BUFFS do
        local button = CreateFrame("Button", "OctoGroupBuffButton" .. member .. "_" .. index, container)
        button:SetWidth(ICON_SIZE)
        button:SetHeight(ICON_SIZE)
        local column = math.mod(index - 1, ICONS_PER_ROW)
        local row = math.floor((index - 1) / ICONS_PER_ROW)
        button:SetPoint("TOPLEFT", container, "TOPLEFT",
            column * (ICON_SIZE + ICON_GAP), -row * (ICON_SIZE + ICON_GAP))

        button.icon = button:CreateTexture(nil, "ARTWORK")
        button.icon:SetAllPoints(button)
        button.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
        button.border = button:CreateTexture(nil, "OVERLAY")
        button.border:SetTexture("Interface\\Buttons\\UI-Debuff-Overlays")
        button.border:SetAllPoints(button)
        button.border:SetTexCoord(0.296875, 0.5703125, 0, 0.515625)
        button.border:SetVertexColor(0.65, 0.65, 0.65)
        button:SetScript("OnEnter", BuffOnEnter)
        button:SetScript("OnLeave", function() GameTooltip:Hide() end)
        container.buttons[index] = button
    end

    buffFrames[member] = container
    return container
end

local function CreateTargetBuffs()
    if targetBuffFrame or not TargetFrame then return end
    targetBuffFrame = CreateFrame("Frame", "OctoTargetBuffs", UIParent)
    targetBuffFrame:SetWidth(ICONS_PER_ROW * (ICON_SIZE + ICON_GAP))
    targetBuffFrame:SetHeight(2 * (ICON_SIZE + ICON_GAP))
    targetBuffFrame:SetPoint("TOPLEFT", TargetFrame, "TOPRIGHT", 38, -18)
    targetBuffFrame.buttons = {}

    local index
    for index = 1, MAX_BUFFS do
        local button = CreateFrame("Button", "OctoTargetBuffButton" .. index, targetBuffFrame)
        button:SetWidth(ICON_SIZE)
        button:SetHeight(ICON_SIZE)
        local column = math.mod(index - 1, ICONS_PER_ROW)
        local row = math.floor((index - 1) / ICONS_PER_ROW)
        button:SetPoint("TOPLEFT", targetBuffFrame, "TOPLEFT",
            column * (ICON_SIZE + ICON_GAP), -row * (ICON_SIZE + ICON_GAP))
        button.icon = button:CreateTexture(nil, "ARTWORK")
        button.icon:SetAllPoints(button)
        button.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
        button.border = button:CreateTexture(nil, "OVERLAY")
        button.border:SetTexture("Interface\\Buttons\\UI-Debuff-Overlays")
        button.border:SetAllPoints(button)
        button.border:SetTexCoord(0.296875, 0.5703125, 0, 0.515625)
        button.border:SetVertexColor(0.65, 0.65, 0.65)
        button.unit = "target"
        button.buffIndex = index
        button:SetScript("OnEnter", BuffOnEnter)
        button:SetScript("OnLeave", function() GameTooltip:Hide() end)
        targetBuffFrame.buttons[index] = button
    end
end

local function UpdateTargetBuffs()
    CreateTargetBuffs()
    if not targetBuffFrame then return end
    if OctoTargetBuffsCheckButton then
        OctoTargetBuffsCheckButton:ClearAllPoints()
        OctoTargetBuffsCheckButton:SetPoint("LEFT", TargetFrame, "RIGHT", 4, -38)
        if UnitExists("target") and TargetFrame:IsShown() then
            OctoTargetBuffsCheckButton:Show()
        else
            OctoTargetBuffsCheckButton:Hide()
        end
    end
    targetBuffFrame:ClearAllPoints()
    targetBuffFrame:SetPoint("TOPLEFT", TargetFrame, "TOPRIGHT", 38, -18)
    if not TargetBuffsEnabled() or not UnitExists("target") or not TargetFrame:IsShown() then
        local index
        for index = 1, MAX_BUFFS do targetBuffFrame.buttons[index]:Hide() end
        targetBuffFrame:Hide()
        return
    end

    targetBuffFrame:Show()
    local index
    for index = 1, MAX_BUFFS do
        local texture = UnitBuff("target", index)
        local button = targetBuffFrame.buttons[index]
        if texture then button.icon:SetTexture(texture); button:Show() else button:Hide() end
    end
end

local function UpdateMember(member)
    local unit = "party" .. member
    local partyFrame = getglobal("PartyMemberFrame" .. member)
    local container = buffFrames[member] or CreateMemberBuffs(member)
    if not container then return end

    container:ClearAllPoints()
    container:SetPoint("TOPLEFT", partyFrame, "TOPRIGHT", 8, -4)
    if not BuffsEnabled() or not UnitExists(unit) or not partyFrame:IsShown() then
        HideMemberBuffs(member)
        return
    end

    container:Show()
    local index
    for index = 1, MAX_BUFFS do
        local texture, applications = UnitBuff(unit, index)
        local button = container.buttons[index]
        if texture then
            button.unit = unit
            button.buffIndex = index
            button.icon:SetTexture(texture)
            button:Show()
        else
            button:Hide()
        end
    end
end

local function UpdateCheckboxPosition()
    if not OctoGroupBuffsCheckButton then return end
    local anchor
    local member
    for member = MAX_MEMBERS, 1, -1 do
        local frame = getglobal("PartyMemberFrame" .. member)
        if frame and frame:IsShown() and UnitExists("party" .. member) then
            anchor = frame
            break
        end
    end

    OctoGroupBuffsCheckButton:ClearAllPoints()
    if anchor then
        OctoGroupBuffsCheckButton:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 4, -6)
        OctoGroupBuffsCheckButton:Show()
    else
        OctoGroupBuffsCheckButton:Hide()
    end
end

local function UpdateAll()
    local member
    for member = 1, MAX_MEMBERS do UpdateMember(member) end
    UpdateCheckboxPosition()
    UpdateTargetBuffs()
end

local function CreateCheckbox()
    if OctoGroupBuffsCheckButton then return end
    local checkbox = CreateFrame("CheckButton", "OctoGroupBuffsCheckButton", UIParent, "UICheckButtonTemplate")
    checkbox:SetWidth(24)
    checkbox:SetHeight(24)
    getglobal(checkbox:GetName() .. "Text"):SetText("Buffs")
    checkbox:SetChecked(BuffsEnabled())
    checkbox:SetScript("OnClick", function()
        OctoGroupBuffsDB.enabled = this:GetChecked() and true or false
        UpdateAll()
    end)
    checkbox:SetScript("OnEnter", function()
        GameTooltip:SetOwner(this, "ANCHOR_RIGHT")
        GameTooltip:SetText("Group Buffs")
        GameTooltip:AddLine("Show party-member buffs beside the group frames.", 1, 1, 1, 1)
        GameTooltip:Show()
    end)
    checkbox:SetScript("OnLeave", function() GameTooltip:Hide() end)

    local targetCheckbox = CreateFrame("CheckButton", "OctoTargetBuffsCheckButton", UIParent, "UICheckButtonTemplate")
    targetCheckbox:SetWidth(24)
    targetCheckbox:SetHeight(24)
    targetCheckbox:SetPoint("LEFT", TargetFrame, "RIGHT", 4, -38)
    getglobal(targetCheckbox:GetName() .. "Text"):SetText("Buffs")
    targetCheckbox:SetChecked(TargetBuffsEnabled())
    targetCheckbox:SetScript("OnClick", function()
        OctoGroupBuffsDB.targetEnabled = this:GetChecked() and true or false
        UpdateTargetBuffs()
    end)
    targetCheckbox:SetScript("OnEnter", function()
        GameTooltip:SetOwner(this, "ANCHOR_RIGHT")
        GameTooltip:SetText("Target Buffs")
        GameTooltip:AddLine("Show buffs beside the target frame.", 1, 1, 1, 1)
        GameTooltip:Show()
    end)
    targetCheckbox:SetScript("OnLeave", function() GameTooltip:Hide() end)
end

local events = CreateFrame("Frame")
events:RegisterEvent("VARIABLES_LOADED")
events:RegisterEvent("PLAYER_ENTERING_WORLD")
events:RegisterEvent("PARTY_MEMBERS_CHANGED")
events:RegisterEvent("UNIT_AURA")
events:SetScript("OnEvent", function()
    if event == "VARIABLES_LOADED" then
        OctoGroupBuffsDB = OctoGroupBuffsDB or {}
        if OctoGroupBuffsDB.enabled == nil then OctoGroupBuffsDB.enabled = false end
        if OctoGroupBuffsDB.targetEnabled == nil then OctoGroupBuffsDB.targetEnabled = false end
        CreateCheckbox()
    end
    UpdateAll()
end)
events:SetScript("OnUpdate", function()
    updateElapsed = updateElapsed + arg1
    if updateElapsed >= 0.5 then
        updateElapsed = 0
        UpdateAll()
    end
end)

SLASH_OCTOGROUPBUFFS1 = "/groupbuffs"
SlashCmdList["OCTOGROUPBUFFS"] = function()
    OctoGroupBuffsDB = OctoGroupBuffsDB or {}
    OctoGroupBuffsDB.enabled = not BuffsEnabled()
    if OctoGroupBuffsCheckButton then OctoGroupBuffsCheckButton:SetChecked(BuffsEnabled()) end
    UpdateAll()
end
