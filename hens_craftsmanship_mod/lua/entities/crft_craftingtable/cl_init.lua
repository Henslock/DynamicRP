include("shared.lua")

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Draw()
	if self.bounce == nil then self.bounce = 0 end
	self:DrawModel()

	if LocalPlayer():GetPos():Distance(self:GetPos()) < 550 then
		if(LocalPlayer():Team() ~= LUMBERJACK) then return end
		local alpha = (LocalPlayer():GetPos():Distance(self:GetPos()) / 100.0)
		alpha = math.Clamp(2.5 - alpha, 0 ,1)
		local a = Angle(0,0,0)
		a:RotateAroundAxis(Vector(1,0,0),90)
		a.y = LocalPlayer():GetAngles().y - 90
		local offset = Vector(0, 0, 65 + math.sin(self.bounce)*3)
		
		cam.Start3D2D(self:GetPos() + offset, a , 0.15)
			draw.SimpleText("Crafting Table","CraftingTableFont",0,0,Color(84, 211, 100,255*alpha) , 1 , 1)
		cam.End3D2D()
		
		cam.Start3D2D(self:GetPos() + offset, a , 0.08)
			draw.SimpleText("Press E to craft.","CraftingTableFont",0,65,Color(255,255,255,155*alpha) , 1 , 1)
		cam.End3D2D()
	end
	self.bounce = self.bounce + FrameTime()
end


