include('shared.lua')

ENT.RenderGroup = RENDERGROUP_BOTH
local vmat = Matrix()

function ENT:Draw()
	if self.timeframe == nil then
		self.timeframe = (CurTime() + self:GetFallingTime()) 
	end
	if self.starttime== nil then self.starttime = CurTime() end
	
	local timeratio = math.Clamp((CurTime() - self.starttime) / (self.timeframe - self.starttime), 0, 1) 
	local angs = self:GetAngles()
	vmat:SetAngles(angs)
	vmat:SetTranslation(Vector(0, 0,  Lerp(timeratio, 3000, 0) ))
	
	self:EnableMatrix("RenderMultiply", vmat)
	self.Entity:DrawModel()
end


