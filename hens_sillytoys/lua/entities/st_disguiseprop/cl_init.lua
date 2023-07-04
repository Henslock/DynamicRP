include('shared.lua')

ENT.RenderGroup = RENDERGROUP_BOTH
local vmat = Matrix()


function ENT:Draw()
	local min, max = self:GetModelBounds()

	local angs = self:GetAngles()
	local rotamnt = self:GetRotAmount()
	vmat:SetTranslation(Vector(0, 0,  -math.abs(min[3])))
	vmat:SetAngles(angs)
	vmat:Invert()
	vmat:Rotate(Angle(0, rotamnt, 0))
	
	self:EnableMatrix("RenderMultiply", vmat)

	self.Entity:DrawModel()
	

end


