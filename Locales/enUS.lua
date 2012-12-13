local AceLocale = LibStub:GetLibrary("AceLocale-3.0") 
local L = AceLocale:NewLocale("ComboPointsRedux", "enUS", true) 
if not L then return end 

L["%s Text"] = true
L["%s Graphics"] = true
L["Left click and drag to move the frame."] = true
L["To hide the background, open the options and select the 'Lock' option."] = true
