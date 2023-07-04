include("shared.lua")

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Draw()
	self:DrawModel()

	local Pos = self:GetPos()
	local Eye1 = EyeAngles() 
	local Ang = Angle(0, Eye1.y, 0)
	local alpha = (LocalPlayer():GetPos():Distance(self:GetPos()) / 100.0)
	alpha = math.Clamp(1.75 - alpha, 0 ,1)
	
	local owner = self:Getowning_ent()
	owner = (IsValid(owner) and owner:Nick()) or DarkRP.getPhrase("unknown")

	surface.SetFont("HUDNumber5")
	local text = self:GetNWString("type")
	if(text == "") then
		text = "Scratched Ore"
	end
	local TextWidth = surface.GetTextSize(text)
	
	surface.SetFont("Trebuchet24")
	local tag = "ORE"
	local tagcol = Color(255, 255, 255, 255 * alpha)
	local tagcolbg = Color(0,0,0, 255 * alpha)
	local plr = player.GetByUniqueID(self:GetNWInt("ore_owner"))
	
	if (plr~=false) and (plr:GetNWInt("perk_voidore")>= 1) then
		tag = "VOID ".. tag
		tagcol = Color(241, 201, 255, 255*alpha)
		tagcolbg = Color(2, 0, 99, 255*alpha)
	end
	
	if (plr~=false) and (plr:GetNWBool("perk_oreprice")== true) then
		tag = "RICH ".. tag
	end
	
	local tagWidth = surface.GetTextSize(tag)

	Ang:RotateAroundAxis(Ang:Up(), 90)
	Ang:RotateAroundAxis(Ang:Forward(), 90)
	Ang:RotateAroundAxis(Ang:Right(), 180)
	
	local platecolour = GetColorTable(self:GetNWInt("rarity"))
	platecolour.a = 170*alpha
	
	--
	if LocalPlayer():GetPos():Distance(self:GetPos()) < 200 then
		cam.Start3D2D(Pos+Ang:Up()*0+Ang:Right()*-20, Ang, 0.18)
			draw.RoundedBox( 10, -TextWidth*0.5, 0, TextWidth+8, 37, platecolour or Color(0, 0, 0, 170 * alpha) )
			draw.SimpleTextOutlined( tag, "Trebuchet24", -tagWidth*0.5 + 5, -25, tagcol, 0, 0, 1, tagcolbg )
			draw.SimpleTextOutlined( text, "HUDNumber5", -TextWidth*0.5 + 5, 0, Color(255,255,255,255 * alpha), 0, 0, 1, Color(0,0,0, 255 * alpha) )
		cam.End3D2D()
	end
	
end