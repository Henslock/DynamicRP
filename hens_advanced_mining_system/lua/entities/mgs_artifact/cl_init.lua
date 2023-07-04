include("shared.lua")

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Draw()
	self:DrawModel()

	local Pos = self:GetPos()
	local Eye1 = EyeAngles() 
	local Ang = Angle(0, Eye1.y, 0)

	local owner = self:Getowning_ent()
	owner = (IsValid(owner) and owner:Nick()) or DarkRP.getPhrase("unknown")

	surface.SetFont("HUDNumber5")
	local name = ""
	if(player.GetByUniqueID(self:GetNWInt("a_owner")) ~= false) then
		name = player.GetByUniqueID(self:GetNWInt("a_owner")):GetName()
	end
	local text = "Ancient Artifact"
	
	local perkowner = player.GetByUniqueID(self:GetNWInt("a_owner"))
	
	if(perkowner ~= false) then
		if(perkowner:GetNWBool("perk_axp") == true) then
			text = "Forbidden "..text
		end
	end
	
	local tag = "Press E to sell for $"..self:GetNWInt("a_price")
	local exptext = "And Gain "..self:GetNWInt("a_exp").." EXP!"

	local NameWidth = surface.GetTextSize(name)
	local TextWidth = surface.GetTextSize(text)
	local TagWidth = surface.GetTextSize(tag)
	local ExpWidth = surface.GetTextSize(exptext)

	Ang:RotateAroundAxis(Ang:Forward(), 90)
	Ang:RotateAroundAxis(Ang:Right(), -90)
	Ang:RotateAroundAxis(Ang:Right(), 180)

	if LocalPlayer():GetPos():Distance(self:GetPos()) < 400 then
		cam.Start3D2D(Pos+Ang:Up()*0+Ang:Right()*-50, Ang, 0.13)
		
			--BG draw
			if(perkowner ~= false) then
				if(perkowner:GetNWBool("perk_axp") == true) then
					draw.RoundedBox( 4, -TagWidth*0.5 - 40, -2, TagWidth+80, 100, Color(50,0,50,170) )
				else
					draw.RoundedBox( 4, -TagWidth*0.5 - 20, -2, TagWidth+40, 100, Color(0,0,0,170) )
				end
			else
				draw.RoundedBox( 4, -TagWidth*0.5 - 20, -2, TagWidth+40, 100, Color(0,0,0,170) )
			end
			draw.SimpleTextOutlined( name, "HUDNumber5", -NameWidth*0.5, -40, Color(0,0,0,255), 0, 0, 1, Color(255, 255, 255) )
			draw.SimpleTextOutlined( text, "HUDNumber5", -TextWidth*0.5 + 5, 0, Color(233,158,255,255), 0, 0, 1, Color(117, 40, 139) )
			
			--Price tag
			if(perkowner ~= false) then
				if(perkowner:GetNWBool("perk_artprice") == true) then
					draw.SimpleTextOutlined( tag, "HUDNumber5", -TagWidth*0.5, 30, Color(255,255,255,255), 0, 0, 1, HSVToColor(RealTime() * 100 % 360, 1, 1) )
				else
					draw.SimpleTextOutlined( tag, "HUDNumber5", -TagWidth*0.5, 30, Color(255,255,255,255), 0, 0, 1, Color(117, 40, 139) )
				end
			else
				draw.SimpleTextOutlined( tag, "HUDNumber5", -TagWidth*0.5, 30, Color(255,255,255,255), 0, 0, 1, Color(117, 40, 139) )
			end
			
			draw.SimpleTextOutlined( exptext, "HUDNumber5", -ExpWidth*0.5, 60, Color(123,204,255,255), 0, 0, 1, Color(15, 52, 75) )
		cam.End3D2D()
	end
end