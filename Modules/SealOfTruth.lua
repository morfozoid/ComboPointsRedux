--[[
Author: Starinnia
CPR is a combo points display addon based on Funkydude's BasicComboPoints
SealofTruth.lua - A module for tracking Censure stacks
$Date: 2012-08-30 17:16:36 -0500 (Thu, 30 Aug 2012) $
$Revision: 267 $
Project Version: @project-version@
contact: codemaster2010 AT gmail DOT com

Copyright (c) 2007-2012 Michael J. Murray aka Lyte of Lothar(US)
All rights reserved unless otherwise explicitly stated.
]]

if select(2, UnitClass("player")) ~= "PALADIN" then return end

local UnitAura = UnitAura

local cpr = LibStub("AceAddon-3.0"):GetAddon("ComboPointsRedux")
local modName = "Seal of Truth"
local mod = cpr:NewModule(modName)
local buff = GetSpellInfo(31803)

function mod:OnInitialize()
	self.MAX_POINTS = 5
	self.displayName = GetSpellInfo(31801)
	self.abbrev = "SoT"
	self.events = { "UNIT_AURA", "PLAYER_TARGET_CHANGED" }
end

local oldCount = 0
function mod:UNIT_AURA(_, unit)
	if unit ~= "target" then return end
	
	local _, _, _, count = UnitAura("target", buff, nil, "PLAYER|HARMFUL")
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

function mod:PLAYER_TARGET_CHANGED()
	self:UNIT_AURA(nil, "target")
end
