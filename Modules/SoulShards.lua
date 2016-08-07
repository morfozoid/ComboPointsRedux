--[[
Author: Starinnia
CPR is a combo points display addon based on Funkydude's BasicComboPoints
SoulShards.lua - A module for tracking Soul Shards
$Date: 2012-12-06 13:38:15 -0600 (Thu, 06 Dec 2012) $
$Revision: 303 $
Project Version: @project-version@
contact: codemaster2010 AT gmail DOT com

Copyright (c) 2007-2012 Michael J. Murray aka Lyte of Lothar(US)
All rights reserved unless otherwise explicitly stated.
]]

if select(2, UnitClass("player")) ~= "WARLOCK" then return end

local UnitPower = UnitPower
local SPELL_POWER_SOUL_SHARDS = SPELL_POWER_SOUL_SHARDS

local cpr = LibStub("AceAddon-3.0"):GetAddon("ComboPointsRedux")
local modName = "Soul Shards"
local mod = cpr:NewModule(modName)

function mod:OnInitialize()
	self.MAX_POINTS = 5
	self.Count = UnitPower("player", SPELL_POWER_SOUL_SHARDS)
	self.displayName = SOUL_SHARDS_POWER
	self.abbrev = "SS"
	self.events = { ["UNIT_POWER"] = "Update", ["UNIT_DISPLAYPOWER"] = "Update" }
end

local oldCount = 0
function mod:Update()
	self.Count = UnitPower("player", SPELL_POWER_SOUL_SHARDS)
	local CountForColor = 1
	if self.Count > 0 then
		CountForColor = self.Count
	end
	local r, g, b = cpr:GetColorByPoints(modName, CountForColor)
	local a, a2 = cpr:GetAlphas(modName)
	
	if self.Count > 0 then
		if self.graphics then
			for i = self.Count, 1, -1 do
				self.graphics.points[i].icon:SetVertexColor(r, g, b)
				self.graphics.points[i]:SetAlpha(a)
				self.graphics.points[i]:Show()
			end
			for j = self.MAX_POINTS, self.Count+1, -1 do
				self.graphics.points[j].icon:SetVertexColor(r, g, b)
				self.graphics.points[j]:SetAlpha(a2)
				self.graphics.points[j]:Show()
			end
		end
		if self.text then self.text:SetNumPoints(self.Count) end
		
		--should prevent spamming issues when UNIT_AURA fires and
		--the aura we care about hasn't changed
		if oldCount ~= self.Count then
			oldCount = self.Count
			cpr:DoFlash(modName, self.Count)
		end
	else
		if self.graphics then
			for i = 1, self.MAX_POINTS do
				self.graphics.points[i].icon:SetVertexColor(r, g, b)
				self.graphics.points[i]:SetAlpha(a2)
				self.graphics.points[i]:Show()
			end
		end
		if self.text then self.text:SetNumPoints("") end
		
		oldCount = 0
	end
end
