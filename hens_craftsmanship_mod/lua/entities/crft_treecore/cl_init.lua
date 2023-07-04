include("shared.lua")

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Draw()
	self:DrawModel()
	
	if self.time == nil then self.time = 0 end
	surface.SetFont("DropFont")
	local name = CRAFTSMANSHIP_MATS_DROP["mat_treecore"].name
	local ico = nil
	local icoColor = Color(255,255,255,255)
	
	ico = CRAFTSMANSHIP_MATS_DROP["mat_treecore"].dropicon
	icoColor = CRAFTSMANSHIP_MATS_DROP["mat_treecore"].dropcolor
	
	local textwidth = surface.GetTextSize(name)
	
	if LocalPlayer():GetPos():Distance(self:GetPos()) < 550 then
		if(LocalPlayer():Team() ~= LUMBERJACK) then return end
		local alpha = (LocalPlayer():GetPos():Distance(self:GetPos()) / 100.0)
		alpha = math.Clamp(2.5 - alpha, 0 ,1)
		local a = Angle(0,0,0)
		a:RotateAroundAxis(Vector(1,0,0),90)
		a.y = LocalPlayer():GetAngles().y - 90
		cam.Start3D2D(self:GetPos() + Vector(0,0,25 + (math.sin(self.time*0.5)*3)), a , 0.15)
			if(ico ~= nil) then
				icoColor.a = 255 * alpha
				surface.SetDrawColor(icoColor)
				surface.SetMaterial(Material(ico))
				surface.DrawTexturedRect(-textwidth*0.5 -40, -16, 32, 32)
			end
		
			draw.SimpleText(name,"DropFont", -textwidth*0.5,0,Color(255,255,255,155*alpha) , 0 , 1)
		cam.End3D2D()
	end
	
	self.time = self.time + FrameTime()
end