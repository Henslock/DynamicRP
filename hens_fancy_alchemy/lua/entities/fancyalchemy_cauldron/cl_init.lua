include("shared.lua")

function ENT:Initialize()
	self.ing1 = nil

	self.ing2 = nil
	
	self.ing3 = nil
	
	self.ingAnim = false
	self.renderscale = 0.1
end

ENT.RenderGroup = RENDERGROUP_BOTH
local vmat = Matrix()

function ENT:Draw()
	self:DrawModel()
	local dirVec = ((LocalPlayer():GetPos()  - self:GetPos()):GetNormalized():Angle())
	dirVec = (self:WorldToLocalAngles(dirVec))
	
	if(self:GetMixing() == false) then self.renderscale = Lerp(FrameTime()*3, self.renderscale, 0.1) end
	if(self:GetMixing() == false) and (self.ingAnim == true) then
		timer.Simple(1, function()
			local cm1 = self.ing1
			local cm2 = self.ing2
			local cm3 = self.ing3
			if(cm1 ~= nil) then cm1:Remove() end
			if(cm2 ~= nil) then cm2:Remove() end
			if(cm3 ~= nil) then cm3:Remove() end
			self.ing1 = nil
			self.ing2 = nil
			self.ing3 = nil
		end)
		
		self.ingAnim = false
	end
	
	if(self.ingAnim == false and self:GetMixing() == true) then
		self.ingAnim = true

		self.ing1 = ClientsideModel(self:GetIngredientOne(), RENDERGROUP_BOTH)
		self.ing1:SetParent(self)
		
		self.ing2 = ClientsideModel(self:GetIngredientTwo(), RENDERGROUP_BOTH)
		self.ing2:SetParent(self)
		
		self.ing3 = ClientsideModel(self:GetIngredientThree(), RENDERGROUP_BOTH)
		self.ing3:SetParent(self)
	end
	
	if(self.ing1 ~= nil) then
		self.ing1:SetLocalPos(Vector(0, 0, 75) + (Vector(dirVec:Right())*30))
		self.ing1:SetAngles(Angle(0, RealTime() %360 * 50, 0))
		vmat:SetScale(Vector(self.renderscale, self.renderscale, self.renderscale))
		self.renderscale = Lerp(FrameTime(), self.renderscale, 1)
		self.ing1:EnableMatrix("RenderMultiply", vmat)
	end
	
	if(self.ing2 ~= nil) then
		self.ing2:SetLocalPos(Vector(0, 0, 75) )
		self.ing2:SetAngles(Angle(0, RealTime() %360 * 50, 0))
		self.ing2:EnableMatrix("RenderMultiply", vmat)
	end
	
	if(self.ing3 ~= nil) then
		self.ing3:SetLocalPos(Vector(0, 0, 75) + (Vector(dirVec:Right())*-30))
		self.ing3:SetAngles(Angle(0, RealTime() %360 * 50, 0))
		self.ing3:EnableMatrix("RenderMultiply", vmat)
	end

	
	if(LocalPlayer():Team() ~= WIZARD) then return end
	
	if LocalPlayer():GetPos():Distance(self:GetPos()) < 950 then
		local alpha = (LocalPlayer():GetPos():Distance(self:GetPos()) / 100.0)
		alpha = math.Clamp(2.5 - alpha, 0 ,1)
		local a = Angle(0,0,0)
		a:RotateAroundAxis(Vector(1,0,0),90)
		a.y = LocalPlayer():GetAngles().y - 90
		local offset = Vector(0,0,65) 
		
		if not (self:GetMixing()) then
			cam.Start3D2D(self:GetPos() + offset, a, 0.14)
				draw.SimpleText("Alchemist's Cauldron","FALCH_hoveringText",0,0,Color(84, 211, 100,255*alpha) , 1 , 1)
			cam.End3D2D()
			
			cam.Start3D2D(self:GetPos() + offset + Vector(0,0,1), a, 0.09)
				draw.SimpleText("Press E to brew potions.","FALCH_hoveringText",0,65,Color(255,255,255,155*alpha) , 1 , 1)
			cam.End3D2D()
		else
			local mixtime = math.max(0, math.Round( self:GetMixingTime() -  CurTime() ))

			cam.Start3D2D(self:GetPos() + offset, a, 0.14)
				draw.SimpleText("Mixing ","FALCH_hoveringText",0,-5,Color(255, 255, 255,255*alpha) , 1 , 1)
			cam.End3D2D()
			
			cam.Start3D2D(self:GetPos() + offset, a, 0.09)
				draw.SimpleText("Time Left: " .. mixtime,"FALCH_hoveringText",0,90,Color(255,255,255,155*alpha) , 1 , 1)
			cam.End3D2D()			
			
			local ratio = (CurTime() - self:GetStartMixingTime()) / self:GetTotalMixingTime()
			local x = Lerp(ratio, 0, 400)
			cam.Start3D2D(self:GetPos() + offset, a, 0.09)
				draw.RoundedBox(0, -200, 35, 400, 35, Color(0,0,0,125))
				draw.RoundedBox(0, -200, 35, x, 35, Color(84, 211, 100,125))
			cam.End3D2D()
		end
	end
end

function ENT:OnRemove()
	local cm1 = self.ing1
	local cm2 = self.ing2
	local cm3 = self.ing3
	  timer.Simple(0.05,
		function()
			if IsValid(self) then return end
			if(cm1 ~= nil) then cm1:Remove() end
			if(cm2 ~= nil) then cm2:Remove() end
			if(cm3 ~= nil) then cm3:Remove() end
	  end)
end