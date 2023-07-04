include('shared.lua')

ENT.RenderGroup = RENDERGROUP_BOTH
local vmat = Matrix()

function ENT:Draw()
	if (self.rotRate == nil) then self.rotRate = 0 end
	if (self.rotInc == nil) then self.rotInc = 1 end
	local angs = self:GetAngles()
	vmat:SetAngles(angs)
	vmat:SetTranslation(Vector(0, 0, -48))
	vmat:Invert()
	vmat:Rotate(Angle(0, 1 * self.rotRate, 90))
	
	self:EnableMatrix("RenderMultiply", vmat)
	
	self.Entity:DrawModel()
	
	self.rotRate = (self.rotRate + FrameTime() * self.rotInc)
	self.rotInc = self.rotInc + 0.3
end


