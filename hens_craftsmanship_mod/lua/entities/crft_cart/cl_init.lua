include("shared.lua")

function ENT:Draw()
	self:DrawModel()

	local Pos = self:GetPos()
	local Ang = self:GetAngles()
	local Ang2 = self:GetAngles()

	local owner = self:Getowning_ent()
	owner = (IsValid(owner) and owner:Nick()) or DarkRP.getPhrase("unknown")

	local TIMER;
	if (self:GetWoods() > 0) then
		TIMER = 1
	else 
		TIMER = 0
	end
	
	surface.SetFont("DropFont")
	local text =  owner
	local text2 = self:GetWoods().. " / ".. SWM_CART_MAX_LOGS
	local TextWidth = surface.GetTextSize(text)
	local TextWidth2 = surface.GetTextSize(text2)
	local text3 = self:GetWoods().."/"..SWM_CART_MAX_LOGS
	local TextWidth3 = surface.GetTextSize(text3)
	local width = ((TextWidth+10)/100)*((100/SWM_CART_MAX_LOGS)*self:GetWoods())
	
	local barwidth = 200
	local width2 = (barwidth/100)*((100/SWM_CART_MAX_LOGS)*self:GetWoods())
	
	local oakico = CRAFTSMANSHIP_MATS_DROP["mat_oakwood"].dropicon
	local birchico = CRAFTSMANSHIP_MATS_DROP["mat_oakwood"].dropicon
	local mapleico = CRAFTSMANSHIP_MATS_DROP["mat_oakwood"].dropicon
	
	local oakcol, birchcol, maplecol = Color(255, 255, 255, 35), Color(255, 255, 255, 35), Color(255, 255, 255, 35)
	
	if(self:GetNWInt("mat_oakwood")>=1) then
		oakcol = CRAFTSMANSHIP_MATS_DROP["mat_oakwood"].dropcolor
	end
	
	if(self:GetNWInt("mat_birchwood")>=1) then
		birchcol = CRAFTSMANSHIP_MATS_DROP["mat_birchwood"].dropcolor
	end
	
	if(self:GetNWInt("mat_maplewood")>=1) then
		maplecol = CRAFTSMANSHIP_MATS_DROP["mat_maplewood"].dropcolor
	end
	

	Ang:RotateAroundAxis(Ang:Up(), 90)
	Ang:RotateAroundAxis(Ang:Forward(), 90)
	Ang:RotateAroundAxis(Ang:Right(), 90)
	
	Ang2:RotateAroundAxis(Ang2:Up(), 90)
	Ang2:RotateAroundAxis(Ang2:Forward(), 90)
	Ang2:RotateAroundAxis(Ang2:Right(), 270)
	
	local color
	if (TIMER > 0) then
		color = {150, 50}
	else
		color = {0, 150}
	end
	
	if LocalPlayer():GetPos():Distance(self:GetPos()) < SWM_DISTANCE then
		cam.Start3D2D(Pos+Ang:Right()*-9.5+Ang:Up()*17+Ang:Forward()*-20, Ang, 0.12)
			draw.SimpleTextOutlined( "Wooden Cart", "DropFont", 24, 0, Color(255,255,255,255), 0, 0, 1, Color(0,0,0,150) )
			
			-- Oak
			surface.SetDrawColor(oakcol)
			surface.SetMaterial(Material(oakico))
			surface.DrawTexturedRect(200, 0, 32, 32)			
			
			-- Birch
			surface.SetDrawColor(birchcol)
			surface.SetMaterial(Material(birchico))
			surface.DrawTexturedRect(250, 0, 32, 32)			
			
			-- Maple
			surface.SetDrawColor(maplecol)
			surface.SetMaterial(Material(mapleico))
			surface.DrawTexturedRect(300, 0, 32, 32)
		cam.End3D2D()
		
		cam.Start3D2D(Pos+Ang:Right()*-4+Ang:Up()*17+Ang:Forward()*-17, Ang, 0.1)
			draw.RoundedBox( 10, -5, -4, TextWidth+10, 45, Color(0,0,0,150) )
			draw.SimpleTextOutlined( text, "DropFont", 0, 0, Color(255,255,255,255), 0, 0, 1, Color(0,0,0,150) )
		cam.End3D2D()

		cam.Start3D2D(Pos+Ang:Right()*1.5+Ang:Up()*17+Ang:Forward()*-17, Ang, 0.1)
			draw.RoundedBox( 10, -5, -4, barwidth, 45, Color(0,0,0,225) )
			draw.RoundedBox(	10, -6, -5, width2+2, 47, Color(50,225,100, color[1]) )
			draw.SimpleTextOutlined( text2, "DropFont", 0, 0, Color(225,255,225,255), 0, 0, 1, Color(0,50,0) )
		cam.End3D2D()
		
	end
end