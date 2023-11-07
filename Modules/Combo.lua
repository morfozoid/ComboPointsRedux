--[[
Author: Starinnia
CPR is a combo points display addon based on Funkydude's BasicComboPoints
Combo.lua - A module for tracking combo points
Last File Hash: @file-abbreviated-hash@
Last File Date: @file-date-iso@
Project Version: @project-version@
contact: codemaster2010 AT gmail DOT com

Copyright (c) 2007-2017 Michael J. Murray aka Lyte of Lothar(US)
All rights reserved unless otherwise explicitly stated.
]]

local GetComboPoints = GetComboPoints
local UnitHasVehicleUI = UnitHasVehicleUI
local UnitPower = UnitPower
local SPELL_POWER_COMBO_POINTS = Enum.PowerType.ComboPoints

local cpr = LibStub("AceAddon-3.0"):GetAddon("ComboPointsRedux")
local modName = "Combo Points"
local mod = cpr:NewModule(modName)

function mod:OnInitialize()
	self.abbrev = "CP"
	self.MAX_POINTS = UnitPowerMax("player",Enum.PowerType.ComboPoints)
	self.Count = UnitPower("player", SPELL_POWER_COMBO_POINTS)
	self.displayName = COMBAT_TEXT_SHOW_COMBO_POINTS_TEXT
	self.events = { ["UNIT_POWER_UPDATE"] = "Update", ["SPELLS_CHANGED"] = "UpdateMaxPoints", ["PLAYER_SPECIALIZATION_CHANGED"] = "UpdateMaxPoints", ["PLAYER_LOGIN"] = "UpdateMaxPoints" }
end

function mod:OnModuleEnable()
	self:RegisterEvent("UPDATE_SHAPESHIFT_FORM", "OnShapeshift")
end

local oldPoints = 0
function mod:Update()
	self.Count = UnitPower("player", SPELL_POWER_COMBO_POINTS) or 0
	local r, g, b = cpr:GetColorByPoints(modName, self.Count)
	local a, a2 = cpr:GetAlphas(modName)
	
	if self.Count > 0 then
		if self.graphics then
			--6.0.2 bug?/feature, there is no zero event between spending CPs
			--and Anticipation stacks filling CPs
			--so, hide all the points before showing the appropriate number
			for i = 1, self.MAX_POINTS do
				self.graphics.points[i]:SetAlpha(a2)
				self.graphics.points[i].icon:SetVertexColor(r, g, b)
			end
			for j = self.Count, 1, -1 do
				self.graphics.points[j].icon:SetVertexColor(r, g, b)
				self.graphics.points[j]:SetAlpha(a)
			end
		end
		
		--should prevent spamming issues if a generator ability is used
		--when the player is at 5 points and has the threshold at 5
		if oldPoints ~= self.Count then
			oldPoints = self.Count
			cpr:DoFlash(modName, self.Count)
		end
	else
		if self.graphics then
			for i = 1, self.MAX_POINTS do
				self.graphics.points[i].icon:SetVertexColor(r, g, b)
				self.graphics.points[i]:SetAlpha(a2)
			end
		end
		points = ""
		oldPoints = 0
	end
	if self.text then self.text:SetNumPoints(cpr:GetTextValue(modName, self.Count)) end
end

function mod:UpdateMaxPoints()
	self.Count = UnitPower("player", SPELL_POWER_COMBO_POINTS)
	local a, a2 = cpr:GetAlphas(modName)
	self.MAX_POINTS = UnitPowerMax("player",Enum.PowerType.ComboPoints)
	if self.graphics then
		for i = 1, self.MAX_POINTS do
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
	
function mod:OnShapeshift()
	local form = GetShapeshiftForm(true)
	
	if cpr.db.profile.modules[modName].hideOutCat then
		--if we only show combo points in cat form...
		if form == 2 then
			if self.text then self.text:Show() end
			if self.graphics then self.graphics:Show() end
		else
			if self.text then self.text:Hide() end
			if self.graphics then self.graphics:Hide() end
		end
	end
end
