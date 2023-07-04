include("shared.lua")

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Draw()
	self:DrawModel()
	
	if self.time == nil then self.time = 0 end
	
	surface.SetFont("CrateFrontReg")
	local suppCrateTag = "Supply Crate"
	if(self:GetEntOwner() ~= NULL) then
		suppCrateTag = self:GetEntOwner():GetName().."'s Supply Crate"
	end
	
	local textwidth = surface.GetTextSize(suppCrateTag)
	local offset = 0
	local downPad = 40
	local ico = CRAFTSMANSHIP_MATS_DROP["mat_oakwood"].dropicon
	
	local oakcount = self:GetNWInt("mat_oakwood")
	local birchcount = self:GetNWInt("mat_birchwood")
	local maplecount = self:GetNWInt("mat_maplewood")
	
	local oaktag = "Oak Wood"
	local birchtag = "Birch Wood"
	local mapletag = "Maple Wood"
	
	local oakcol = CRAFTSMANSHIP_MATS_DROP["mat_oakwood"].dropcolor
	local birchcol = CRAFTSMANSHIP_MATS_DROP["mat_birchwood"].dropcolor
	local maplecol = CRAFTSMANSHIP_MATS_DROP["mat_maplewood"].dropcolor
	
	local emptycol = Color(255, 255, 255, 25)
	
	if LocalPlayer():GetPos():Distance(self:GetPos()) < 550 then
		local alpha = (LocalPlayer():GetPos():Distance(self:GetPos()) / 100.0)
		alpha = math.Clamp(2.5 - alpha, 0 ,1)
		local a = Angle(0,0,0)
		a:RotateAroundAxis(Vector(1,0,0),90)
		a.y = LocalPlayer():GetAngles().y - 90
		local emptyCol = Color(125, 125, 125, 125*alpha)
		
		cam.Start3D2D(self:GetPos() + Vector(0,0,45 + (math.sin(self.time*0.5)*2)), a , 0.15)
		
			draw.RoundedBox(3, -125, -100, 260, 125, Color(0,0,0,75*alpha))
			
			-- OAK
			if(oakcount >= 1 ) then
			draw.SimpleText(oaktag,"DropFont", -85,-offset, Color(255,255,255,155*alpha), 0, 1)
			draw.SimpleText("x"..oakcount,"DropFont", 85,-offset, Color(255,255,255,155*alpha), 0, 1)
				oakcol.a = 255*alpha
				surface.SetDrawColor(oakcol)
				surface.SetMaterial(Material(ico))
				surface.DrawTexturedRect(-120, -15 - offset, 32, 32)
			else
			draw.SimpleText(oaktag,"DropFont", -85,-offset, emptyCol, 0 , 1)
			draw.SimpleText("x"..oakcount,"DropFont", 85,-offset, emptyCol, 0, 1)
				surface.SetDrawColor(emptyCol)
				surface.SetMaterial(Material(ico))
				surface.DrawTexturedRect(-120, -15 - offset, 32, 32)
			end
			offset = offset + downPad
			
			-- BIRCH
			if(birchcount >= 1 ) then
			draw.SimpleText(birchtag,"DropFont", -85,-offset,Color(255,255,255,155*alpha), 0, 1)
			draw.SimpleText("x"..birchcount,"DropFont", 85,-offset,Color(255,255,255,155*alpha), 0, 1)
				birchcol.a = 255*alpha
				surface.SetDrawColor(birchcol)
				surface.SetMaterial(Material(ico))
				surface.DrawTexturedRect(-120, -15 - offset, 32, 32)
			else
			draw.SimpleText(birchtag,"DropFont", -85,-offset, emptyCol, 0, 1)
			draw.SimpleText("x"..birchcount,"DropFont", 85,-offset, emptyCol, 0, 1)
				surface.SetDrawColor(emptyCol)
				surface.SetMaterial(Material(ico))
				surface.DrawTexturedRect(-120, -15 - offset, 32, 32)
			end
			offset = offset + downPad
			
			-- MAPLE
			if(maplecount >= 1 ) then
			draw.SimpleText(mapletag,"DropFont", -85,-offset,Color(255,255,255,155*alpha), 0, 1)
			draw.SimpleText("x"..maplecount,"DropFont", 85,-offset,Color(255,255,255,155*alpha), 0, 1)
				maplecol.a = 255*alpha
				surface.SetDrawColor(maplecol)
				surface.SetMaterial(Material(ico))
				surface.DrawTexturedRect(-120, -15 - offset, 32, 32)
			else
			draw.SimpleText(mapletag,"DropFont", -85,-offset, emptyCol, 0, 1)
			draw.SimpleText("x"..maplecount,"DropFont", 85,-offset, emptyCol, 0, 1)
				surface.SetDrawColor(emptyCol)
				surface.SetMaterial(Material(ico))
				surface.DrawTexturedRect(-120, -15 - offset, 32, 32)
			end
			offset = offset + downPad
			
			draw.SimpleText(suppCrateTag,"CrateFrontReg", -textwidth*0.5 ,-offset,Color(255,255,255,155*alpha) , 0 , 1)
			
			draw.SimpleTextOutlined("Press E to collect.","CrateFrontSmall", 0, 40,Color(176, 244, 135,155*alpha) , 1 , 1, 0, Color(0,150,0,255*alpha))
			
		cam.End3D2D()
	end
	
	self.time = self.time + FrameTime()
end