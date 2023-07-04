include("shared.lua")

ENT.RenderGroup = RENDERGROUP_BOTH
local vmat = Matrix()
function ENT:Draw()
	if self.bounceanim == nil then self.bounceanim = 0 end
	self:DrawModel()
	
	local angs = self:GetAngles()
	vmat:SetAngles(angs)
	vmat:SetTranslation(Vector(0, 0, -15 + math.sin(self.bounceanim) * 1.5 ))
	vmat:Invert()

	self:EnableMatrix("RenderMultiply", vmat)
	self.bounceanim = self.bounceanim + FrameTime()

end