local _, ns = ...
local E, C, D, L = ns.E, ns.C, ns.D, ns.L

-- Lua
local _G = getfenv(0)
local hooksecurefunc = _G.hooksecurefunc
local next = _G.next

-- Mine
-- BUG: Blizz broke pet battle tab names in 10.x
hooksecurefunc("FCF_SetWindowName", function(frame, name)
	if frame and frame.chatType == "PET_BATTLE_COMBAT_LOG" then
		_G[frame:GetName() .. "Tab"]:SetText(name)
	end
end)

local function chatTab_SetPoint(self, _, anchor, _, _, _, shouldIgnore)
	if anchor == GeneralDockManager.scrollFrame.child and not shouldIgnore then
		self:ClearAllPoints()
		self:SetPoint("BOTTOMLEFT", anchor, "BOTTOMLEFT", 0, 0, true)
	end
end

local function chatTab_OnDragStart(self)
	local frame = E:GetSlidingFrameForChatFrame(_G["ChatFrame" .. self:GetID()])
	if frame then
		frame.isDragging = true
	end
end

-- called from FCFTab_OnUpdate
hooksecurefunc("FCFTab_OnDragStop", function(self)
	local frame = E:GetSlidingFrameForChatFrame(_G["ChatFrame" .. self:GetID()])
	if frame then
		if frame.isMouseOver then
			frame.isMouseOver = nil
		end

		frame.isDragging = nil
	end
end)

local function chatTabText_SetPoint(self, p, anchor, rP, x, y, shouldIgnore)
	if not shouldIgnore then
		self:SetPoint(p, anchor, rP, p == "LEFT" and 8 or x, p == "CENTER" and 0 or y, true)
	end
end

local function chatTabText_SetTextColor(self, r, g, b)
	if r == NORMAL_FONT_COLOR.r and g == NORMAL_FONT_COLOR.g and b == NORMAL_FONT_COLOR.b then
		self:SetTextColor(C.db.global.colors.lanzones:GetRGB())
	end
end

local handledTabs = {}

local TAB_TEXTURES = {
	"leftTexture",
	"middleTexture",
	"rightTexture",
}

function E:HandleChatTab(frame)
	if not handledTabs[frame] then
		frame.Backdrop = E:CreateBackdrop(frame, C.db.profile.dock.alpha)

		hooksecurefunc(frame, "SetPoint", chatTab_SetPoint)
		frame:HookScript("OnDragStart", chatTab_OnDragStart)

		hooksecurefunc(frame.Text, "SetPoint", chatTabText_SetPoint)
		hooksecurefunc(frame.Text, "SetTextColor", chatTabText_SetTextColor)

		handledTabs[frame] = true
	end

	for _, texture in next, TAB_TEXTURES do
		frame[texture]:SetTexture(0)
	end

	frame:SetHeight(20)

	frame.glow:ClearAllPoints()
	frame.glow:SetPoint("BOTTOMLEFT", 8, 2)
	frame.glow:SetPoint("BOTTOMRIGHT", -8, 2)

	frame.leftSelectedTexture:ClearAllPoints()
	frame.leftSelectedTexture:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -2)
	frame.leftSelectedTexture:SetTexture("Interface\\AddOns\\ls_Glass\\assets\\border-highlight")
	frame.leftSelectedTexture:SetTexCoord(0, 1, 0.5, 1)
	frame.leftSelectedTexture:SetSize(8, 8)

	frame.rightSelectedTexture:ClearAllPoints()
	frame.rightSelectedTexture:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, -2)
	frame.rightSelectedTexture:SetTexture("Interface\\AddOns\\ls_Glass\\assets\\border-highlight")
	frame.rightSelectedTexture:SetTexCoord(1, 0, 0.5, 1)
	frame.rightSelectedTexture:SetSize(8, 8)

	frame.middleSelectedTexture:ClearAllPoints()
	frame.middleSelectedTexture:SetPoint("TOPLEFT", frame.leftHighlightTexture, "TOPRIGHT", 0, 0)
	frame.middleSelectedTexture:SetPoint("TOPRIGHT", frame.rightHighlightTexture, "TOPLEFT", 0, 0)
	frame.middleSelectedTexture:SetTexture("Interface\\AddOns\\ls_Glass\\assets\\border-highlight")
	frame.middleSelectedTexture:SetTexCoord(0, 1, 0, 0.5)
	frame.middleSelectedTexture:SetSize(8, 8)

	frame.leftHighlightTexture:ClearAllPoints()
	frame.leftHighlightTexture:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -2)
	frame.leftHighlightTexture:SetTexture("Interface\\AddOns\\ls_Glass\\assets\\border-highlight")
	frame.leftHighlightTexture:SetTexCoord(0, 1, 0.5, 1)
	frame.leftHighlightTexture:SetSize(8, 8)

	frame.rightHighlightTexture:ClearAllPoints()
	frame.rightHighlightTexture:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, -2)
	frame.rightHighlightTexture:SetTexture("Interface\\AddOns\\ls_Glass\\assets\\border-highlight")
	frame.rightHighlightTexture:SetTexCoord(1, 0, 0.5, 1)
	frame.rightHighlightTexture:SetSize(8, 8)

	frame.middleHighlightTexture:ClearAllPoints()
	frame.middleHighlightTexture:SetPoint("TOPLEFT", frame.leftHighlightTexture, "TOPRIGHT", 0, 0)
	frame.middleHighlightTexture:SetPoint("TOPRIGHT", frame.rightHighlightTexture, "TOPLEFT", 0, 0)
	frame.middleHighlightTexture:SetTexture("Interface\\AddOns\\ls_Glass\\assets\\border-highlight")
	frame.middleHighlightTexture:SetTexCoord(0, 1, 0, 0.5)
	frame.middleHighlightTexture:SetSize(8, 8)

	if frame.conversationIcon then
		frame.conversationIcon:SetPoint("RIGHT", frame.Text, "LEFT", 0, 0)
	end

	-- reset the tab
	frame:SetPoint(frame:GetPoint(1))

	if not frame.selectedColorTable then
		frame.Text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	end

	-- it can be "CENTER" or "LEFT", so just use the index
	frame.Text:SetPoint(frame.Text:GetPoint(1))
end

local handledMiniTabs = {}

local MINI_TAB_TEXTURES = {
	"leftTexture",
	"middleTexture",
	"rightTexture",
}

function E:HandleMinimizedTab(frame)
	if not handledMiniTabs[frame] then
		frame.Backdrop = E:CreateBackdrop(frame, C.db.profile.dock.alpha)

		E:HandleMaximizeButton(_G[frame:GetName() .. "MaximizeButton"])

		hooksecurefunc(frame.Text, "SetTextColor", chatTabText_SetTextColor)

		handledMiniTabs[frame] = true
	end

	for _, texture in next, MINI_TAB_TEXTURES do
		frame[texture]:SetTexture(0)
	end

	frame:SetHeight(20)

	frame.glow:ClearAllPoints()
	frame.glow:SetPoint("BOTTOMLEFT", 8, 2)
	frame.glow:SetPoint("BOTTOMRIGHT", -24, 2)

	frame.leftHighlightTexture:ClearAllPoints()
	frame.leftHighlightTexture:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -2)
	frame.leftHighlightTexture:SetTexture("Interface\\AddOns\\ls_Glass\\assets\\border-highlight")
	frame.leftHighlightTexture:SetTexCoord(0, 1, 0.5, 1)
	frame.leftHighlightTexture:SetSize(8, 8)

	frame.rightHighlightTexture:ClearAllPoints()
	frame.rightHighlightTexture:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, -2)
	frame.rightHighlightTexture:SetTexture("Interface\\AddOns\\ls_Glass\\assets\\border-highlight")
	frame.rightHighlightTexture:SetTexCoord(1, 0, 0.5, 1)
	frame.rightHighlightTexture:SetSize(8, 8)

	frame.middleHighlightTexture:ClearAllPoints()
	frame.middleHighlightTexture:SetPoint("TOPLEFT", frame.leftHighlightTexture, "TOPRIGHT", 0, 0)
	frame.middleHighlightTexture:SetPoint("TOPRIGHT", frame.rightHighlightTexture, "TOPLEFT", 0, 0)
	frame.middleHighlightTexture:SetTexture("Interface\\AddOns\\ls_Glass\\assets\\border-highlight")
	frame.middleHighlightTexture:SetTexCoord(0, 1, 0, 0.5)
	frame.middleHighlightTexture:SetSize(8, 8)

	-- reset the tab
	if not frame.selectedColorTable then
		frame.Text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	end

	frame.conversationIcon:SetPoint("RIGHT", frame.Text, "LEFT", 0, 0)
end

function E:UpdateTabAlpha()
	local alpha = C.db.profile.dock.alpha

	for tab in next, handledTabs do
		tab.Backdrop:UpdateAlpha(alpha)
	end
end
