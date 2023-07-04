ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "[MGS] Rock Tier 4"
ENT.Author = "Hens"
ENT.Spawnable = true

function ENT:SetupDataTables()
	self:NetworkVar("Int",0,"price")
	self:NetworkVar("Entity",1,"owning_ent")
end

function GrabLevelColor(lvl)
	if ( lvl == 1 or lvl == 2 or lvl == 3) then
		return Color(255,252,224,255)
		
	elseif (lvl == 4 or lvl == 5 or lvl == 6) then 
		return Color(185, 255, 158, 255)
		
	elseif (lvl == 7 or lvl == 8 or lvl == 9) then 
		return Color(200, 136, 255, 255)
		
	elseif (lvl == 10 or lvl == 11 or lvl == 12) then 
		return Color(243, 153, 47, 255)
		
	else
		return Color(255, 53, 181)
		
	end
end