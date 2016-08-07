--[[
Author: Starinnia
CPR is a combo points display addon based on Funkydude's BasicComboPoints
Combo.lua - A module for tracking combo points
$Date: 2016-07-20 19:55:36 -0500 (Wed, 20 Jul 2016) $
$Revision: 384 $
Project Version: @project-version@
contact: codemaster2010 AT gmail DOT com

Copyright (c) 2007-2012 Michael J. Murray aka Lyte of Lothar(US)
All rights reserved unless otherwise explicitly stated.
]]

local GetComboPoints = GetComboPoints
local UnitHasVehicleUI = UnitHasVehicleUI
local UnitPower = UnitPower
local SPELL_POWER_COMBO_POINTS = SPELL_POWER_COMBO_POINTS

local cpr = LibStub("AceAddon-3.0"):GetAddon("ComboPointsRedux")
local modName = "Combo Points"
local mod = cpr:NewModule(modName)

function mod:OnInitialize()
	self.abbrev = "CP"
	if select(3,UnitClass("player")) == 4 then
		if IsPlayerSpell(193531) then
			self.MAX_POINTS = 6
		elseif IsPlayerSpell(114015) then
			self.MAX_POINTS = 8
		elseif IsPlayerSpell(14983) then
			self.MAX_POINTS = 5
		else
			self.MAX_POINTS = 5
		end
	elseif select(3,UnitClass("player")) == 11 then
		if IsPlayerSpell(202157) or IsPlayerSpell(197490) or IsPlayerSpell(202155) or GetSpecialization() == 2 then
			self.MAX_POINTS = 5
		else
			self.MAX_POINTS = 0
		end
	else
		self.MAX_POINTS = 0
	end
	self.Count = UnitPower("player", SPELL_POWER_COMBO_POINTS)
	self.displayName = COMBAT_TEXT_SHOW_COMBO_POINTS_TEXT
	self.events = { ["UNIT_POWER"] = "Update", ["SPELLS_CHANGED"] = "UpdateMaxPoints", ["PLAYER_SPECIALIZATION_CHANGED"] = "UpdateMaxPoints" }
end

function mod:OnModuleEnable()
	self:RegisterEvent("UPDATE_SHAPESHIFT_FORM", "OnShapeshift")
end

local oldPoints = 0
function mod:Update()
	self.Count = UnitPower("player", SPELL_POWER_COMBO_POINTS)
	local CountForColor = 1
	if self.Count > 0 then
		local CountForColor = self.Count
	end
	local r, g, b = cpr:GetColorByPoints(modName, CountForColor)
	local a, a2 = cpr:GetAlphas(modName)
	
	if self.Count > 0 then
		if self.graphics then
			--6.0.2 bug?/feature, there is no zero event between spending CPs
			--and Anticipation stacks filling CPs
			--so, hide all the points before showing the appropriate number
			for i = 1, 8 do
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
			for i = 1, 8 do
				self.graphics.points[i].icon:SetVertexColor(r, g, b)
				self.graphics.points[i]:SetAlpha(a2)
			end
		end
		points = ""
		oldPoints = 0
	end
	if self.text then self.text:SetNumPoints(self.Count) end
end

function mod:UpdateMaxPoints()
	self.Count = UnitPower("player", SPELL_POWER_COMBO_POINTS)
	local a, a2 = cpr:GetAlphas(modName)
	
	if select(3,UnitClass("player")) == 4 then
		if IsPlayerSpell(193531) then
			self.MAX_POINTS = 6
		elseif IsPlayerSpell(114015) then
			self.MAX_POINTS = 8
		elseif IsPlayerSpell(14983) then
			self.MAX_POINTS = 5
		else
			self.MAX_POINTS = 5
		end
	elseif select(3,UnitClass("player")) == 11 then
		if IsPlayerSpell(202157) or IsPlayerSpell(197490) or IsPlayerSpell(202155) then
			self.MAX_POINTS = 5
		elseif GetSpecialization() == 2 then
			self.MAX_POINTS = 5
		else
			self.MAX_POINTS = 0
		end
	else
		self.MAX_POINTS = 0
	end
	
	if self.graphics then
		for i = 1, 8 do
			self.graphics.points[i]:Hide()
			self.graphics.points[i]:SetAlpha(a2)
		end
		for i = 1, self.MAX_POINTS do
			self.graphics.points[i]:Show()
		end
		if self.Count > 0 then
			for i = 1, self.Count do
				self.graphics.points[i]:SetAlpha(a)
			end
		end
	end
	cpr:UpdateSettings(modName)
end
	
function mod:OnShapeshift()
	local form = GetShapeshiftForm(true)
	--[[
	forms:
	0 - caster / treant
	1 - bear
	2 - cat
	3 - flight / aquatic
	4 - moonkin
	5 - 
	6 - stag
	]]
	
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
