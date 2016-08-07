--[[
Author: Starinnia
CPR is a combo points display addon based on Funkydude's BasicComboPoints
Chi.lua - A module for tracking Chi (Light Force)
$Date: 2012-07-10 17:02:06 -0500 (Tue, 10 Jul 2012) $
$Revision: 250 $
Project Version: @project-version@
contact: codemaster2010 AT gmail DOT com

Copyright (c) 2007-2012 Michael J. Murray aka Lyte of Lothar(US)
All rights reserved unless otherwise explicitly stated.
]]

if select(2, UnitClass("player")) ~= "MONK" then return end

local UnitPower = UnitPower

local cpr = LibStub("AceAddon-3.0"):GetAddon("ComboPointsRedux")
local modName = "Chi"
local mod = cpr:NewModule(modName)

function mod:OnInitialize()
	if GetSpecialization() == 3 then
		self.MAX_POINTS = 5
	else
		self.MAX_POINTS = 0
	end
	self.Count = UnitPower("player", SPELL_POWER_CHI)
	self.displayName = CHI_POWER
	self.abbrev = "Chi"
	self.events = { ["UNIT_POWER"] = "Update", ["UNIT_DISPLAYPOWER"] = "Update", ["PLAYER_SPECIALIZATION_CHANGED"] = "UpdateMaxPoints", ["PLAYER_LOGIN"] = "UpdateMaxPoints" }
end

local oldCount = 0
function mod:Update()
	self.Count = UnitPower("player", SPELL_POWER_CHI)
	local CountForColor = 1
	if self.Count > 0 then
		local CountForColor = self.Count
	end
	local r, g, b = cpr:GetColorByPoints(modName, CountForColor)
	local a, a2 = cpr:GetAlphas(modName)
	
	if self.Count > 0 then
		if self.graphics then
			local r, g, b = cpr:GetColorByPoints(modName, self.Count)
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

function mod:UpdateMaxPoints()
	self.Count = UnitPower("player", SPELL_POWER_CHI)
	local a, a2 = cpr:GetAlphas(modName)
	
	if GetSpecialization() == 3 then
		self.MAX_POINTS = 5
	else
		self.MAX_POINTS = 0
	end
	if self.graphics then
		for i = 1, 8 do
			self.graphics.points[i]:Hide()
			self.graphics.points[i]:SetAlpha(a2)
		end
		if self.MAX_POINTS > 0 then
			for i = 1, self.MAX_POINTS do
				self.graphics.points[i]:Show()
			end
			if self.Count > 0 then
				for i = 1, self.Count do
					self.graphics.points[i]:SetAlpha(a)
				end
			end
		end
	end	
	cpr:UpdateSettings(modName)
end
