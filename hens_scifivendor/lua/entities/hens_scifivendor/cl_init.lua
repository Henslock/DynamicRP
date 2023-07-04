include("shared.lua")

surface.CreateFont( "SciFi_Tag", {
	font = "Verdana",
	extended = false,
	size = 48,
	weight = 600,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = true,
	outline = false ,
} )

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Draw()
	self:DrawModel()

	if LocalPlayer():GetPos():Distance(self:GetPos()) < 550 then
		local alpha = (LocalPlayer():GetPos():Distance(self:GetPos()) / 100.0)
		alpha = math.Clamp(2.5 - alpha, 0 ,1)
		local a = Angle(0,0,0)
		a:RotateAroundAxis(Vector(1,0,0),90)
		a.y = LocalPlayer():GetAngles().y - 90
		cam.Start3D2D(self:GetPos() + Vector(0,0,75), a , 0.08)
			draw.RoundedBox(15,-205,-75,400,75 , Color(0, 0, 0, 200 * alpha))
			local tri = {{x = -25 , y = 0},{x = 25 , y = 0},{x = 0 , y = 25}}
			surface.SetDrawColor(Color(0, 0, 0, 200 * alpha))
			draw.NoTexture()
			surface.DrawPoly( tri )

			draw.SimpleText("Sci-fi Weapons","SciFi_Tag",0,-40,Color(255,255,255,235*alpha) , 1 , 1)
		cam.End3D2D()
	end
end

function ENT:DrawTranslucent()
	self:DrawModel()
end

