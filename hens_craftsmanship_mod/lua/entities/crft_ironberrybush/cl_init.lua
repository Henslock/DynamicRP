include("shared.lua")
include("craftsmanship/crft_fontgen.lua")

ENT.RenderGroup = RENDERGROUP_BOTH

local barLerp = 0
local HarvestLerpAnim = 0
local HarvestRingBG = surface.PrecacheArc(0, 0,45,15,0, 360,10)
local HarvestRing = surface.PrecacheArc(0, 0,43,11, 360 + 90, 360 + 90, 1)

function ENT:Draw()
	self:DrawModel()
	if self.perc == nil then self.perc = 0 end
	local Pos = self:GetPos()
	local Eye1 = EyeAngles() 
	local Ang = Angle(0, Eye1.y, 0)

	surface.SetFont("TreeFont")
	local text = "Ironberry Bush"
	local TextWidth = surface.GetTextSize(text)
	
	Ang:RotateAroundAxis(Ang:Up(), 90)
	Ang:RotateAroundAxis(Ang:Forward(), 90)
	Ang:RotateAroundAxis(Ang:Right(), 180)

	if(self:GetNWFloat("crft_harvesttime") >= 1) then
		self.perc = math.Truncate((self:GetNWFloat("crft_harvesttime") - CurTime()) / IRONBERRY_HARVESTTIME, 2)
		if(self.perc <= 0) then
			self.perc = 0
		end
		HarvestRingBG = surface.PrecacheArc(0, 0,45,15,0, 360,10)
		HarvestRing = surface.PrecacheArc(0, 0,43,11, 360*self.perc + 90, 360 + 90, 1)
		HarvestLerpAnim = Lerp(FrameTime(), HarvestLerpAnim, self.perc)
	end
	
	--print(math.abs(math.sin(self.barLerp)))
	if LocalPlayer():GetPos():Distance(self:GetPos()) < 550 then
		if(LocalPlayer():Team() ~= LUMBERJACK) then return end
		local alpha = (LocalPlayer():GetPos():Distance(self:GetPos()) / 100.0)
		alpha = math.Clamp(2.5 - alpha, 0 ,1)
		
		cam.Start3D2D(Pos+Ang:Right()*-60, Ang, 0.16)
			draw.SimpleTextOutlined( text, "TreeFont", -TextWidth*0.5, 0, Color(255,255,255,255*alpha), 0, 0, 1, Color(24, 24, 89, 125*alpha) )
		cam.End3D2D()

		cam.Start3D2D(Pos+Ang:Right()*-60 + Vector(0, 0, -4), Ang, 0.11)
			draw.SimpleTextOutlined( "Press E to Harvest.", "TreeFont", 0, 0, Color(162, 217, 249,255*alpha), 1, 0, 1, Color(24, 68, 29, 125*alpha) )
		cam.End3D2D()
		
		if(self:GetNWBool("crft_isinuse") == true) then
			cam.Start3D2D(Pos+Ang:Right()*-60 + Vector(0, 0, -15), Ang, 0.12)
			
				draw.SimpleTextOutlined( math.Truncate(self.perc * IRONBERRY_HARVESTTIME, 1), "TreeFont", 0, -10, Color(255, 255, 255 ,255*alpha), 1, 0, 1, Color(24, 68, 29, 125*alpha) )
				
				draw.NoTexture()
				surface.SetDrawColor(Color(0, 0, 50, 125))
				surface.DrawArc(HarvestRingBG)
				
				surface.SetDrawColor(Color(162, 217, 249, 200))
				surface.DrawArc(HarvestRing)
			cam.End3D2D()
		end
		
	end
end