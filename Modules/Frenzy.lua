--[[
Author: Starinnia
CPR is a combo points display addon based on Funkydude's BasicComboPoints
Frenzy.lua - A module for tracking Frenzy Effect stacks on a hunter's pet
$Date: 2012-08-30 17:16:36 -0500 (Thu, 30 Aug 2012) $
$Revision: 267 $
Project Version: @project-version@
contact: codemaster2010 AT gmail DOT com

Copyright (c) 2007-2012 Michael J. Murray aka Lyte of Lothar(US)
All rights reserved unless otherwise explicitly stated.
]]

if select(2, UnitClass("player")) ~= "HUNTER" then return end

local UnitBuff = UnitBuff

local cpr = LibStub("AceAddon-3.0"):GetAddon("ComboPointsRedux")
local modName = "Frenzy Effect"
local mod = cpr:NewModule(modName)
local buff = GetSpellInfo(19615)

function mod:OnInitialize()
	self.abbrev = "FE"
	self.MAX_POINTS = 5
	self.displayName = buff
	self.events = { "UNIT_AURA", "UNIT_PET" }
end

local oldCount = 0
function mod:UNIT_AURA(_, unit)
	if unit ~= "pet" then return end
	
	local _, _, _, count = UnitBuff("pet", buff)
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

function mod:UNIT_PET(_, unit)
	if unit == "player" then
		return self:UNIT_AURA(nil, "pet")
	end
end
