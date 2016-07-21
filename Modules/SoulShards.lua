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
	self.MAX_POINTS = 4
	self.displayName = SOUL_SHARDS_POWER
	self.abbrev = "SS"
	self.events = { ["UNIT_POWER"] = "Update", ["UNIT_DISPLAYPOWER"] = "Update" }
end

function mod:OnModuleEnable()
	self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED", "OnSpecChange")
	self:OnSpecChange(nil, "player")
end

local oldCount = 0
function mod:Update()
	local count = UnitPower("player", SPELL_POWER_SOUL_SHARDS)
	
	if count > 0 then
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

function mod:OnSpecChange(_, unit)
	if unit ~= "player" then return end
	
	local spec = GetSpecialization()
	
	if spec == 1 then
		if not cpr.db.profile.modules[modName].hideOOC or UnitAffectingCombat("player") then
			--1 is affliction
			if self.text then self.text:Show() end
			if self.graphics then self.graphics:Show() end
		end
	else
		if self.text then self.text:Hide() end
		if self.graphics then self.graphics:Hide() end
	end
end
