--[[
Author: Starinnia
CPR is a combo points display addon based on Funkydude's BasicComboPoints
BanditsGuile.lua - A module for tracking the Bandit's Guile buffs
$Date: 2012-08-30 17:16:36 -0500 (Thu, 30 Aug 2012) $
$Revision: 267 $
Project Version: @project-version@
contact: codemaster2010 AT gmail DOT com

Copyright (c) 2007-2012 Michael J. Murray aka Lyte of Lothar(US)
All rights reserved unless otherwise explicitly stated.
]]

if select(2, UnitClass("player")) ~= "ROGUE" then return end

local UnitBuff = UnitBuff

local cpr = LibStub("AceAddon-3.0"):GetAddon("ComboPointsRedux")
local modName = "Bandits Guile"
local mod = cpr:NewModule(modName)

local SHALLOW_INSIGHT = GetSpellInfo(84745)
local MODERATE_INSIGHT = GetSpellInfo(84746)
local DEEP_INSIGHT = GetSpellInfo(84747)

function mod:OnInitialize()
	self.abbrev = "BG"
	self.MAX_POINTS = 3
	self.displayName = GetSpellInfo(84654)
	self.events = { "UNIT_AURA" }
end

local oldCount = 0
function mod:UNIT_AURA(_, unit)
	if unit ~= "player" then return end
	
	local _, _, _, shallow = UnitBuff("player", SHALLOW_INSIGHT)
	local _, _, _, moderate = UnitBuff("player", MODERATE_INSIGHT)
	local _, _, _, deep = UnitBuff("player", DEEP_INSIGHT)
	
	local r, g, b
	if shallow then
		if self.graphics then
			r, g, b = cpr:GetColorByPoints(modName, 1)
			
			self.graphics.points[1].icon:SetVertexColor(r, g, b)
			self.graphics.points[1]:Show()
		end
		
		if self.text then self.text:SetNumPoints(1) end
		
		--should prevent spamming issues when UNIT_AURA fires and
		--the aura we care about hasn't changed
		if oldCount ~= 1 then
			oldCount = 1
			cpr:DoFlash(modName, 1)
		end
	elseif moderate then
		if self.graphics then
			r, g, b = cpr:GetColorByPoints(modName, 2)
			
			self.graphics.points[1].icon:SetVertexColor(r, g, b)
			self.graphics.points[2].icon:SetVertexColor(r, g, b)
			self.graphics.points[2]:Show()
		end
		
		if self.text then self.text:SetNumPoints(2) end
		
		--should prevent spamming issues when UNIT_AURA fires and
		--the aura we care about hasn't changed
		if oldCount ~= 2 then
			oldCount = 2
			cpr:DoFlash(modName, 2)
		end
	elseif deep then
		if self.graphics then
			r, g, b = cpr:GetColorByPoints(modName, 3)
			
			self.graphics.points[1].icon:SetVertexColor(r, g, b)
			self.graphics.points[2].icon:SetVertexColor(r, g, b)
			self.graphics.points[3].icon:SetVertexColor(r, g, b)
			self.graphics.points[3]:Show()
		end
		
		if self.text then self.text:SetNumPoints(3) end
		
		--should prevent spamming issues when UNIT_AURA fires and
		--the aura we care about hasn't changed
		if oldCount ~= 3 then
			oldCount = 3
			cpr:DoFlash(modName, 3)
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
