--[[
Author: Starinnia
CPR is a combo points display addon based on Funkydude's BasicComboPoints
Arcane.lua - A module for tracking Arcane Charge debuff stacks
$Date: 2012-09-02 13:41:27 -0500 (Sun, 02 Sep 2012) $
$Revision: 278 $
Project Version: @project-version@
contact: codemaster2010 AT gmail DOT com

Copyright (c) 2007-2012 Michael J. Murray aka Lyte of Lothar(US)
All rights reserved unless otherwise explicitly stated.
]]

if select(2, UnitClass("player")) ~= "MAGE" then return end

local UnitPower = UnitPower
local SPELL_POWER_ARCANE_CHARGES = SPELL_POWER_ARCANE_CHARGES

local cpr = LibStub("AceAddon-3.0"):GetAddon("ComboPointsRedux")
local modName = "Arcane Blast"
local mod = cpr:NewModule(modName)
local buff = GetSpellInfo(36032)

function mod:OnInitialize()
	self.abbrev = "AC"
	self.MAX_POINTS = 4
	self.displayName = buff
	self.events = { ["UNIT_POWER"] = "Update", ["UNIT_DISPLAYPOWER"] = "Update" }
end

local oldCount = 0
function mod:Update()
	local count = UnitPower("player", SPELL_POWER_ARCANE_CHARGES)
    
	if count then
		if self.graphics then
			local r, g, b = cpr:GetColorByPoints(modName, count)
			for i = count, 1, -1 do
				self.graphics.points[i].icon:SetVertexColor(r, g, b)
				self.graphics.points[i]:Show()
			end
			for j = self.MAX_POINTS, count+1, -1 do
				self.graphics.points[j]:Hide()
			end
		end
		if self.text then self.text:SetNumPoints(count) end
		
		--should prevent spamming issues when UNIT_AURA fires and
		--the aura we care about hasn't changed
		if oldCount ~= count then
			oldCount = count
			cpr:DoFlash(modName, count)
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
