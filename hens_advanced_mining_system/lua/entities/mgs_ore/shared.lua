ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "[DGS] Ore"
ENT.Author = "James"
ENT.Spawnable = true

function ENT:SetupDataTables()
	self:NetworkVar("Int",0,"price")
	self:NetworkVar("Entity",1,"owning_ent")
end

function GetColorTable(rarity)
	if(rarity == RARITY_COMMON) then
		return Color(125, 125, 125)
	elseif(rarity == RARITY_UNCOMMON) then
		return Color(75, 244, 66)
	elseif(rarity == RARITY_RARE) then
		return Color(65, 128, 244)
	elseif(rarity == RARITY_EPIC) then
		return Color(155, 55, 255)
	elseif(rarity == RARITY_LEGENDARY) then
		return Color(244, 112, 65)
	else
		return Color(155, 155, 155)
	end
end