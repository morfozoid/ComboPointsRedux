--[[
Author: Starinnia
CPR is a combo points display addon based on Funkydude's BasicComboPoints
Embers.lua - A module for tracking Burning Embers
$Date: 2013-03-21 17:38:17 -0500 (Thu, 21 Mar 2013) $
$Revision: 312 $
Project Version: @project-version@
contact: codemaster2010 AT gmail DOT com

Copyright (c) 2007-2012 Michael J. Murray aka Lyte of Lothar(US)
All rights reserved unless otherwise explicitly stated.
]]

if select(2, UnitClass("player")) ~= "WARLOCK" then return end

local UnitPower = UnitPower
local SPELL_POWER_BURNING_EMBERS = SPELL_POWER_BURNING_EMBERS
local MAX_POWER_PER_EMBER = MAX_POWER_PER_EMBER
local ceil = math.ceil

local cpr = LibStub("AceAddon-3.0"):GetAddon("ComboPointsRedux")
local modName = "Burning Embers"
local mod = cpr:NewModule(modName)
local FILE_HEIGHT = 32 --all icon files are 32 tall

function mod:OnInitialize()
	self.MAX_POINTS = 4
	self.displayName = GetSpellInfo(116854)
	self.abbrev = "BE"
	self.events = { ["UNIT_POWER"] = "Update", ["UNIT_DISPLAYPOWER"] = "Update" }
end

function mod:OnModuleEnable()
	self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED", "OnSpecChange")
	self:OnSpecChange(nil, "player")
end

--determines the textCoords to show a fractional power value
--and handles showing and hiding the icon
local function fractionalFill(point, power, maxPer)
	local db = cpr.db.profile.modules[modName]
	local icon = point.icon
	
	if power <= 0 then
		point:Hide()
	elseif power >= maxPer then
		icon:SetTexCoord(0, 1, 0, 1) --show the uncut image
		point:SetHeight(25*db.scale)
		point:Show()
	else
		--set fractional texture coords
		local texHeight = (power / maxPer) * (25*db.scale)
		local top = 1 - (texHeight / FILE_HEIGHT)
		icon:SetTexCoord(0, 1, top, 1)
		point:SetHeight(texHeight)
		point:Show()
	end
end

local oldCount = 0
function mod:Update()
	--third param for fractional values
	--this will return values from 0 to 40 (10 power per ember)
	local power = UnitPower("player", SPELL_POWER_BURNING_EMBERS, true)
	
	if power > 0 then
		if self.graphics then
			local p = power
			local r, g, b = cpr:GetColorByPoints(modName, ceil(power / MAX_POWER_PER_EMBER))
			for i = 1, self.MAX_POINTS do
				self.graphics.points[i].icon:SetVertexColor(r, g, b)
				fractionalFill(self.graphics.points[i], p, MAX_POWER_PER_EMBER)
				--left over for the next point
				p = p - MAX_POWER_PER_EMBER
			end
		end
		
		if self.text then self.text:SetNumPoints(format('%.1f', power / MAX_POWER_PER_EMBER)) end
		
		--should prevent spamming issues when UNIT_AURA fires and
		--the aura we care about hasn't changed
		if oldCount ~= power then
			oldCount = power
			cpr:DoFlash(modName, power)
		end
	else
		if self.graphics then
			for i = 1, self.MAX_POINTS do
				self.graphics.points[i]:Hide()
			end
		end
		if self.text then self.text:SetNumPoints("") end
		
		oldCount = 0
	end
end

function mod:OnSpecChange(_, unit)
	if unit ~= "player" then return end
	
	local spec = GetSpecialization()
	
	if spec == 3 then
		if not cpr.db.profile.modules[modName].hideOOC or InCombatLockdown() then
			--3 is destruction
			if self.text then self.text:Show() end
			if self.graphics then self.graphics:Show() end
		end
	else
		if self.text then self.text:Hide() end
		if self.graphics then self.graphics:Hide() end
	end
end
