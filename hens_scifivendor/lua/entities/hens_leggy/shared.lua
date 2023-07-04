ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.PrintName = "Leggy"
ENT.Author = "Henslock"
ENT.Spawnable = true
ENT.Category = "[Hens] Sci Fi Vendor"
ENT.AdminSpawnable = true
ENT.AutomaticFrameAdvance = true

// FONT GEN
if CLIENT then

	surface.CreateFont( "Leggy_FontItalic", {
		font = "Century Gothic",
		extended = false,
		size = 28,
		weight = 400,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = true,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = true,
		additive = false,
		outline = false ,
	} )	
	
	surface.CreateFont( "Leggy_CostItalic", {
		font = "Century Gothic",
		extended = false,
		size = 48,
		weight = 600,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = true,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = true,
		additive = false,
		outline = false ,
	} )	
	
	surface.CreateFont( "Leggy_Buttons", {
		font = "Century Gothic",
		extended = false,
		size = 26,
		weight = 600,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = true,
		additive = false,
		outline = false ,
	} )

end


function ENT:SetAutomaticFrameAdvance( anim )
	self.AutomaticFrameAdvance = anim
end 

if CLIENT then

	local width = 550
	local height = 185

	-- INITIAL PANEL --

	local PANEL = {}

	function PANEL:Init()
			--Init look
		
		self:MakePopup()
		self:SetDeleteOnClose(true)
		self:SetDraggable(true)
		self:ShowCloseButton(false)
		self:SetTitle("")
		self:SetSize(width, height)
		self:Center()
		self:SetAlpha(1)
		self:AlphaTo(255, 0.5, 0)
		
		self.Paint = function(self)
			draw.RoundedBox(5, 0, 0, width, height, Color(0, 0, 0, 235))
		end
		
		-- Exit Button
		self.closeBtn = self:Add("DButton")
		self.closeBtn:SetPos( width - 30, 5)
		self.closeBtn:SetSize(20, 20)
		self.closeBtn:SetText("")
		self.closeBtn.HoverLerp = 0
		
		self.closeBtn.DoClick = function()
			self:Close()
		end
		
		self.closeBtn.Paint = function(s, w, h)
			if s:IsHovered() then
				s.HoverLerp = Lerp( FrameTime() * 10, s.HoverLerp, 1 )
			else
				s.HoverLerp = Lerp( FrameTime() * 10, s.HoverLerp, 0.1 )
			end
			draw.RoundedBox(5, 0, 0, w, h, Color(255, 255, 255, 255* s.HoverLerp))
		end
		
		self.promptext = self:Add("DLabel")
		self.promptext:SetText("Do you wish to accept Leggy's boon?")
		self.promptext:SetFont("Leggy_FontItalic")
		self.promptext:SizeToContents()
		self.promptext:SetPos(0, 30)
		self.promptext:SetColor(Color(255,255,255))
		self.promptext:CenterHorizontal()
		
		self.costtext = self:Add("DLabel")
		self.costtext:SetText("$" .. string.Comma(LEGGY_BUFFCOST))
		self.costtext:SetFont("Leggy_CostItalic")
		self.costtext:SizeToContents()
		self.costtext:SetPos(0, 60)
		self.costtext:SetColor(Color(98, 196, 249))
		self.costtext:CenterHorizontal()
		
		
		// BUTTONS

		self.NO = self:Add("DButton")
		self.NO:SetPos( width/2 - 120, height*0.65)
		self.NO:SetSize(110, 40)
		self.NO:SetText("")
		self.NO.HoverLerp = 0
		
		local nolbl = self.NO:Add("DLabel")
		nolbl:SetText("NO")
		nolbl:SetFont("Leggy_Buttons")
		nolbl:SizeToContents()
		nolbl:Center()
		
		self.NO.DoClick = function()
			surface.PlaySound("npc/headcrab_poison/ph_talk2.wav")
			self:Close()
		end
		
		self.NO.Paint = function(s, w, h)
			if s:IsHovered() then
				s.HoverLerp = Lerp( FrameTime() * 10, s.HoverLerp, 1 )
			else
				s.HoverLerp = Lerp( FrameTime() * 10, s.HoverLerp, 0.5 )
			end
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 255* s.HoverLerp))
		end
	
		self.NO.PaintOver = function(_, w, h)
			surface.SetDrawColor(Color(255, 255, 255, 125 * self.NO.HoverLerp), 1, 1)
			surface.DrawOutlinedRect(0, 0, w, h)
		end
		
		//
		
		self.YES = self:Add("DButton")
		self.YES:SetPos( width/2 + 20, height*0.65)
		self.YES:SetSize(110, 40)
		self.YES:SetText("")
		self.YES.HoverLerp = 0
		
		local yeslbl = self.YES:Add("DLabel")
		yeslbl:SetText("YES")
		yeslbl:SetFont("Leggy_Buttons")
		yeslbl:SizeToContents()
		yeslbl:Center()
		
		self.YES.DoClick = function()
			surface.PlaySound("npc/headcrab_poison/ph_talk3.wav")
			
			net.Start("leggy_buybuff")
				net.WriteEntity(LocalPlayer())
			net.SendToServer()
			self:Close()
		end
		
		self.YES.Paint = function(s, w, h)
			if s:IsHovered() then
				s.HoverLerp = Lerp( FrameTime() * 10, s.HoverLerp, 1 )
			else
				s.HoverLerp = Lerp( FrameTime() * 10, s.HoverLerp, 0.5 )
			end
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 255* s.HoverLerp))
		end
		
		self.YES.PaintOver = function(_, w, h)
			surface.SetDrawColor(Color(255, 255, 255, 125 * self.YES.HoverLerp), 1, 1)
			surface.DrawOutlinedRect(0, 0, w, h)
		end
		
	end

	vgui.Register("LeggyPanel:Main", PANEL, "DFrame")

	net.Receive("leggy_menu_open", function()
		vgui.Create("LeggyPanel:Main")
	end)

end

if SERVER then
	util.AddNetworkString("leggy_buybuff")
	
	net.Receive("leggy_buybuff", function()
		local ply = net.ReadEntity()
		
		local plymoney = ply:getDarkRPVar("money")
		
		if(ply:GetNWBool("leggy_buff") == true) then
			ply:ChatPrint("You already have Leggy's boon.")
			return
		end
		
		if(plymoney>= LEGGY_BUFFCOST) then
			ply:ChatPrint("You feel empowered.")
			ply:addMoney(LEGGY_BUFFCOST *-1)
			ply:SetNWBool("leggy_buff", true)
			ply:EmitSound("ambient/levels/canals/toxic_slime_gurgle5.wav")
		else
			ply:ChatPrint("You cannot afford his gift.")
			return
		end
		
	end)
end