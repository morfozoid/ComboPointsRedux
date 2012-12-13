--[[
Author: Starinnia
CPR is a combo points display addon based on Funkydude's BasicComboPoints
WildMushroom.lua - A module for tracking Wild Mushrooms
$Date: 2012-08-30 17:16:36 -0500 (Thu, 30 Aug 2012) $
$Revision: 267 $
Project Version: @project-version@
contact: codemaster2010 AT gmail DOT com

Copyright (c) 2007-2012 Michael J. Murray aka Lyte of Lothar(US)
All rights reserved unless otherwise explicitly stated.
]]

if select(2, UnitClass("player")) ~= "DRUID" then return end

local GetTotemTimeLeft = GetTotemTimeLeft

local cpr = LibStub("AceAddon-3.0"):GetAddon("ComboPointsRedux")
local modName = "Wild Mushroom"
local mod = cpr:NewModule(modName)
local buff = GetSpellInfo(88747)

function mod:OnInitialize()
	self.abbrev = "WM"
	self.MAX_POINTS = 3
	self.displayName = buff
	self.events = { "PLAYER_TOTEM_UPDATE" }
end

local oldCount = 0
function mod:PLAYER_TOTEM_UPDATE()
	local count = 0
	if GetTotemTimeLeft(1) > 0 then count = count + 1 end
	if GetTotemTimeLeft(2) > 0 then count = count + 1 end
	if GetTotemTimeLeft(3) > 0 then count = count + 1 end
	
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
		
		--should prevent spamming issues when PLAYER_TOTEM_UPDATE fires and
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
